function [errFun] = computeError(ptfeats_img, linefeats_img)

ptfeats_img = [ptfeats_img(:,1)./ptfeats_img(:,3) ptfeats_img(:,2)./ptfeats_img(:,3)];
% linefeats_img = [linefeats_img(:,1)./linefeats_img(:,3) linefeats_img(:,2)./linefeats_img(:,3) linefeats_img(:,3)./linefeats_img(:,3)];

% dists = zeros(3, 1);
for k = 1:3
    dists(k) = (linefeats_img(k,1)*ptfeats_img(k,1) + linefeats_img(k,2)*ptfeats_img(k,2) + linefeats_img(k,3)) / norm(linefeats_img(k,:));
end

errFun = sum(dists.^2);

end