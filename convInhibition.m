function finalMap = convInhibition(fineMap, coarseMap, image)

%defined in paper p.54
alpha1 = 3.0;
alpha2 = 4.0;

finalMap = image - alpha1 .* fineMap - alpha2 .* coarseMap;

end