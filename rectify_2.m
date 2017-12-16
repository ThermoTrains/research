clear all; clc; close all;

I = imread('/Users/rlaubscher/projects/bfh/thermotrains/target/3-distorted/0002.jpg');
O = I;
imshow(I);
pause;
figure;

[y,x,z] = size(I);
rect = [0, y - (y/3), x, y/3];
% rect = [0, 0, x, y/3];
I = imcrop(I, rect);
imshow(I);
pause;
figure;

% I = adaptthresh(I);
% imshow(I);
% pause;
% figure;

I = I - 50;
imshow(I);
pause;
figure;

I = imgaussfilt(I, 3);
imshow(I);
pause;
figure;

I = edge(I,'Canny', [0.1, 0.35]);
imshow(I);
pause;
figure;

[H,theta,rho] = hough(I);
P = houghpeaks(H,5);
lines = houghlines(I,theta,rho,P);

figure, imshow(I), hold on
max_len = 0;
% offset_y = y - y/3;
offset_y = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2) + offset_y,'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2) + offset_y,'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2) + offset_y,'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2) + offset_y,'LineWidth',2,'Color','red');
