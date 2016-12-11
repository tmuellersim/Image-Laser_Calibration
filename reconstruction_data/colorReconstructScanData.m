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

%% Build odometry using twist values for robot
