function [ hitPoints ] = extractPoints( scanData )
% Take in scan data output from loadScanData and find the points
% corresponding to hit points on the lines of the calibration marker
% Inputs: 
%   scanData   <- structure containing data from laser scan (ROS
%                   sensor_msgs/LaserScan.msg)
% Outputs:
%   hitPoints  <- 3 pairs of points [x1 y1 z1; x2 y2 z2; x3 y3 z3] indicating
%                   points where line struck the edges of the calibration
%                   marker



end

