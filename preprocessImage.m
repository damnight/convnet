function Iout = preprocessImage(fullFileName)
    %naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
    naturalImagesFolder = 'C:\Users\Marco\Documents\Studium\VIP\convnet\images';
    natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
    natFiles = dir(natFilePattern);
    baseFileName = natFiles().name;
    fullFileName = fullfile(naturalImagesFolder, baseFileName);
    
        I = imread(fullFileName);

        % Resize the image as required for the CNN.
        I = imresize(I, [32 32]);


        %initialize energymaps
actMaps = I;
actMaps(:,:,2) = zeros(32);

%TO CHANGE run gabor filtering even/odd per orientation

for orr = 2:13 %all the orientations
  outMagEven = conv2(I, gaborFilter(orr-1, 'even'), 'same');
  outMagOdd = conv2(I, gaborFilter(orr-1, 'odd'), 'same');
  
  energyMap = sqrt(outMagOdd.^2 + outMagEven.^2);
  disp(size(energyMap));
  actMaps(:,:,orr) = energyMap;
end
    
% imshow(actMaps(:,:,1),'InitialMagnification',500);
% pause(0.5);
% imshow(actMaps(:,:,2),'InitialMagnification',500);
% pause(1);
% imshow(actMaps(:,:,7),'InitialMagnification',500);
% pause(1);
% imshow(actMaps(:,:,9),'InitialMagnification',500);
% pause(1);
disp(size(actMaps));
Iout = actMaps;

end