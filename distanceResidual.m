function [residuals] = distanceResidual(linefeats_img_all, pointfeats_laser_all, alpha, beta, gamma, tx, ty, tz)

% linefeats_img : 3 X N X F format (N : no. of lines, F : no. of frames)
% pointfeats_laser : 4 X N X F format (N : no. of points, F : no. of frames)
[~, N, F] = size(linefeats_img_all);

if nargin == 8
    [~,~,~,tx,~,~] = unpackVariables(tx, 4);
elseif nargin == 6
    [~,~,~,tx,ty,tz] = unpackVariables(tx, 456);
elseif nargin == 3
    [alpha,beta,gamma,tx,ty,tz] = unpackVariables(alpha, 123456);
end

% Extrinsics
Rx = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
R = Rz*Ry*Rx;
t = [tx; ty; tz];

% Intrinsics
K = [726.927917480469,0,641.600148583195;0,780.887329101563,476.630044074220;0,0,1];

% Camera Projection
P = K*[R t];

residuals = [];
for f=1:F
    pointfeats_img = P*pointfeats_laser_all(:,:,f);
    linefeats_img = linefeats_img_all(:,:,f);

    % Normalize homogeneous coordinates
    pointfeats_img(1,:) = pointfeats_img(1,:)./pointfeats_img(3,:);
    pointfeats_img(2,:) = pointfeats_img(2,:)./pointfeats_img(3,:);
    pointfeats_img(3,:) = pointfeats_img(3,:)./pointfeats_img(3,:);
    
    % Compute point-to-line distances
    dists = zeros(N,1);
    for n = 1:N
        dists(n) = (linefeats_img(1,n)*pointfeats_img(1,n) + linefeats_img(2,n)*pointfeats_img(2,n) + linefeats_img(3,n)) / norm(linefeats_img(:,n));
        dists(n) = abs(dists(n));
    end

    residuals = [residuals [dists(1); dists(2); dists(3)]];

end

residuals = double(residuals(:));

end