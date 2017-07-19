function Iout = preprocessImage(baseFileName)
    %this function works pretty well
    
        I = imread(baseFileName);

        % Resize the image as required for the CNN.
        I = imresize(I, [32 32]);
        


        %initialize energymaps
actMaps = zeros(32);
actMaps(:,:,2) = zeros(32);

%TO CHANGE run gabor filtering even/odd per orientation

for orr = 1:12 %all the orientations
  outMagEven = conv2(I, gaborFilter(orr, 'even'), 'same');
  outMagOdd = conv2(I, gaborFilter(orr, 'odd'), 'same');
  
  energyMap = sqrt(outMagOdd.^2 + outMagEven.^2);
  disp(size(energyMap));
  actMaps(:,:,orr) = energyMap;
end
    
%disp(actMaps);
disp(size(actMaps));
Iout = actMaps;

end