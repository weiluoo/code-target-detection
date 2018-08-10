close all; clear all; clc;
warning('off', 'Images:initSize:adjustingMag');

load('filter.mat', 'F');
files_images = dir(['orig/' '*.JPG']);

N = size(files_images, 1);

demo = imread(['orig/' files_images(1).name]);
[rows, cols, chs] = size(demo);
T = 4;
srows = rows / T; scols = cols / T; sf = size(F, 1) / T; border = sf / 2;
sF = imresize(F, [sf, sf]);

vImgs = zeros(rows, cols, N);
svImgs = zeros(srows, scols, N);
tt = cputime;
parfor i = 1:N
    img = imread(['orig/' files_images(i).name]);
    vImgs(:,:,i) = rgb2v(img);
    svImgs(:,:,i) = imresize(vImgs(:,:,i), [srows, scols]);
end
disp(['loading and translating all images take ' num2str(cputime-tt) ' seconds.']);

d = 8; D = 16; iteration = 1;
corrImgs = zeros(srows, scols, N);
tt = cputime;
parfor i = 1:N
    svImg = svImgs(:,:,i);
    corrImg = zeros(srows, scols);
    for s = (sf-d):iteration:(sf+D)
        reF = imresize(F, [s s]);
        corrImg = max(corrImg, normxcorr2_cpu(reF, svImg));
    end
    corrImgs(:,:,i) = corrImg;
end
disp(['normxcorr2 take ' num2str(cputime-tt) ' seconds.']);

res = {};
dilate_filter = [1 1 1; 1 0 1; 1 1 1];
gap = 4 * sf;
tt = cputime;
parfor i = 1:N
    corrImg = corrImgs(:,:,i);
    prob_area = corrImg .* (corrImg > 0.7);
    center = prob_area > imdilate(prob_area, dilate_filter);
    [centerX centerY] = find(center);
    loc = [centerX, centerY];
    eudist = get_dist(loc);
    neibor = sum((eudist < gap), 2) - 1;
    outlier = find(neibor < 1);
    loc(outlier,:) = [];
    res{i} = loc * T;
end
disp(['competition takes ', num2str(cputime - tt), ' seconds.']);

step2res = {};
s = size(F, 1);
tt = cputime;
parfor i = 1:N
    vImg = vImgs(:,:,i);
    loc = res{i};
    m = size(loc, 1);
    reloc = zeros(m, 2);
    count = 1;
    for j = 1:m
        x = loc(j, 1);
        y = loc(j, 2);
        if((x - s) < 1 || (x + s) > rows || (y - s) < 1 || (y + s) > cols)
            continue;
        end
        vblob = vImg((x - s):(x + s), (y - s):(y + s));
        binaryBlob = v2binary(vblob);
        advBlob = judgement4blob(binaryBlob);
        if isempty(advBlob)
            continue;
        end
        [jloc id] = aligned(advBlob, x, y);
%        Xiaolong's code, use id as input.
        reloc(count,:) = jloc;
%         imwrite(id, sprintf('binary_blobs/%d.jpg', count));
        count = count + 1;
    end
    reloc(count:end,:) = [];
    step2res{i} = reloc;
end
disp(['relocate and recognize the code targets takes' num2str(cputime-tt) ' seconds.']);

for i = 1:N
    targetsLoc = round(step2res{i});
    photo = imread(['orig/' files_images(i).name]);
%     photo = svImgs(:,:,i);
    figure; imshow(photo); hold on;
    plot(targetsLoc(:,2), targetsLoc(:,1), 'yx');
    pause(0.1);
%     f = getframe;
%     imwrite(f.cdata, sprintf('results/%d.bmp', i));
end

% for i = 1:N
%     targetsLoc = round(step2res{i});
%     Loc = step2res{i};
%     photo = imread(['orig/' files_images(i).name]);
% %     photo = svImgs(:,:,i);
%     figure; imshow(photo); hold on;
%     for j = 1:size(targetsLoc, 1)
%         locInfo = ['[', num2str(Loc(j,1)), ',', num2str(Loc(j,2)), ']'];
%         text(targetsLoc(j,2), targetsLoc(j,1), locInfo);
%     end
%     pause(0.1);
% %     f = getframe;
% %     imwrite(f.cdata, sprintf('results/%d.bmp', i));
% end

% save('res_unfill.mat', 'step2res');
