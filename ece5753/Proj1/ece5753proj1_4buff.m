clear all
close all
clc

load normed_speech.mat
data=sh4_2;
% data=sh4_7;
pads=zeros(120,1);
padded=cat(1, pads, data,pads);


frame_len=241;
frame_shift=1;
num_frames=fix(length(data)/frame_shift-frame_len/frame_shift);

enThresh=1.5;
zcrThresh=0.1;
enThresh2=.02;
classify = zeros(length(data),1);
buffSize=50;
buff=zeros(buffSize,2);

for i=1:num_frames
    frame=padded(((i-1)*frame_shift+1):(i*frame_shift+frame_len));
    if i < buffSize+1
        buff(i,1)=sum(frame.*frame);
        buff(i,2) = sum(abs(diff(frame>0)))/frame_len;
    else
        currEN = buff(1,1);
        currZCR = buff(1,2);
        buff=circshift(buff, [-1 0]);
        buff(buffSize,1)=sum(frame.*frame);
        buff(buffSize,2) = sum(abs(diff(frame>0)))/frame_len;
        
        avEN = mean(buff(:,1));
        avZCR = mean(buff(:,2));
        
        if (i-(buffSize+1))>0
            prev=classify(i-(buffSize+1));
        else
            prev=0;
        end
        
        if (currEN > enThresh) && (currZCR > zcrThresh)
            if (prev == 1) || (avEN > enThresh)
                classify(i-buffSize)=1;
            elseif (prev == .5) || (avZCR > zcrThresh)
                if (avEN > enThresh2)
                    classify(i-buffSize)=.5;
                else
                    classify(i-buffSize)=0;
                end
            else
                classify(i-buffSize)=0;
            end
        elseif (currEN > enThresh)
            if (prev == 1) || (avEN > enThresh)
                classify(i-buffSize)=1;
            else
                classify(i-buffSize)=prev;
            end
        elseif (currZCR > zcrThresh)
            if (prev == .5) || (avZCR > zcrThresh)
                if (avEN > enThresh2)
                    classify(i-buffSize)=.5;
                else
                    classify(i-buffSize)=0;
                end
            else
                classify(i-buffSize)=prev;
            end
        else
            if(prev)
                if avEN > enThresh
                    classify(i-buffSize)=1;
                elseif avZCR > zcrThresh
                    if (avEN > enThresh2)
                        classify(i-buffSize)=.5;
                    else
                        classify(i-buffSize)=0;
                    end
                else
                    classify(i-buffSize)=0;
                end
            else
                classify(i-buffSize)=0;
            end
            
        end
%         if avEN > 1.5*enThresh
%             enThresh = 1.5*enThresh;
%         elseif avEN < enThresh/1.5
%             enThresh = enThresh/1.5;
%         end
        
%         if avZCR > 1.5*zcrThresh
%             zcrThresh = 1.5*zcrThresh;
%         elseif avZCR < zcrThresh/1.5
%             zcrThresh = zcrThresh/1.1;
%         end
%          
    end
end

enCross = (buff > enThresh);
zcrCross = (buff > zcrThresh);
%out = zeros(buffSize,1);
out = enCross(:,1) + zcrCross(:,2)*.5;
m=find(out==1.5);
out(m) = 1;
classify(end-(buffSize-1):end) = out;

figure(10)
plot(data./max(data), 'r')
hold on
plot(classify, 'k')
legend('Normalized Data', 'Classification')
title('Simple Classification for sh4\_2')
axis([0 inf -1.3 1.3])