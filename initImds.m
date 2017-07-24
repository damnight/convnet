function imds = initImds

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
        imds = preprocessImage(fullFileName); 
        
end