function surrroundCNN
clear all;
  pauseTime = 0.5;
  %load images and save in array
    naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
    groundTruthFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gt';
    naturalImagesFolderNew = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\imagesNew';
    
%show images for testing
natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
natFiles = dir(natFilePattern);

gtFilePattern = fullfile(groundTruthFolder, '*.pgm');
gtFiles = dir(gtFilePattern);

testImage1 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\bear.pgm');
testImage2 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\goat.pgm');
testImage3 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\elephant.pgm');
testImage4 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gazelle.pgm');



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
%disp('run forloop');
%for k = 1:length(natFiles)
  
  
%  baseFileName = natFiles(k).name;
%  fullFileName = fullfile(naturalImagesFolder, baseFileName);
%  I = imread(fullFileName);
  
%  outMagOdd = conv2(I, gOdd);
  
%  Is = imread(fullFileName);
%  outMagEven = conv2(Is, gEven);

%  imshow(outMagOdd);
%  title('Odd');   
%  drawnow;
  
  %pause(pauseTime);
  
%  imshow(outMagEven);
%  title('Even'); 
 % drawnow;
  %pause(pauseTime);
%end

%Resize images (to be deleted?)
imresize(testImage1, 0.0625);
imresize(testImage2, 0.0625);
imresize(testImage3, 0.0625);
imresize(testImage4, 0.0625);


Istring = {'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\bear\bear.pgm', ...
    'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\goat\goat.pgm',  ...
    'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\elephant\elephant.pgm',  ...
    'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gazelle\gazelle.pgm'};

I = [testImage1 testImage2 testImage3 testImage4];

%setup cnn
varSize = 32;
%0. load files
labels = {'bear', 'goat', 'elephant','gazelle'};

%imds = imageDatastore('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\bear.pgm', 'bear', ...
     %   'LabelSource','foldernames');
     
     imds = imageDatastore(Istring, 'LabelSource', 'foldernames');

    
%1.Initilize CNN
conv_1 = convolution2dLayer(3, 32, 'Padding', 2, 'BiasLearnRateFactor', 2);
conv_1.Weights = gpuArray(single(randn([3 3 5 32])*0.0001));
fc1 = fullyConnectedLayer(64, 'BiasLearnRateFactor',2);
%fc1.Weights = gpuArray(single(randn([64 576])*0.1)); %this might be where
%the weighting function goes, and it doesn't work
fc2 = fullyConnectedLayer(4, 'BiasLearnRateFactor',2);
fc2.Weights = gpuArray(single(randn([4 64])*0.1));



%2.build the layers
layers = [
    imageInputLayer([32 32 1]);
    convolution2dLayer([5 5], 12);
    maxPooling2dLayer(3, 'Stride', 2);
    reluLayer();

    convolution2dLayer(3, 32, 'Padding', 2, 'BiasLearnRateFactor', 2);
    reluLayer();
    averagePooling2dLayer(3, 'Stride', 2);
    
    convolution2dLayer(3, 64, 'Padding', 2, 'BiasLearnRateFactor', 2);
    reluLayer();
    averagePooling2dLayer(3, 'Stride', 2);
    
    fc1;
    reluLayer();
    fc2;
    softmaxLayer()
    classificationLayer()];
    


    %3. training options
    opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 100, ...
    'Verbose',true);
    
    
    %4. train cnn
    [net, info] = trainNetwork(imds, layers, opts);
    
    %5. analyise net
    act1 = activations(net,imds,'conv_1','OutputAs','channels');
    sz = size(act1);
    %act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
    disp(size(act1));
    imshow(act1(:,:,1,4)); %does it display something good or not?
    %montage(mat2gray(act1),'Size',[8 12]);
    
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