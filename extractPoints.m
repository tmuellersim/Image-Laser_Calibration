function [ hitPoints ] = extractPoints( scanData, intThresh, manualPoints)
% Take in scan data output from loadScanData and find the points
% corresponding to hit points on the lines of the calibration marker
% Inputs: 
%   scanData   <- structure containing data from laser scan (ROS
%                   sensor_msgs/LaserScan.msg)
%   intThresh  <- threshold for intensity value to be considered a hit
%   manualPoints <- flag to manually input hit points if set to true
% Outputs:
%   hitPoints  <- 3 pairs of points [x1 y1 z1; x2 y2 z2; x3 y3 z3] indicating
%                   points where line struck the edges of the calibration
%                   marker

hitIdx = scanData.intensityData > intThresh;  % Logical index where intensity value is above threshold

if manualPoints
    displayScanData(scanData, intThresh)
    xlim([min(scanData.points(1, hitIdx))-.25, max(scanData.points(1, hitIdx))+.25])
    ylim([min(scanData.points(2, hitIdx))-.25, max(scanData.points(2, hitIdx))+.25])
    [x, y] = ginput(3);
    % Assumption about input is 3 individual lines describing calibration target lines
    pt1 = [x(1) y(1)]';
    pt2 = [x(2) y(2)]';
    pt3 = [x(3) y(3)]';
    axis tight
    hold on
    scatter(x, y, 5, 'filled', 'b')
    hold off
    
    hitPoints = [pt1'; pt2'; pt3'];
    return
end

%% Write code to automatically extract points here

end

