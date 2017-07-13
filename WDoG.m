function WDoG = WDoG(sigma, k)

WDoG = (DoG(sigma, k))/(norm(DoG(sigma,k), 1));
end
