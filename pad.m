%image = [:,:,:]; padsize = [pad_amount_first_dim, pad_amount_second_dim,
%etc]
function paddedimage = pad(image)

padsize = [4 4];
paddedimage = padarray(image, padsize);

end