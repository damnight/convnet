function surrroundCNN
  %load images and save in array
  naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
  groundTruthFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gt';

%show images for testing
natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
natFiles = dir(natFilePattern);

gtFilePattern = fullfile(groundTruthFolder, '*.pgm');
gtFiles = dir(gtFilePattern);


%for k = 1:length(natFiles)
% disp('inside forloop');
%  baseFileName = natFiles(k).name;
%  fullFileName = fullfile(naturalImagesFolder, baseFileName);
%  fprintf(1, 'Now reading %s\n', fullFileName);
%  imageArray = imread(fullFileName);
%  imshow(imageArray);  % Display image.
%  drawnow; % Force display to update immediately.
%end

%build the CNN layer
%cnn.layers = {
%    struct('type', 'i') %input layer
%    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
%};

%define gaborfilter gb=gabor_fn(sigma,gamma,psi,lambda,theta)

 % bw    = bandwidth, 
% gamma = aspect ratio,
% psi   = phase shift, 
% lambda= wave length,
% theta = angle in rad, 
sigma1 = 6;%p54 this is for coarse scale, =1.5 for fine scale
aspectratio = 0.5; %paper p51
bandwidth = 0.56; %sigma/lambda = 0.56 from paper p51
orientation1 = 0; %Number of Orientations used in paper = 12 from p53
wavelength = sigma1/0.56; %p51
phaseOffset = [0 pi/2];
gEven = gabor_fn(bandwidth, aspectratio, 0, wavelength, orientation1);
gOdd = gabor_fn(bandwidth, aspectratio, pi/2, wavelength, orientation1);

%output Gabor maps
disp('run forloop');
for k = 1:length(natFiles)
  
  
  baseFileName = natFiles(k).name;
  fullFileName = fullfile(naturalImagesFolder, baseFileName);
  I = imread(fullFileName);
  
  outMagOdd = conv2(I, gOdd);
  outMagEven = conv2(I, gEven);

  imagesc(outMagOdd);
  drawnow;
end


%setup cnn
%cnn = cnnsetup(cnn, natFiles, train_y);

%opts.alpha = 1;
%opts.batchsize = 50;
%opts.numepochs = 1;

%train cnn
%cnn = cnntrain(cnn, train_x, train_y, opts);

end

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

gb= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
end