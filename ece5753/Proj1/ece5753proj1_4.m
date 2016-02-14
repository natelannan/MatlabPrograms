clear all
close all
clc

load normed_speech.mat
%data=sh4_2;
data=sh4_7;
pads=zeros(120,1);
padded=cat(1, pads, data,pads);


frame_len=241;
frame_shift=1;
num_frames=fix(length(data)/frame_shift-frame_len/frame_shift);

enThresh=2;
zcrThresh=0.5;
classify = zeros(length(data),1);

for i=1:num_frames
    frame=padded(((i-1)*frame_shift+1):(i*frame_shift+frame_len));
    energy(i)=sum(frame.*frame);
    zcr(i) = sum(abs(diff(frame>0)))/frame_len;
    if energy(i)>enThresh
        classify(i)=1;
    elseif zcr(i)>zcrThresh
        classify(i)=.5;
    else
        classify(i)=0;
    end     
end

figure(1)
plot(data./max(data), 'r')
hold on
plot(classify, 'k')
legend('Normalized Data', 'Classification')
title('Simple Classification for sh4\_2')
axis([0 inf -1.3 1.3])

