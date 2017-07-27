%gaborfilter from https://en.wikipedia.org/wiki/Gabor_filter
function gb=gabor_fn(sigma,gamma,psi,lambda,theta)
% sigma    = bandwidth, 
% gamma = aspect ratio,
% psi   = phase shift, 
% lambda= wave length,
% theta = angle in rad, 

sigma_x = sigma;
sigma_y = sigma/gamma;

% Bounding box
nstds = 3;
xmax = max(abs(nstds*sigma_x*cos(theta)),abs(nstds*sigma_y*sin(theta)));
xmax = ceil(max(1,xmax));
ymax = max(abs(nstds*sigma_x*sin(theta)),abs(nstds*sigma_y*cos(theta)));
ymax = ceil(max(1,ymax));
xmin = -xmax; ymin = -ymax;
[x,y] = meshgrid(xmin:xmax,ymin:ymax);

% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);

% if (psi == pi/2) || (psi == 3/2*pi) %even
% gb= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi*x_theta/lambda + psi);
% elseif (psi == 0) || (psi == pi) || (psi == 2*pi) %odd
% gb= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*sin(2*pi*x_theta/lambda + psi);
% else
%gb= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi); 

gb = exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta + psi);
end