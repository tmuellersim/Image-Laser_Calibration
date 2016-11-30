function [ lines ] = extractEdges( img )
% Take in image, threshold, and peform line detection
%   For dark images with green edges on calibration marker

%% Adjust contrast of RGB image
% imgConv = imadjust(img,[0.95 0.025 0.95; 1 0.2 1],[]);

%% Convert to HSV
imgHSV = rgb2hsv(img);

% Create mask matrix the same size as the input image
imgMask = zeros(size(img, 1), size(img, 2));

% Threshold image
imgMask(imgHSV(:,:,1)>0.35 & imgHSV(:,:,1)<0.66 & ...
        imgHSV(:,:,2)>0.5 & imgHSV(:,:,2)<1.00 &...
        imgHSV(:,:,3)>0.1 & imgHSV(:,:,3)<0.99) = 1;

% imgMask(imgHSV(:,:,2) < 0.97) = 1;
% imgMask(imgHSV(:,:,2) > 0.2) = 1;

% imgMask(imgHSV(:,:,3) > 0.5) = 0;
% imgMask(imgHSV(:,:,3) < 0.99) = 1;
%% Edge detection
% Morphological operations, remove objects in image with connected pixels
% less than some value, effectively removes noise
% imgMask1 = bwmorph(imgMask, 'hbreak');
% imgMask1 = bwmorph(imgMask, 'close');
imgMask1 = bwareaopen(imgMask, 50);
% imgMask2 = bwmorph(imgMask1, '');

figure()
imshowpair(imgMask, imgMask1, 'montage')
% figure()
% imshowpair(img, imfuse(imgMask1, img, 'blend'), 'montage')

[H,T,R] = hough(imgMask1, 'Theta', -15:.1:15, 'RhoResolution', 0.1);

P = houghpeaks(H,5,'threshold',ceil(0.1*max(H(:))));

lines = houghlines(imgMask1,T,R,P,'FillGap',25,'MinLength',50);

figure()
imshow(img)
hold on

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

hold off
end
