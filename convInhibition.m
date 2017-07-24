function finalMap = convInhibition(image, fineMap, coarseMap, coarseMapExt)

%defined in paper p.54
alpha1 = 3.0;
alpha2 = 4.0;
alpha3 = 1.0; %TBD

finalMap = image - alpha1 .* fineMap - alpha2 .* coarseMap + alpha3 .* coarseMapExt;

end