function advBlob = judgement4blob(blob)

[L num] = bwlabel(blob);
if num < 2
    advBlob = [];
    return;
end

r = (size(blob, 1) + 1) / 2;

peak = regionprops(L, 'centroid');
centroids = cat(1, peak.Centroid);

dists = sum((centroids - repmat([r, r], [size(centroids, 1), 1])) .^ 2, 2);
B = sort(dists);

if(B(2) > 100)
    advBlob = [];
    return;
end

idx1 = find(dists == B(1));
idx2 = find(dists == B(2));
if (length(idx1) ~= 1 & length(idx2) ~= 1)
    advBlob = [];
    return;
end
advBlob = double(L == idx1) + double(L == idx2);

end