close all; clear all; clc;
warning('off', 'Images:initSize:adjustingMag');

load('res.mat', 'step2res');
% load('res_imfill.mat', 'step2res');
% load('res_unfill.mat', 'step2res');
files_images = dir(['orig/' '*.JPG']);

N = size(files_images, 1);

for i = 1:N
    targetsLoc = round(step2res{i});
    Loc = step2res{i};
    photo = imread(['orig/' files_images(i).name]);
%     photo = svImgs(:,:,i);
    figure; imshow(photo); hold on;
    for j = 1:size(targetsLoc, 1)
        locInfo = ['[', num2str(Loc(j,1)), ',', num2str(Loc(j,2)), ']'];
        text(targetsLoc(j,2), targetsLoc(j,1), locInfo, 'color', 'y');
    end
    pause(0.1);
%     f = getframe;
%     imwrite(f.cdata, sprintf('results/%d.bmp', i));
end