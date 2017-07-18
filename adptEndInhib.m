function inhib = adptEndInhib(imageFine, imageCoarse, k)
%imageFine - image at the fine scale 32x32
%imageCoarse - image at the coarse scale 28x28
%k - radius mulitplier between CRF and nCRF
aplha = 40;
theta = 0.25;

%eq 17 and 18 (withot fsig)
wc = maxEn(imageCoarse) / (norm(maxEn(imageCoarse)));
wf = surroundWeighting(imageFine, k) / (norm(surroundWeighting(imageFine, k)));

%eq 16 (with fsig)
inhib = 1 - fsig(alpha, theta, wc) + fsig(alpha, theta, wf);


end

%eq 19
function f = fsig(alpha, theta, x)

f = 1 /(1 + exp^(-(alpha*(x - theta))));


end