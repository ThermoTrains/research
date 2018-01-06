clear all; clc; close all;

I = imread('img/2017-11-29@10-58-30-IR.seq.jpg');
J = I;
imshow(I);

I = rgb2gray(I);
I = adapthisteq(I);
figure;
imshow(I);

[rows cols] = size(I);
xmin = 0;
ymin = rows * 2/3;
width = cols;
height = rows - ymin;
rect = [xmin ymin width height];
I = imcrop(I, rect);
figure;
imshow(I);
imwrite(I, 'cropped.jpg');

% I = imbinarize(I, 0.6);
% I = adaptthresh(I);
imwrite(I, 'bw.jpg');

[centers, radii, metric] = imfindcircles(I,[25 70],'ObjectPolarity', 'bright', 'Sensitivity', 0.9);
finalFig = figure;
imshow(J);
viscircles(centers + [0, ymin], radii,'Color','b');

centers = sort(centers, 1);
[rows cols] = size(centers);
relDiff = zeros(rows, 1);
prev = 0;
for i=1:rows
    relDiff(i) = centers(i, 1) - prev;
    prev = centers(i, 1);
end
max = max(relDiff);
max = max * 0.9;
groups = zeros(rows, 1);
nr = 1;
for i=1:rows
    dist = relDiff(i);
    if dist < max
        groups(i) = nr;
    else
        nr = nr + 1;
        groups(i) = nr;
    end
end

centers = [centers(:,1) groups];
figure(finalFig);
[maxY maxX] = size(J);
prev_car = 0;
for i=1:nr
    [row, col] = find(centers == i);
    count = size(row);
    count = count(1,1);
    if count >= 3
        first = centers(row(1), 1);
        last = centers(row(count), 1);
        middle = (first + last) / 2;
        line([middle middle], [0 maxY], 'LineWidth', 5);
        xmin = prev_car;
        ymin = 0;
        width = middle - prev_car;
        height = maxY;
        rect = [xmin ymin width height];
        C = imcrop(J, rect);
        imwrite(C, sprintf('car_%d.jpg', i))
        prev_car = middle;
    end
end
xmin = prev_car;
ymin = 0;
width = maxX - prev_car;
height = maxY;
rect = [xmin ymin width height];
C = imcrop(J, rect);
imwrite(C, sprintf('car_%d.jpg', nr+1))
