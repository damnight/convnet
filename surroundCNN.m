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

%define gaborfilter gb=gabor_fn(bw,gamma,psi,lambda,theta)
% bw    = bandwidth, 
% gamma = aspect ratio,
% psi   = phase shift, 
% lambda= wave length,
% theta = angle in rad, 
 
stdDeviation = 6;%p54 this is for coarse scale, =1.5 for fine scale
aspectratio = 0.5; %paper p51
bandwidth = 0.56; %sigma/lambda = 0.56 from paper p51
orientation = [0 30 60 90 120 150 180 210 240 270 300 330]; %Number of Orientations used in paper = 12 from p53
wavelength = stdDeviation/0.56; %p51
phaseOffset = [0 pi/2];
gEven = gabor_fn(bandwidth, aspectratio, phaseOffset(1), wavelength ,orientation);
gOdd = gabor_fn(bandwidth, aspectratio, phaseOffset(2), wavelength ,orientation);

%output Gabor maps
disp('run forloop');
for k = 1:length(natFiles)
  
  outMagOdd = imgaborfilt(natFiles(k).name,gOdd);
  outMagEven = imgaborfilt(natFiles(k).name,gEven);

  imageArray = imread(outMagEven);
  imageArray = imread(outMagOdd);
  imshow(imageArray);
  drawnow;
end


%setup cnn
%cnn = cnnsetup(cnn, natFiles, train_y);

%opts.alpha = 1;
%opts.batchsize = 50;
%opts.numepochs = 1;

%train cnn
%cnn = cnntrain(cnn, train_x, train_y, opts);

function gb=gabor_fn(bw,gamma,psi,lambda,theta)
% bw    = bandwidth, (1)
% gamma = aspect ratio, (0.5)
% psi   = phase shift, (0)
% lambda= wave length, (>=2)
% theta = angle in rad, [0 pi)
 
sigma = lambda/pi*sqrt(log(2)/2)*(2^bw+1)/(2^bw-1);
sigma_x = sigma;
sigma_y = sigma/gamma;

sz=fix(8*max(sigma_y,sigma_x));
if mod(sz,2)==0, sz=sz+1;end

% alternatively, use a fixed size
% sz = 60;
 
[x y]=meshgrid(-fix(sz/2):fix(sz/2),fix(sz/2):-1:fix(-sz/2));
% x (right +)
% y (up +)

% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);
 
gb=exp(-0.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
imshow(gb/2+0.5);