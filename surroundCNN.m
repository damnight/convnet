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

%output Gabor maps
%disp('run forloop');
%for k = 1:length(natFiles)
  
  
  %baseFileName = natFiles(k).name;
  %fullFileName = fullfile(naturalImagesFolder, baseFileName);

  
  outMagOdd = conv2(I, gOdd);

  outMagEven = conv2(I, gEven);

  %imshow(outMagOdd);
  %title('Odd');   
  %drawnow;
  
  %pause(pauseTime);
  
  %imshow(outMagEven);
  %title('Even'); 
  %drawnow;
  %pause(pauseTime);
  
  Igabor = sqrt(outMagOdd.^2 + outMagEven.^2);
 
%end

%setup cnn
varSize = 32;
%0. load files
labels = {'bear', 'goat', 'elephant','gazelle'};

%imds = imageDatastore('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\bear.pgm', 'bear', ...
     %   'LabelSource','foldernames');
     
imds = imageDatastore(Istring, 'LabelSource', 'foldernames');


 
    
%1.Initilize CNN
    edgeOrientationHistogram(Igabor, 12);
conv_1 = convolution2dLayer([4 5], 12, 'Padding', 8, 'Stride', 1, 'BiasLearnRateFactor', 2); %filtersize 4|5 for every orientation,
                                                                                            %every filter has to check for 12 different orientations, 
                                                                                            %Padding to give the surround area a multiple of 20(k*sigma=20), 
                                                                                            %stride 1 as we want to check every single pixel in relation to every other single pixel in its surround
conv_1.Weights = surroundWeighting(im2col); %set the weighting function [row_start:row_end, column_start:column_end]
fc1 = fullyConnectedLayer(64, 'BiasLearnRateFactor',2);
%fc1.Weights = gpuArray(single(randn([64 576])*0.1)); %this might be where
%the weighting function goes, and it doesn't work
fc2 = fullyConnectedLayer(4, 'BiasLearnRateFactor',2);
fc2.Weights = gpuArray(single(randn([4 64])*0.1));



