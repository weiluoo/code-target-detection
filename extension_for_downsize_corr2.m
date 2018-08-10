% % % extension for downsize_corr2 % % %

for i = 1:N
    corrImg = corrImgs(:,:,i);
    prob_area = corrImg .* (corrImg > 0.65);
    center = prob_area > imdilate(prob_area, dilate_filter);
    val = center .* corrImg;
    disp(['average value is ' num2str(sum(val(:)) / sum(center(:)))]);
end

count = 1;
for i = 1:N
    vImg = imread(['orig/' files_images(i).name]);
    loc = res{i};
    m = size(loc, 1);
    reloc = zeros(m, 2);
    for j = 1:m
        x = loc(j, 1);
        y = loc(j, 2);
        if((x - s) < 1 || (x + s) > rows || (y - s) < 1 || (y + s) > cols)
            continue;
        end
        vblob = vImg((x - s):(x + s), (y - s):(y + s),:);
        imwrite(vblob, sprintf('orig_blobs/%d.jpg', count));
        count = count + 1;
    end
end

count = 1;
for i = 1:N
    vImg = vImgs(:,:,i);
    loc = res{i};
    m = size(loc, 1);
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
        imwrite(advBlob, sprintf('advbinary_blobs/%d.jpg', count));
        count = count + 1;
    end
end