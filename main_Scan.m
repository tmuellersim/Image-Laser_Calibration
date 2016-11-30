% clearvars
close all
clc

%% Parameters
intThresh = 220; % Threshold for intensity values, below which all values are mapped to some color, integer from 1-255
scanFilename = './data/scan_data/scan4.txt';
imgFilename = '/data/image_data/scan4.jpg';

%% Import data from files.
scanDataCell = importScanData(scanFilename);
scanData = loadScanData(scanDataCell);  % returns structure scanData
displayScanData(scanData, intThresh);  % Display scan data

img = imread(imgFilename);
figure
imshow(img);
%% Find three points in line scan data


%% Find lines in image
imgLines = extractEdges(img);