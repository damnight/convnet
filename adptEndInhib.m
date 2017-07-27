function aptWeightedImage = adptEndInhib(image, imageCoarse, weightedFine)
%imageFine - image at the fine scale 32x32
%imageCoarse - image at the coarse scale 28x28
%k - radius mulitplier between CRF and nCRF
alp = 40;
thet = 0.25;
aptWeightedImageN = image;

%eq 17 and 18 (withot fsig)

wc = maxEn(imageCoarse) / (norm(maxEn(imageCoarse)));
wf = weightedFine(:,:,1) / (norm(double(weightedFine(:,:,1))));
%disp(size(wf));

%eq 16 (with fsig)
inhib = zeros(size(wf));
for i = 1:size(wf(1));
    for j = 1: size(wf(2));
        inhib(i, j) = 1 - fsig(alp, thet, double(wc(i, j)) + fsig(alp, thet, double(wf(i,j))));
    end
end


aptWeightedImageN(:,:,1) = conv2(double(image(:,:,1)), double(inhib), 'same');
aptWeightedImage = aptWeightedImageN;

end

%eq 19
function f = fsig(alp, thet, x)

f = 1 /(1 + exp( -( alp*(x - thet))));


end