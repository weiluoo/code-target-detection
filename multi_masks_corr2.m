close all; clear all; clc;
warning('off', 'Images:initSize:adjustingMag');

load('filter.mat', 'F');
files_images = dir(['orig/' '*.JPG']);

N = size(files_images, 1);

demo = imread(['orig/' files_images(1).name]);
[rows, cols, chs] = size(demo);

vImgs = zeros(rows, cols, N);
tt = cputime;
parfor i = 1:N
    img = imread(['orig/' files_images(i).name]);
    vImgs(:,:,i) = rgb2v(img);
end
disp(['loading and translating all images take ' num2str(cputime-tt) ' seconds.']);

% srows = rows / 4; scols = cols / 4; sf = size(F, 1) / 4; border = sf / 2;
% sF = imresize(F, [sf, sf]);
% masks = zeros(srows, scols, N);
% tt = cputime;
% for i = 1:N
%     svImg = imresize(vImgs(:,:,i), [srows, scols]);
%     scorrImg = normxcorr2_gpu(sF, svImg);
%     mask = double(scorrImg > 0.4);
%     D = bwdist(mask, 'euclidean');
%     mask = D < sf;
%     masks(:,:,i) = double(mask);
% end
% disp(['generating all the mask take ' num2str(cputime-tt) ' seconds.']);

minS = 70; maxS = 110; iteration = 10;
corrImgs = zeros(rows, cols, N);
tt = cputime;
for i = 1:N
%     vImg = vImgs(:,:,i) .* imresize(masks(:,:,i), [rows, cols]);
    vImg = vImgs(:,:,i);
    corrImg = zeros(rows, cols);
    for s = minS:iteration:maxS
        reF = imresize(F, [s s]);
        corrImg = max(corrImg, normxcorr2_gpu(reF, vImg));
    end
    corrImgs(:,:,i) = corrImg;
end
disp(['normxcorr2 take ' num2str(cputime-tt) ' seconds.']);

res = {};
dilate_filter = [1 1 1; 1 0 1; 1 1 1];
tt = cputime;
parfor i = 1:N
    corrImg = corrImgs(:,:,i);
    prob_area = corrImg .* (corrImg > 0.6);
    center = prob_area > imdilate(prob_area, dilate_filter);
    [centerX centerY] = find(center > 0);
    loc = [centerX, centerY, ones(size(centerX, 1), 1) * maxS];
    loc = round(loc);
    res{i} = loc;
end
disp(['competition takes ', num2str(cputime - tt), 'seconds.']);

for i = 1:N
    targetsLoc = res{i};
    photo = imread(['orig/' files_images(i).name]);
    figure; imshow(photo); hold on;
    plot(targetsLoc(:,2), targetsLoc(:,1), 'yx');
end

% save('loc/res.mat', 'res');