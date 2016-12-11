function [data] = loadOdomData(odomDataCell)
% Loads odom data from text file, puts them into structure 
odomData = cell2mat([odomDataCell(:, 1:3) odomDataCell(:, 6:end)]);

% Place data into structure
numOdom = length(odomData);
data.time = zeros(numOdom, 1);
data.sequence = zeros(numOdom, 1);
data.stamp = zeros(numOdom, 1);
% data.frame_id = odomData(1, 4);
% data.child_frame_id = odomData(1, 5);
data.position = zeros(3, numOdom); % [x y z]'
data.orientation = zeros(3, 3, numOdom);  % 3x3 rotation matrix
data.xLinearVelocity = zeros(numOdom, 1);
data.zAngularVelocity = zeros(numOdom, 1);

for i = 1:numOdom
    data.time(i) = odomData(i, 1);
    data.sequence(i) = odomData(i, 2);
    data.stamp(i) = odomData(i, 3);
    data.position(:, i) = [odomData(i, 4) odomData(i, 5) odomData(i, 6)];
    data.orientation(:, :, i) = quat2rotm([odomData(i, 10) odomData(i, 7) odomData(i, 8) odomData(i, 9)]);
    data.xLinearVelocity(i) = odomData(i, 47);
    data.zAngularVelocity(i) = odomData(i, 52);
end


end

