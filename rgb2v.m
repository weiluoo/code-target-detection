function vPhoto = rgb2v(photo)

r = double(photo) / 255;
g = r(:,:,2); 
b = r(:,:,3); 
r = r(:,:,1);
siz = size(r);
r = r(:); 
g = g(:); 
b = b(:);

vPhoto = max(max(r,g),b);
vPhoto = reshape(vPhoto,siz);

end