%% Colorize scan data and reconstruct using odometry
clearvars
close all
clc

%% Parameters
scanFilename = './reconstruction_data/data/scan-7-11.txt';
odomFilename = './reconstruction_data/data/odom-7-11.txt';
imageHeaderFilename = './reconstruction_data/data/image_header-7-11.txt';

imageStart = 73;  % Image to start with, seems to have been a delay in extracting images and image header

% Calculate TF from base_link to laser
gamma = pi/2+0.262;  % yaw
beta = 0;  % pitch
alpha = pi/2;  % roll
tx = 0.707;
ty = 0.0;
tz = 0.658;

Rx = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
R = Rz*Ry*Rx;
t = [tx; ty; tz];
baseTF = [R t; 0 0 0 1];

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

%% Build odometry using twist values for robot
[odomData] = filterOdomData(odomData);

%% Apply transform to scanPoints using odometry and rigid transform from base_link to laser
[scanData] = applyTFtoScanPoints(scanData, odomData, baseTF, idxOdom);

%% Pass images into colorize points, get back large array of colorized and uncolorized points
numScans = length(scanData.stamp);

figure
hold on 
for i = 1:numScans
    scatter3(scanData.positionTF(1,:, i), scanData.positionTF(2,:, i), scanData.positionTF(3,:, i), '.')
    view(3)
    drawnow
end
hold off
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
view(3)





