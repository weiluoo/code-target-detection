% % % inital targetsLoc
targetsDist = get_dist(targetsLoc);
targetsDist = targetsDist + (targetsDist == 0) * max(targetsDist(:));
minDists = min(targetsDist);
meanMinDist = mean(minDists);

probNeighbors = targetsDist - meanMinDist;
probNeighbors = (probNeighbors < 50);
XPlusY = sum(targetsLoc, 2);
[~, LeftUpIndex] = min(XPlusY);
LeftUp = targetsLoc(2,:);
firstColIndex = find(abs(targetsLoc(:, 1) - LeftUp(1)) < 10);
firstCol = targetsLoc(firstColIndex,:);