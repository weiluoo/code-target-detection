function mask = backgroundColors(img, Colors)

thred = 45;
[rows, cols, chs] = size(img);
N = size(Colors, 1);
mask = zeros(rows, cols);

for i = 1:N
    c = Colors(i,:);
    r = abs(double(img(:,:,1)) - c(1));
    g = abs(double(img(:,:,2)) - c(2));
    b = abs(double(img(:,:,3)) - c(3));
    imask = (r <= thred & g <= thred & b <= thred);
    imask = imfill(imask, 'holes');
    mask(imask) = i;
end

end