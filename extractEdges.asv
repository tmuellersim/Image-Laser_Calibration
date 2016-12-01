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