%2.build the layers
layers = [
    imageInputLayer([32 32 1]);
    conv_1;
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

%Difference of Gaussian function DOG+
function DoG = DoG()
%sigma = kernelsize (4|5)
%k = multiplier in the papaer set to 4 (because surround region affecting
%is 2-5 times larger than kernelsize
sigma = [4 5];
k = 4;

DoG = max(((1/(2*pi*(k*sigma)^2))*exp(2/(2*(k*sigma)^2))) - ((1/(2*pi*(sigma)^2))*exp(-(2/(2*(sigma)^2)))), 0); %Equation (9); (x^2)+(y^2) = 2; x and y are always 1

end

%distance weighting fucntion half-wave rectified and L1-normalized difference of two
%concentric Gaussian functions
function spatialWeight = spatialWeighting(coords)
%sigma = kernelsize (4|5)
%k = multiplier in the papaer set to 4 (because surround region affecting
%is 2-5 times larger than kernelsize
sigma = [4 5];
k = 4;
x1 = coords(1,1); %target
y1 = cooords(1,0); %target
x2 = coords(0,1); %actual
y2 = coords (0,0); %actual

spatialWeight = max(((1/sqrt((2*pi*(k*sigma)^2)))*exp(-((x1)^2+(y1)^2)/(2*(k*sigma)^2))) - ((1/sqrt((2*pi*(sigma)^2)))*exp(-(((x2)^2+(y2)^2)/(2*(sigma)^2)))),0); %Equation (9); (x^2)+(y^2) = 2; x and y are always 1

end

%determine orientation distribution weight
function orWeight = orWeight(orr, targetOrr)
%orientations are labeled with a number from 0-330 (in steps of 30 (12
%total))
%we want to find a Delta to describe how different they are, opposing
%directions are most different
k=1;
orWeight = (1/2)*(1+cos(targetOrr - orr))^k;

end

%figure out the weighing for the surroundInhibition
function surroundWeight = surroundWeighting(regionInImage)
%prep variables
orientationList = {0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330};
region = imageOrientations(regionInImage); %regionInImage should look like [row_start:row_end, column_start:column_end]

% loop over all rows and columns
for ii=1:size(imageOrientations,1)
    for jj=1:size(imageOrientations,2)        
        %get the actual pixel values
        %imageOrientations is an array that stores the orientation values (0-11)
        actualOrr = orientationList(imageOrientations(ii, jj)); %this should return a value between 0-330
        
        
        %loop through  the surround region
        for yy=1:size(region,1)
            for xx=1:size(region,2)
                %get the target pixel values
                targetOrr = orientationList(region(yy, xx));
                
                %calculate weight
                orWeight = orWeight(actualOrr, targetOr);
                coords = [ii jj, ...
                          yy xx];
                      
               
                localweight = conv2(spatialWeighting(coords),orWeight);
                
                cumulativeWeight = localweight + cumulativeWeight; 
            end
        end
        

    end
end       

surroundWeight = cumulativeWeight;




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

%Sobelfilter
% adjusted histogram 12 orient
% parameters
%im - the image
%r - the number of vertical and horizontal divisions
function [data] = edgeOrientationHistogram(im, r)

% define the filters for the 12 types of edges
f2 = zeros(4,5,12);

f2(:,:,1) = [ 1  1  1  1  1
              0  0  0  0  0
              0  0  0  0  0
             -1 -1 -1 -1 -1];%(0deg)
         
f2(:,:,2) = [1  1  1  1  0 
             1  1  0  0  0 
             0  0  0 -1 -1 
             0 -1 -1 -1 -1];%(30deg)
         
f2(:,:,3)  =[1 1  1  0 -1
             1 1  0  0 -1
             1 0  0 -1 -1
             1 0 -1 -1 -1];%(60deg)

f2(:,:,4) = [-1 -1 0 1 1
             -1 -1 0 1 1
             -1 -1 0 1 1
             -1 -1 0 1 1];%(90deg)

f2(:,:,5)  = [1 0 -1 -1 -1
              1 0  0 -1 -1
              1 1  0  0 -1
              1 1  1  0 -1];%(120deg)
          
f2(:,:,6)  =  [0 -1 -1 -1 -1
               1  0  0 -1 -1
               1  1  0  0 -1
               1  1  1  1  0];%(150deg)    
           
f2(:,:,7) = [-1 -1 -1 -1 -1
              0  0  0  0  0
              0  0  0  0  0
              1  1  1  1  1]; %(180deg)
          
f2(:,:,8) = [-1  -1 -1 -1  0
              -1  -1  0  0  0
               0   0  0  1  1
               0   1  1  1  1]; %(210deg)
           
f2(:,:,9) = [-1 -1  -1  0 1
               -1 -1   0  0 1
               -1  0   0  1 1
               -1  0   1  1 1]; %(240deg)
           
f2(:,:,10) = [1 1 0 -1 -1
             1 1 0 -1 -1
             1 1 0 -1 -1
             1 1 0 -1 -1]; %(270deg)
         
f2(:,:,11) = [-1 0 1  1  1
             -1 0  0  1  1
             -1 -1  0  0  1
             -1 -1  -1  0  -1];%(300deg)

f2(:,:,12) =  [ 0  1  1  1  1
              -1  0  0  1  1
              -1 -1  0  0  1
              -1 -1 -1 -1  0];%(330deg)


% the size of the image
ys = size(im,1);
xs = size(im,2);

% The image has to be in gray scale (intensities)
%THIS FUCNTION WAS REMOVED WITHOUT REPLACEMENT
%if (isrgb(im))
%    im = rgb2gray(im);
%    endif

% Build a new matrix of the same size of the image
% and 12 dimensions to save the gradients
im2 = zeros(ys,xs,12);

% iterate over the posible directions
for i = 1:12
    % apply the sobel mask
    im2(:,:,i) = filter2(f2(:,:,i), im);
end

% calculate the max sobel gradient
[mmax, maxp] = max(im2,[],12);
% save just the index (type) of the orientation and ignore the value of the gradient
im2 = maxp;

%save imageOrientations globally
imageOrientations = im2;

% detect the edges using the default Octave parameters
%ime = edge(im, 'sobel');

% multiply against the types of orientations detected
% by the Sobel masks
%im2 = im2.*ime;

% produce a structure to save all the bins of the histogram of each region
eoh = zeros(r,r,6);
% for each region
for j = 1:r
    for i = 1:r
        % extract the subimage
        clip = im2(round((j-1)*ys/r+1):round(j*ys/r),round((i-1)*xs/r+1):round(i*xs/r));
        %disp((clip));
        % calculate the histogram for the region
        eoh(j,i,:) = (hist(reshape(clip,1,[]), 0:5)*100)/numel(clip);
    end
end

% take out the zeros
eoh = eoh(:,:,2:6);

% represent all the histograms on one vector
data = zeros(1,numel(eoh));
data(:) = eoh(:);
end
