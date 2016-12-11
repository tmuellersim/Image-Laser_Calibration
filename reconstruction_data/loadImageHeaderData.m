function [data] = loadImageHeaderData(imageDataCell)
% Loads odom data from text file, puts them into structure 
imageData = cell2mat(imageDataCell(:,1:3));

% Place data into structure
numImages = length(imageData);
data.time = zeros(numImages, 1);
data.sequence = zeros(numImages, 1);
data.stamp = zeros(numImages, 1);

for i = 1:numImages
    data.time(i) = imageData(i, 1);
    data.sequence(i) = imageData(i, 2);
    data.stamp(i) = imageData(i, 3);
end

end

