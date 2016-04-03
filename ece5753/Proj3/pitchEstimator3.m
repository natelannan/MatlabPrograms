function [ pitches,newfs ] = pitchEstimator3( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

speechVector=parseInput(varargin{:});
frame_len=240;
frame_shift=120;
LPCorder=6;
num_frames=fix(length(speechVector)/frame_shift-(frame_len/frame_shift-1));
fs=8000;

lowerBound=50;      %ignore results below this pitch (Hz)
upperBound=400;     %ignore results above this pitch (Hz)
rp = 0.001;           % Passband ripple
rs = 30;          % Stopband ripple
f = [800 1200];    % Cutoff frequencies
A = [1 0];        % Desired amplitudes
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)];
[n,fo,ao,w] = firpmord(f,A,dev,fs);
b = firpm(n,fo,ao,w);
filteredShift=zeros(ceil(frame_len/frame_shift), frame_len+length(b)-1);
estShift=zeros(ceil(frame_len/frame_shift), frame_len+LPCorder-1);
oldFiltered=zeros(1,frame_len+length(b)-1);
oldResidual=zeros(1,frame_len+LPCorder);
buffSize=3;
buff=zeros(buffSize,frame_len);
estFreq=zeros(1,num_frames);
enThresh=.2;




for i=1:num_frames+(buffSize-1)
    %=====================Step 1&2=========================================
    buff=circshift(buff, [-1 0]);  %move next frame forward in line
    if i<=num_frames %if no more frames to buffer, just work with remaining
        frame=speechVector(((i-1)*frame_shift+1):((i-1)*frame_shift+frame_len));
        buff(buffSize,:)=frame; %put new frame at end of line
    else  %get rid of old frames for prediction at end of signal
        buff(buffSize,:)=zeros(1,frame_len);
    end
    if i>=buffSize %do stuff if buffer filled
%         currentFrame=buff(1,:);
        %currentEn=sum(frame.*frame);
        for k=1:buffSize
            for j=1:ceil(frame_len/frame_shift)
                filtered=conv(buff(k,((j-1)*frame_shift+1:j*frame_shift)),b);
                filteredShift(j,((j-1)*frame_shift+1):(j*length(filtered)-(j-1)*(length(b)-1)))=filtered';
        %         filteredShift(j,:)=padarray(filteredShift(j,:),[0 j*frame_shift],'pre');
        %         filteredShift(j,:)=padarray(filteredShift(j,:),[0 frame_len-j*frame_shift],'post');
            end
            if i==buffSize
                filteredFrame=sum(filteredShift);
            else
                filteredFrame=oldFiltered(k,:)+filteredShift(j,:);
            end
            oldFiltered(k,1:end-frame_shift)=filteredFrame(frame_shift+1:end);
            currentEn=sum(filteredFrame.*filteredFrame);
            rectangle=filteredFrame(1:frame_len)';
            %=====================Step 3===========================================
            hammingWeight=hamming(frame_len).*rectangle;


            Aframe=lpc(hammingWeight, LPCorder);
            %=====================Step 4===========================================
        % LPC help:
        %     est_x = filter([0 -a(2:end)],1,x);  % Estimated signal
        %     e = x - est_x;                      % Prediction error
        %     [acs,lags] = xcorr(e,'coeff');      % ACS of prediction error

        %     estFrame=conv([0 -Aframe(2:end)],1,rectangle);
            for j=1:ceil(frame_len/frame_shift)
                estimate=conv(rectangle((j-1)*frame_shift+1:j*frame_shift),[0 -Aframe(2:end)]);
                estShift(j,((j-1)*frame_shift+1):(j*length(estimate)-(j-1)*(LPCorder)))=estimate;
        %         filteredShift(j,:)=padarray(filteredShift(j,:),[0 j*frame_shift],'pre');
        %         filteredShift(j,:)=padarray(filteredShift(j,:),[0 frame_len-j*frame_shift],'post');
            end
            if i==buffSize
                residual=sum(estShift);
            else
                residual=oldResidual(k,:)+estShift(j,:);
            end
            oldResidual(k,1:end-frame_shift)=residual(frame_shift+1:end);

            %=====================Step 5===========================================
            ACresidual = xcorr(residual,'coeff');  %coeff - normalize
                                                    %biased - scales by 1/M
                                                    %unbiased - scales by
                                                    %1/(M-abs(lags))
            %ACresidual = ACresidual/max(ACresidual);
            %=====================Step 6===========================================
            [val, indx] = findpeaks(ACresidual,'MinPeakHeight',0.4);
            zeroLag = find(indx==frame_len+LPCorder);
            if (~isempty(zeroLag) && (length(indx) > 1) && (zeroLag ~= length(indx))) %more than one peak
                %firstPeak = indx(zeroLag+1)-frame_len;
                sorted=sort(val,'descend');
                fundLoc=find(val==sorted(2));

                fund = abs(indx(fundLoc)-indx(zeroLag));
                if ((fund(1) < fs/upperBound) || (fund(1) > fs/lowerBound) || (currentEn < enThresh))
                    fund=Inf(1);
                end
            else %only 1 peak at lag zero.  freq essentially 0.
                %firstPeak = Inf(1);
                fund=Inf(1);
            end
        %estFreq(i)=fs/firstPeak;
            preEstimate(k)=fs/fund(1);
        end
        currSpot=i-(buffSize-1);
        if(currSpot)==2 %to do: make #past values variable 
            predictor=cat(2,estFreq(1),preEstimate);
            medianOut=medfilt1(predictor);  %3 point median filter
            estFreq(currSpot)=medianOut(currSpot);
        elseif(currSpot)>2
            predictor=cat(2,estFreq(i-(buffSize+1):i-buffSize),preEstimate);
            medianOut=medfilt1(predictor);  %3 point median filter
            estFreq(currSpot)=medianOut(3);
        else
            predictor=preEstimate;
            medianOut=medfilt1(predictor);  %3 point median filter
            estFreq(currSpot)=medianOut(currSpot);
        end
