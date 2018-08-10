function eudist = get_dist(loc)

M = size(loc, 1);
x2y2 = loc .^ 2;
xx = loc(:,1) * loc(:,1)';
yy = loc(:,2) * loc(:,2)';
x2 = repmat(x2y2(:,1), [1, M]);
y2 = repmat(x2y2(:,2), [1, M]);
eudist = x2 - 2 * xx + x2' + y2 - 2 * yy + y2';
eudist = sqrt(eudist);

end