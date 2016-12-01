% clearvars
clear
close all
clc

%% Parameters
intThresh = 220; % Threshold for intensity values, below which all values are mapped to some color, integer from 1-255
scanFilename = 'scan_data/scan4.txt';
imgFilename = 'image_data/scan4.jpg';

%% Import data from files.
% scanDataCell = importScanData(scanFilename);
% scanData = loadScanData(scanDataCell);  % returns structure scanData
% displayScanData(scanData, intThresh);  % Display scan data

% img = imread(imgFilename);
% figure
% imshow(img);
%% Find three points in line scan data


%% Find lines in image
% imgLines = extractEdges(img);

%% Select Lines manually

linefeats_img = zeros(3, 3);

img_src = imread(imgFilename);
figure(1); imshow(img_src); hold on;
title('Select the three lines by choosing 6 end points in order')
[x, y] = ginput(6);
save linefeats.mat x y
% load linefeats.mat
plot(x,y, 'x', 'MarkerSize', 6, 'LineWidth', 1.5, 'Color', [0 0 0]);
line([x(1) x(2)], [y(1) y(2)], 'LineWidth', 1.5, 'Color', [1 0 0]);
line([x(3) x(4)], [y(3) y(4)], 'LineWidth', 1.5, 'Color', [0 1 0]);
line([x(5) x(6)], [y(5) y(6)], 'LineWidth', 1.5, 'Color', [0 0 1]);

pt1 = [x(1) y(1) 1]'; pt2 = [x(2) y(2) 1]';
pt3 = [x(3) y(3) 1]'; pt4 = [x(4) y(4) 1]';
pt5 = [x(5) y(5) 1]'; pt6 = [x(6) y(6) 1]';

% Lines passing through pairs of points
linefeats_img(1, :) = cross(pt1, pt2);
linefeats_img(2, :) = cross(pt3, pt4);
linefeats_img(3, :) = cross(pt5, pt6);

%% Select Lines from Hough Transform

% linefeats_img = zeros(3, 3);

% for k = 1:length(imgLines)
%     pt1 = [imgLines(k).point1' ; 1];
%     pt2 = [imgLines(k).point2' ; 1];
%     linefeats_img(k, :) = cross(pt1, pt2);
% end

%% Project 3D point from laser space to image space

syms alpha beta gamma;
syms tx ty tz;
Rx = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
R = Rz*Ry*Rx;
t = [tx; ty; tz];

laserPts = [-0.75 0 1; -0.5 0 0.8; -0.25 0 1.2];

ptfeats_img(1, :) = transpose(R*laserPts(1,:)' + t);
ptfeats_img(2, :) = transpose(R*laserPts(2,:)' + t);
ptfeats_img(3, :) = transpose(R*laserPts(3,:)' + t);

K = [876.6696869482506, 0.0, 641.474789020357; 0.0, 876.061675156031, 484.4027190618026; 0.0, 0.0, 1.0];
ptfeats_img(1, :) = (K*ptfeats_img(1, :)')';
ptfeats_img(2, :) = (K*ptfeats_img(2, :)')';
ptfeats_img(3, :) = (K*ptfeats_img(3, :)')';

%% Minimize distance between lines and projected points in image space

errFunTot = 0;
ptfeats_img = [ptfeats_img(:,1)./ptfeats_img(:,3) ptfeats_img(:,2)./ptfeats_img(:,3) ptfeats_img(:,3)./ptfeats_img(:,3)];
errFunTot = errFunTot + computeError(ptfeats_img, linefeats_img);

%% Levenberg-Marquardt Minimization

options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
x0 = [.1, .1, .1, 1, 1, 1];
lb = []; %[-3.14, -3.14, -3.14, -10, -10, -10];
ub = []; %[3.14, 3.14, 3.14, 10, 10, 10];
lsqnonlin(@errFunTotFile, x0, lb, ub)

%% Debugging

% fun = matlabFunction(errFunTot, 'File', 'errFunTotFile');
ptfeats_img_val = subs(ptfeats_img, {alpha, beta, gamma, tx, ty, tz}, {0, 0, 0, 0, 0.25, 0});
ptfeats_img_val = double(ptfeats_img_val);
pause(0.5); figure(10); imshow(img_src); hold on;
plot(ptfeats_img_val(:,1), ptfeats_img_val(:,2), 'x', 'MarkerSize', 8, 'LineWidth', 1.5, 'Color', [1 0 0]);

% alpha = x(1);
% beta = x(2);
% gamma = x(3);
% tx = x(4);
% ty = x(5);
% tz = x(6);
