function [iloc id] = aligned(blob, x, y)

r = (size(blob, 1) + 1) / 2;
d = size(blob, 1);
L = bwlabel(blob);
peak = regionprops(L, 'centroid', 'Area');
centroids = cat(1, peak.Centroid);
areas = cat(1, peak.Area);

[A, I] = min(areas);
distxy = centroids(I,:) - [r r];
iloc = [x y] + [distxy(2) distxy(1)];

distxy = round(distxy);
if distxy(1) < 0
    distx = -distxy(1);
    tmp = [zeros(d, distx) blob];
    blob = tmp(:,1:d);
elseif distxy(1) > 0
    distx = distxy(1);
    tmp = [blob zeros(d, distx)];
    blob = tmp(:,distx+1:end);
end

if distxy(2) < 0
    disty = -distxy(2);
    tmp = [zeros(disty, d); blob];
    blob = tmp(1:d,:);
elseif distxy(2) > 0
    disty = distxy(2);
    tmp = [blob; zeros(disty+1, d)];
    blob = tmp(disty+1:end,:);
end

id = blob;

end