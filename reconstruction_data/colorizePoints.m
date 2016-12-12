function [points, rgb] = colorizePoints(points, img, x_vals)

alpha = x_vals(1); beta = x_vals(2); gamma = x_vals(3);
tx = x_vals(4); ty = x_vals(5); tz = x_vals(6);

Rx = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
R = Rz*Ry*Rx;
t = [tx; ty; tz];

K = [726.927917480469,0,641.600148583195;0,780.887329101563,476.630044074220;0,0,1];

P = K*[R t];

numPoints = size(points,2);

pointsH = [points; ones(1,numPoints)];

pointfeats_img = P*pointsH;
pointfeats_img(1,:) = pointfeats_img(1,:)./pointfeats_img(3,:);
pointfeats_img(2,:) = pointfeats_img(2,:)./pointfeats_img(3,:);
pointfeats_img(3,:) = pointfeats_img(3,:)./pointfeats_img(3,:);

rgb = zeros(3, numPoints);
pointfeats_img = int16(pointfeats_img);

[rows, cols, ~] = size(img);
for i = 1:numPoints
    
    if ( (pointfeats_img(2,i) <= 0) || (pointfeats_img(2,i) > rows) || (pointfeats_img(1,i) <= 0) || (pointfeats_img(1,i) > cols) )
        continue;
    end
    
    rgb(1,i) = img(pointfeats_img(2,i), pointfeats_img(1,i), 1);
    rgb(2,i) = img(pointfeats_img(2,i), pointfeats_img(1,i), 2);
    rgb(3,i) = img(pointfeats_img(2,i), pointfeats_img(1,i), 3);
end

end
