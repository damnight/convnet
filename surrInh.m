%gaborfilter from https://en.wikipedia.org/wiki/Gabor_filter
function si = surrInh(alpha)
%alpha = kernelsize
%beta 

% Bounding box
nstds = alpha;
xmax = max(abs(nstds*sigma_x*cos(theta)),abs(nstds*sigma_y*sin(theta)));
xmax = 1.5 * ceil(max(1,xmax));
ymax = max(abs(nstds*sigma_x*sin(theta)),abs(nstds*sigma_y*cos(theta)));
ymax = 1.5 * ceil(max(1,ymax));
xmin = -xmax; ymin = -ymax;
[x,y] = meshgrid(xmin:xmax,ymin:ymax);

%Equation
si = %adopt weighting function, use meshgrid as coordinates
end