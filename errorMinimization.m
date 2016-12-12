function [vec] = errorMinimization(linefeats_img_all, pointfeats_laser_all, x0)

alpha = x0(1); beta = x0(2); gamma = x0(3); tx = x0(4); ty = x0(5); tz = x0(6);
residuals = distanceResidual(linefeats_img_all, pointfeats_laser_all, alpha, beta, gamma, tx, ty, tz);
fprintf('initial error = %f\n', 3*sqrt(sum(residuals.^2)/length(residuals)));

% Levenberg-Marquardt
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
[vec, resnorm, residuals, ~] = lsqnonlin(@(x) distanceResidual(linefeats_img_all, pointfeats_laser_all, x), [alpha,beta,gamma,tx,ty,tz], [], [], options);

fprintf('final error = %f\n', 3*sqrt(resnorm/length(residuals)));

end