clear all
close all
clc
% read image, convert into gray scale 
imdata = imread('test1.jpg');
% coin is the gray image
coin = 0.2989*(imdata(:,:,1))+0.5870*(imdata(:,:,2))+0.1140*(imdata(:,:,3));
figure();
imshow(coin,'InitialMagnification','fit');
title('the grayscale image');


% edge detection 
imbin = edge(coin,'canny');
imshow(imbin,'InitialMagnification','fit');
title('the edge image');

% Hough Transform
% locate the coins on RGB image
rmin=20;rmax=80;  %depend on the size of coin, use possible wide range of radius
p=0.25; % quarter circle
houghcircle = HoughCoin(imbin,rmin,rmax,p);
figure();
imshow(imdata,'InitialMagnification','fit');
title('circles detected with HT');
hold on;
viscircles([houghcircle(:,1) houghcircle(:,2)], houghcircle(:,3), 'EdgeColor', 'red', 'LineWidth',4);
hold off;

