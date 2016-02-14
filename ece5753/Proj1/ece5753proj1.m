clear all
close all
clc

load normed_speech.mat
% data=sh4_2;
data=sh4_7;

frame_len=320;
frame_shift=10;
num_frames=fix(length(data)/frame_shift-frame_len/frame_shift);

for i=1:num_frames
    frame=data(((i-1)*frame_shift+1):(i*frame_shift+frame_len));
    energy(i)=sum(frame.*frame);
    zcr(i) = sum(abs(diff(frame>0)))/frame_len;
end

% subplot(2,1,1), plot(energy)
% title('Short time energy, sh4\_2, N=320, rectangular')
% subplot(2,1,2), plot(data)
% title('sh4\_2')

dataAxis=0:length(data)-1;
interpEnergy=resample(energy,length(data),length(energy));
interpZCR = resample(zcr,length(data),length(zcr));

figure(1)
plot(dataAxis, data./max(data), 'r')
hold on
plot(dataAxis, interpEnergy./max(energy), 'k')
legend('Normalized Data', 'Normalized Energy')
title('Short time energy for sh4\_2')
axis([0 inf -1.3 1.3])

%soundsc(data',8000)

rectang = ones(frame_len,1);
recPad = padarray(rectang, ceil((1024-length(rectang))/2));
hambone = hamming(frame_len);
hamPad = padarray(hambone, ceil((1024-length(hambone))/2));
fftRec = fft(recPad)/length(recPad);
fftHam = fft(hamPad)/length(hamPad);
figure(2)
semilogy(abs(fftRec)/abs(fftRec(1)), 'b')
hold on 
semilogy(abs(fftHam)/abs(fftHam(1)), 'r')
legend('Rectangular window', 'Hamming window')

figure(3)
plot(dataAxis, data./max(data), 'r')
hold on
plot(dataAxis, interpZCR./max(zcr), 'k')
legend('Normalized Data', 'Normalized zero crossing rate')
title('Short time zero crossing rate for sh4\_2')
axis([0 inf -1.3 1.3])

figure(4)
plot(interpEnergy, 'r')
hold on
plot(interpZCR, 'k')
legend('Normalized Energy', 'Normalized zero crossing rate')
title('Threshold inspection sh4\_2')
%axis([0 inf -1.3 1.3])

fish = data(13650:20320);
% soundsc(fish);

frame_len=320;
frame_shift=10;
num_frames=fix(length(fish)/frame_shift-frame_len/frame_shift);

for i=1:num_frames
    frame=fish(((i-1)*frame_shift+1):(i*frame_shift+frame_len));
    fishEnergy(i)=sum(frame.*frame);
    fishZCR(i) = sum(abs(diff(frame>0)))/frame_len;
end


%fishAxis=0:length(fish)-1;
%fishInterpEnergy=resample(fishEnergy,length(fish),length(fishEnergy));
%fishInterpZCR = resample(fishZcr,length(fish),length(fishZcr));

figure(5)
plot(fishEnergy./max(fishEnergy), 'r')
hold on
plot(fishZCR./max(fishZCR), 'k')
legend('Normalized Energy', 'Normalized zero crossing rate')
title('Short time ZCR and energy for "fish"')
axis([0 inf -1.3 1.3])