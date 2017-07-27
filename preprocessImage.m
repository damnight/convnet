function Iout = preprocessImage(fullFileName)
    naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
    %naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
    natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
    natFiles = dir(natFilePattern);
    baseFileName = natFiles().name;
    fullFileName = fullfile(naturalImagesFolder, baseFileName);
    
        I = imread(fullFileName);

        % Resize the image as required for the CNN.
   


        %initialize energymaps
actMaps = I;
actMaps(:,:,2) = zeros(512);

%TO CHANGE run gabor filtering even/odd per orientation

for orr = 2:13 %all the orientations
  outMagEven = conv2(I, gaborFilter(orr-1, 'even'), 'same');
  outMagOdd = conv2(I, gaborFilter(orr-1, 'odd'), 'same');
  
  energyMap = sqrt(outMagOdd.^2 + outMagEven.^2);
  %disp(size(energyMap));
  actMaps(:,:,orr) = energyMap;
end
%   
% figure(4);
% imshow(actMaps(:,:,1));
% figure(1);
% imshow(actMaps(:,:,2));
% figure(2);
% imshow(actMaps(:,:,7));
% figure(3)
% imshow(actMaps(:,:,9));

actMaps = padarray(actMaps, [4 4]);
%disp(size(actMaps));
Iout = actMaps;


end