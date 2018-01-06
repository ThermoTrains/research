clear all; clc; close all;

I = imread('img/2017-11-29@10-58-30-visible.jpg');
[H S V] = rgb2hsv(I);
[rows, columns] = size(V);

V = imgaussfilt(V, 3);  
V = imbinarize(V, 0.15);
% V = imcomplement(V);
se = strel('diamond',10);
V = imerode(V,se);
V = imcrop(V, [0, 0, columns, int16(rows * 2/3)]);
imshow(V);

[rows, columns] = size(V);
hist = zeros(1, columns);
for i = 1:columns
    withinRange = 0;
    for j = 1:rows
        if V(j, i) > 0
            withinRange = withinRange + 1;
        end
    end
    hist(i) = withinRange;
end

figure;
plot((1:columns), hist);