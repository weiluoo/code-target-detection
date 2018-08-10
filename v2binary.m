function binaryBlob = v2binary(blob)

thred = mean(blob(:)) * 0.85;
binaryBlob = (blob < thred);
se = strel('disk', 2);
binaryBlob = imclose(binaryBlob, se);

end