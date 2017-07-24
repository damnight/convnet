function aptWeightedImage = adptEndInhib(image, imageCoarse, weightedFine)
%imageFine - image at the fine scale 32x32
%imageCoarse - image at the coarse scale 28x28
%k - radius mulitplier between CRF and nCRF
aplha = 40;
theta = 0.25;
aptWeightedImageN = image;

%eq 17 and 18 (withot fsig)
wc = maxEn(imageCoarse) / (norm(maxEn(imageCoarse)));
wf = weightedFine / (norm(weightedFine));

%eq 16 (with fsig)
inhib = 1 - fsig(alpha, theta, wc) + fsig(alpha, theta, wf);

aptWeightedImageN(:,:,1) = conv2(image(:,:,1), inhib, 'same');
aptWeightedImage = aptWeightedImageN;
end

%eq 19
function f = fsig(alpha, theta, x)

f = 1 /(1 + exp^(-(alpha*(x - theta))));


end