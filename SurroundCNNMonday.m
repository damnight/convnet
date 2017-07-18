function SurroundCNNMonday

% %TO CHANGE load test images
% testImage1 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\bear.pgm');
% testImage2 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\goat.pgm');
% testImage3 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\elephant.pgm');
% testImage4 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gazelle.pgm');
% 
% %TO CHANGE resize images
% testImage1 = imresize(testImage1, 0.0625);
% testImage2 = imresize(testImage2, 0.0625);
% testImage3 = imresize(testImage3, 0.0625);
% testImage4 = imresize(testImage4, 0.0625);
% 
% %TO CHANGE save in Array structure
% I = [testImage1 testImage2 testImage3 testImage4];

%initialize imds
    naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
    %naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
    natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
    natFiles = dir(natFilePattern);
    baseFileName = natFiles().name;
    fullFileName = fullfile(naturalImagesFolder, baseFileName);
    %imds = imageDatastore(natFilePattern, 'LabelSource', 'foldernames');  
    imds = imageDatastore(fullfile(naturalImagesFolder, baseFileName), 'LabelSource', 'foldernames');
    %DEBUG 
    %disp(size(imds));    
    imds.ReadFcn = @(fullFileName)preprocessImage(fullFileName);
        Iout = preprocessImage(fullFileName);    

%setup CNN
%1.Initiate

  
conv_1 = convolution2dLayer(4, 32, 'Padding', 2, 'Stride', 1, 'BiasLearnRateFactor', 2, 'NumChannels' , 1);
%conv_1.Weights = DoG([4 4], 4) * 

fc1 = fullyConnectedLayer(1, 'BiasLearnRateFactor',2);
fc1.Weights = gpuArray(single(randn([1 1])*0.1));

fc2 = fullyConnectedLayer(1, 'BiasLearnRateFactor',2);
fc2.Weights = gpuArray(single(randn([1 64])*0.1));

%2. Layers
layers = [
    imageInputLayer([32 32 1]);
    conv_1;
    reluLayer();
    softmaxLayer();
    classificationLayer();
   
];
    


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
    [net1, info] = trainNetwork(imds, layers, opts);
    
    %5. analyise net
    act1 = activations(net,imds,'conv_1','OutputAs','channels');
    sz = size(act1);
    %act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
    disp(size(act1));
    imshow(act1(:,:,1,4)); %does it display something good or not?
    %montage(mat2gray(act1),'Size',[8 12]);
    
%cnn = cnntrain(cnn, train_x, train_y, opts);


end