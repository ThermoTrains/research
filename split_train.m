clear all; clc; close all;

I = imread('img/2017-11-29@10-58-30-visible.jpg');
I = rgb2gray(I);
I = imgaussfilt(I);
[h,w] = size(I);
% line = I(140,:);
line = I(int32(h/2),:);
x = (1:w);
y = line;
plot(x, y);