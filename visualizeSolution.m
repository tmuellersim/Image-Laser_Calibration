function [pointfeats_img] = visualizeSolution(x_vals, img, pointfeats_laser, linefeats_img)


alpha = x_vals(1); beta = x_vals(2); gamma = x_vals(3);
tx = x_vals(4); ty = x_vals(5); tz = x_vals(6);

Rx = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
R = Rz*Ry*Rx;
t = [tx; ty; tz];

K = [726.927917480469,0,641.600148583195;0,780.887329101563,476.630044074220;0,0,1];

P = K*[R t];

pointfeats_img = P*pointfeats_laser;
pointfeats_img(1,:) = pointfeats_img(1,:)./pointfeats_img(3,:);
pointfeats_img(2,:) = pointfeats_img(2,:)./pointfeats_img(3,:);
pointfeats_img(3,:) = pointfeats_img(3,:)./pointfeats_img(3,:);

figure; imshow(img); hold on;
pause(0.5); plot(pointfeats_img(1,:), pointfeats_img(2,:), 'x', 'MarkerSize', 8, 'LineWidth', 1.5, 'Color', [1 0 0]);

end
