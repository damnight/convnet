function surrroundCNN
  %load images and save in array
  naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
  groundTruthFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gt';

%show images for testing
natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
natFiles = dir(natFilePattern);

gtFilePattern = fullfile(groundTruthFolder, '*.pgm');
gtFiles = dir(gtFilePattern);

disp('run forloop');
for k = 1:length(natFiles)
  disp('inside forloop');
  baseFileName = natFiles(k).name;
  fullFileName = fullfile(naturalImagesFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  imshow(imageArray);  % Display image.
  drawnow; % Force display to update immediately.
end

%build the CNN layer
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
};

%define gaborfilter
wavelength = 0.56;%sigma/lambda = 0.56 from paper p51
orientation = [0 30 60 90 120 150 180 210 240 270 300 330] %Number of Orientations used in paper = 12 from p53
phaseOffset = [0 pi/2]
gOdd = (wavelength, orientation, phaseOffset[0])
gEven = (wavelength, orientation, phaseOffset[1])

%setup cnn
cnn = cnnsetup(cnn, natFiles, train_y);

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 1;

%train cnn
cnn = cnntrain(cnn, train_x, train_y, opts);