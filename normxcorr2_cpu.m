function c = normxcorr2_cpu(F, img)

[fcols, frows] = size(F);
fcborder = fcols / 2; frborder = frows / 2;
[rows, cols] = size(img);

c = normxcorr2(F, img);
c = c(frborder:(rows+frborder-1),:);
c = c(:, fcborder:(cols+fcborder-1));
c = c;

end