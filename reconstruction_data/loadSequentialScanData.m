function [data] = loadSequentialScanData(scanDataCell)
% Loads scan data from text file, puts them into structure 
scanData = cell2mat(scanDataCell);
% Build

% Extract useful data from scan
data.minAngle = scanData(1, 5);
data.maxAngle = scanData(1, 6);
data.angleIncrement = scanData(1, 7);
data.numRays = round((data.maxAngle - data.minAngle)/data.angleIncrement);  % Number of points in each scan
rangeStart = 12;  % index of starting range

% Extract scan data from images
numScans = length(scanDataCell);

data.rangeData = zeros(numScans, data.numRays);
data.intensityData = zeros(numScans, data.numRays);
data.points = zeros(3, data.numRays, numScans);

for j = 1:numScans
    for i = 1:data.numRays
        data.rangeData(j, i) = scanData(rangeStart - 1 + i);
        data.intensityData(j, i) = scanData(rangeStart + data.numRays + i);
        data.points(1, i, j) = data.rangeData(i) * cos(data.minAngle + data.angleIncrement*(i-1));  %  z-value
        data.points(2, i, j) = - data.rangeData(i) * sin(data.minAngle + data.angleIncrement*(i-1));  %  x-value
        data.points(3, i, j) = data.intensityData(i);  %  intensity value
    end
end

return

