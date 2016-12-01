% clearvars
close all
clc

%% Parameters
intThresh = 220; % Threshold for intensity values, below which all values are mapped to some color, integer from 1-255
scanFilename = './scan_data/scan4.txt';
imgFilename = '/image_data/scan4.jpg';
manualTrace = 1;  % Manually trace the lines in the image if set to 1, automatic line extraction if 0

%% Import data from files.
scanDataCell = importScanData(scanFilename);
scanData = loadScanData(scanDataCell);  % returns structure scanData
displayScanData(scanData, intThresh);  % Display scan data

img = imread(imgFilename);
figure
imshow(img);
%% Find three points in line scan data


%% Find lines in image
imgLines = extractEdges(img, manualTrace);