%         estFreq(currSpot)=preEstimate(1);
    end     %do nothing while filling buff
    %xaxis=(1:length(ACresidual))-(frame_len+LPCorder);

    %plot(xaxis,ACresidual)
% compare=filteredFrame(1:length(sanityFrame))'; %use this for LPC?
% result=compare-sanityFrame;   
%     
% subplot(2,1,1)
% plot(compare)
% subplot(2,1,2)
% plot(sanityFrame)
end


pitches=estFreq;
newfs=ceil(fs*length(pitches)/(length(speechVector)));
%pitches=resample(pitches,length(speechVector),length(pitches));
end       %step 8

%%%
%%% Subfunction parseInputs
%%%
function [speechVector] = parseInput(varargin)
    if ~(nargin == 1 || nargin == 2)
        usage = ['pitchEstimator: Usage: arg1 - speech file or ' ...
            'vector arg2 - optional variable name to be loaded' ... 
            ' with .mat file'];
        error(usage);
        
    end
    if isa(varargin{1},'double')
        dims=size(varargin{1});
        if numel(dims) ~= 2
            error('pitchEstimator:Speech vector should be N by 1.'); 
        elseif find(dims==1)==1
            varargin{1}=varargin{1}';
            speechVector=varargin{1};
        elseif find(dims==1)==2
            speechVector=varargin{1};
        else
            error('pitchEstimator: Speech vector should be N by 1.');
        end
    elseif isa(varargin{1}, 'char')
        [~,~,ext] = fileparts(varargin{1});
        if strcmp(ext,'.wav')
            [speechVector,~]=audioread(varargin{1});
        elseif strcmp(ext,'.mat')
            loadedFile=load(varargin{1},varargin{2});
            speechVector=loadedFile.(varargin{2});
        else
            error('pitchEstimator: No current support for this file type.');
        end
    else
        error('pitchEstimator: Unsupported input.');
    end
end
        
        
        