function [ lines ] = extractEdges( img, manualTrace )
% Take in image, threshold, and peform line detection
%   For dark images with green edges on calibration marker
% Inputs: 
%   img         <- Image with calibration marker in it
%   manualTrace <- flag to indicate user input for lines in leiu of
%                   automagic extraction
% Outputs:
%   lines       <- 3 pairs of points [x1 x2; x3 x4; x5 x6] indicating
%                   endpoints of extracted lines of calibration target

%% Manually input 3 lines if manualTrace is set to true
if manualTrace
    
    figure
    imshow(img);
  
    [x, y] = ginput(2);
    % Assumption about input is 3 individual lines describing calibration target lines
    pt1 = [x(1) y(1) 1]';
    pt2 = [x(2) y(2) 1]';
    axis tight
    hold on
    plot([pt1(1) pt2(1)], [pt1(2), pt2(2)],'Color','g','LineWidth',1)
    hold off
    clearvars x y
    [x, y] = ginput(2);
    pt3 = [x(1) y(1) 1]';
    pt4 = [x(2) y(2) 1]';
    hold on
    plot([pt3(1) pt4(1)], [pt3(2), pt4(2)],'Color','g','LineWidth',1)
    hold off
    clearvars x y
    [x, y] = ginput(2);
    pt5 = [x(1) y(1) 1]';
    pt6 = [x(2) y(2) 1]';
    axis tight
    hold on
    plot([pt5(1) pt6(1)], [pt5(2), pt6(2)],'Color','g','LineWidth',1)
    hold off
    clearvars x y
    
    lines = [pt1(1:2)' pt2(1:2)'; pt3(1:2)' pt4(1:2)'; pt5(1:2)' pt6(1:2)'];
   return 
end
%% Adjust contrast of RGB image
% imgConv = imadjust(img,[0.95 0.025 0.95; 1 0.2 1],[]);

%% Convert to HSV
imgHSV = rgb2hsv(img);

% Create mask matrix the same size as the input image
imgMaskHSV = zeros(size(img, 1), size(img, 2));

% Threshold image
imgMaskHSV(imgHSV(:,:,1)>0.30 & imgHSV(:,:,1)<0.66 & ...
        imgHSV(:,:,2)>0.5 & imgHSV(:,:,2)<1.00 &...
        imgHSV(:,:,3)>0.1 & imgHSV(:,:,3)<0.99) = 1;

% imgMask(imgHSV(:,:,2) < 0.97) = 1;
% imgMask(imgHSV(:,:,2) > 0.2) = 1;

% imgMask(imgHSV(:,:,3) > 0.5) = 0;
% imgMask(imgHSV(:,:,3) < 0.99) = 1;

%% Use RGB color space
imgRGB = img;
% Apply a gaussian blur to the image
imgRGB = imgaussfilt(imgRGB, 0.5);
% Create mask matrix the same size as the input image
imgMaskRGB = zeros(size(img, 1), size(img, 2));
% Threshold image
% imgMaskRGB(imgRGB(:,:,2)>15 & imgRGB(:,:,1)<20) = 1;
imgMaskRGB(imgRGB(:,:,2)>15) = 1;

%% Edge detection
% Morphological operations, remove objects in image with connected pixels
% less than some value, effectively removes remaining noise
imgMask1 = bwareaopen(imgMaskRGB, 25);
% imgMask1 = edge(imgMask1, 'canny',[], sqrt(8));

% figure()
% imshowpair(imgRGB, imgMask1, 'montage')
% figure()
% imshowpair(img, edge(rgb2gray(imgaussfilt(imgRGB, 2))), 'montage')
% figure()
% imshowpair(img, imfuse(imgMask1, img, 'blend'), 'montage')

[H,T,R] = hough(imgMask1,'ThetaResolution', 1, 'RhoResolution', 20);

P = houghpeaks(H,100,'threshold',ceil(0.25*max(H(:))),'NHoodSize', 2.*round((size(H)/200+1)/2)-1); % Ensures an odd number, change the divisor of size(H)

minLength = 100;
lines = houghlines(imgMask1,T,R,P,'FillGap',25,'MinLength', minLength);
while size(lines,2)<6
    minLength = round(minLength*0.5)
    lines = houghlines(imgMask1,T,R,P,'FillGap',25,'MinLength', minLength);
end
%% Find the longest 3 lines in the image
% lengthLines = zeros(1, length(lines));
% theta = zeros(1, length(lines));
% rho = zeros(1, length(lines));
point1 = zeros(2, length(lines));
point2 = zeros(2, length(lines));
linexy = zeros(2, length(lines));  % slope-intercept of line
for i = 1:length(lines)
%     lengthLines(i) = norm(lines(i).point1-lines(i).point2);
%     theta(i) = lines(i).theta;
%     rho(i) = lines(i).rho;
    point1(:, i) = lines(i).point1;
    point2(:, i) = lines(i).point2;
    linexy(1, i) = (point2(2, i) - point1(2, i))/(point2(1, i) - point1(1, i));
    linexy(2, i) = point1(2, i) - linexy(1, i)*point1(1, i);
end

% Use k means to find cluster of 3 lines
[~, C] = kmeans(linexy', 3, 'Replicates', 10);


figure()
imshow(img)
hold on
xMax = size(img,2);
plot([0 xMax], [C(1,2) (C(1,1)*xMax+C(1,2))])
plot([0 xMax], [C(2,2) (C(2,1)*xMax+C(2,2))])
plot([0 xMax], [C(3,2) (C(3,1)*xMax+C(3,2))])
hold off

%% Plot found lines
% hold on
% 
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'b--', 'LineWidth', 2);
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% end
% 
% hold off

%% Build out 3x3 matrix of lines, with each column being a consecutive line
C = sortrows(C, 2);
lines = zeros(3,3);
for i = 1:3
    point1Temp = [0 C(i, 2) 1];
    point2Temp = [xMax (C(i,1)*xMax+C(i,2)) 1];
    lines(:, i) = cross(point1Temp, point2Temp);
end

end
