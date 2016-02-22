function argout = displayHist(I)
%DISPLAYHIST display histogram of a greyscale or RGB image.
%   argout = displayHist(I) uses a greyscale or color image matrix I and 
%   plots the histogram of this image.  If the image is greyscale, imhist 
%   is used, if the image is RGB the image is broken up into color 
%   components and then plotted using subplot 
%   
%   Any image that is not greyscale or RGB will produce an error
% 
% Preconditions:  Image matrix passed to function.
% Post conditions:  Produces a plot of the image histogram
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/19/16

if (size(I,3) == 1) %greyscale
    imhist(I);
elseif (size(I,3) == 3) %color
    [red, rx]=imhist(I(:,:,1));     %break up into component histograms
    [green, gx]=imhist(I(:,:,2));
    [blue, bx]=imhist(I(:,:,3));
    subplot(1,3,1);                 %create a plot with all 3 components
    bar(rx,red,'r');
    xlim([0 rx(end)]);
    title('Red Component')
    xlabel('Intensity')
    ylabel('Number of Pixels')
    subplot(1,3,2);
    bar(gx,green,'g');
    xlim([0 gx(end)]);
    title('Green Component')
    xlabel('Intensity')
    ylabel('Number of Pixels')
    subplot(1,3,3);
    bar(bx,blue, 'b');
    xlim([0 bx(end)]);
    title('Blue Component')
    xlabel('Intensity')
    ylabel('Number of Pixels')
else    %not greyscale or RGB
    error('Currently only supports RGB and gresyscale.');
end