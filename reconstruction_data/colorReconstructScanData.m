%% Colorize scan data and reconstruct using odometry
clearvars
close all
clc

%% Parameters
scanFilename = './reconstruction_data/data/scan-7-11.txt';
odomFilename = './reconstruction_data/data/odom-7-11.txt';
imageHeaderFilename = './reconstruction_data/data/image_header-7-11.txt';

%% Import scan data
scanDataCell = importScanData(scanFilename);
scanData = loadSequentialScanData(scanDataCell);  % returns structure scanData

%% Import image header data
imageDataCell = importImageHeaderData(imageHeaderFilename);
imageData = loadImageHeaderData(imageDataCell);

%% Import odometry data, extract pose information
odomDataCell = importOdomData(odomFilename);
odomData = loadOdomData(odomDataCell);

%% Find smallest time in data
[minTime, minTimeIdx] = min([imageData.stamp(1) odomData.stamp(1) scanData.stamp(1)]);
% Bring all time stamps to the start of the earliest datum received
imageData.stamp = imageData.stamp - minTime;
odomData.stamp = odomData.stamp - minTime;
scanData.stamp = scanData.stamp - minTime;
% Convert from nanoseconds to seconds
imageData.stamp = imageData.stamp/1e9;
odomData.stamp = odomData.stamp/1e9;
scanData.stamp = scanData.stamp/1e9;

%% Sync time stamps to scan data, as that is stream with the lowest frequency
[idxImage, dImage] = dsearchn(imageData.stamp, scanData.stamp);
[idxOdom, dOdom] = dsearchn(odomData.stamp, scanData.stamp);

imageData = imageData(:, idxImage);

%% Build odometry using twist values for robot






