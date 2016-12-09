function [] = mappingUsingInitialVals(img, imgLines, scanPoints)

%% Initial Parameters
alpha = -pi/2; beta = 0; gamma = 0;
tx = 0.617; ty = 0.05; tz = 0;
P = [726.927917480469,0,641.600148583195,0;0,780.887329101563,476.630044074220,0;0,0,1,0];

%% Derived Parameters
Rx = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
R = Rz*Ry*Rx;
t = [tx; ty; tz];

%% Projection of Points
scanPointsExt = transpose(R*scanPoints' + repmat(t,1,3));
projP = P*[scanPointsExt ones(3,1)]';
projP(:,1) = projP(:,1)./projP(3,1); projP(:,2) = projP(:,2)./projP(3,2);  projP(:,3) = projP(:,3)./projP(3,3);
pause(0.5); figure(10); imshow(img); hold on;
plot(projP(1,:), projP(2,:), 'x', 'MarkerSize', 8, 'LineWidth', 1.5, 'Color', [1 0 0]);

end