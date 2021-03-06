clear;
clc;
close all;

%% Initial Variables

imgfile_src = 'image_data';
scanfile_src = 'scan_data';

numFrames = 20;
linefeats_img_all = zeros(3,3,numFrames);
pointfeats_laser_all = zeros(4,3,numFrames);

%% Read and store feature data from all frames

for i = 1:numFrames
    
    % Load Image Line Features
    imgfile = [imgfile_src '/calibrationImage' sprintf('%4.4d', i-1) '.mat'];
    load(imgfile);
    pt1 = [imgLines(1,1); imgLines(1,2); 1]; pt2 = [imgLines(1,3); imgLines(1,4); 1];
    pt3 = [imgLines(2,1); imgLines(2,2); 1]; pt4 = [imgLines(2,3); imgLines(2,4); 1];
    pt5 = [imgLines(3,1); imgLines(3,2); 1]; pt6 = [imgLines(3,3); imgLines(3,4); 1];
    linefeats_img_all(:, 3, i) = cross(pt1, pt2);
    linefeats_img_all(:, 2, i) = cross(pt3, pt4);
    linefeats_img_all(:, 1, i) = cross(pt5, pt6);
    
    % Load Scan Point Features
    scanfile  = [scanfile_src '/scan' sprintf('%1.1d', i-1) '.mat'];
    load(scanfile);
    pointfeats_laser_all(:,:,i) = scanPoints;
end

%% Distance Error Minimization using Levenberg-Marquardt
 
% linefeats_img : 3 X N X F format (N : no. of lines, F : no. of frames)
% pointfeats_laser : 4 X N X F format (N : no. of points, F : no. of frames)
alpha = -pi/4; beta = 0; gamma = 0; tx = 0.1326; ty = -0.1075; tz = -0.0317;
x0 = [alpha; beta; gamma; tx; ty; tz];
numFramesOpt = 50;
x_soln = errorMinimization(linefeats_img_all(:,:,1:numFramesOpt), pointfeats_laser_all(:,:,1:numFramesOpt), x0);

%% Visualize Mapping of Laser Point Features onto Image Plane

frame_idx = 5;

imgfile = [imgfile_src '/calibrationImage' sprintf('%4.4d', frame_idx-1) '.png'];
img = imread(imgfile);
pointfeats_img_x0 = visualizeSolution(x0, img, pointfeats_laser_all(:,:,frame_idx), linefeats_img_all(:,:,frame_idx));
pointfeats_img_xsol = visualizeSolution(x_soln, img, pointfeats_laser_all(:,:,frame_idx), linefeats_img_all(:,:,frame_idx));

%% Colorize Laser Point Cloud

frame_idx = 5;

scanfile  = [scanfile_src '/scan' sprintf('%1.1d', frame_idx-1) '.txt'];
imgfile = [imgfile_src '/calibrationImage' sprintf('%4.4d', frame_idx-1) '.png'];

img = imread(imgfile);
scanDataCell = importScanData(scanfile);
scanData = loadScanData(scanDataCell);

points_laser2d = scanData.points;
points_laser3d = [-points_laser2d(2,:); zeros(1,size(points_laser2d,2)); points_laser2d(1,:)];
intensities_laser = points_laser2d(3,:);

[pts, rgb] = colorizePoints(points_laser3d, intensities_laser, img, x_soln);
rgb_norm = rgb/255;
figure; scatter3(pts(1,:)', pts(2,:)', pts(3,:)', 10*ones(1, size(pts,2))', rgb_norm', 'filled');