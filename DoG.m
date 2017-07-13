%Difference of Gaussian function DOG+
function DoG = DoG(sigma, k)
%sigma = kernelsize
%k = multiplier in the paper set to 4 (because surround region affecting
%is 2-5 times larger than kernelsize

DoG = max(((1/(2*pi*(k*sigma)^2))*exp(2/(2*(k*sigma)^2))) - ((1/(2*pi*(sigma)^2))*exp(-(2/(2*(sigma)^2)))), 0); %Equation (9); (x^2)+(y^2) = 2; x and y are always 1

end