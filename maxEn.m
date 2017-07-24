function max = maxEn(image)

[imageHeight, imageLength, imageDepth] = size(image);


%initialize energymaps
energyMapsO = zeros(imageHeight);
energyMapsO(:,:,2) = zeros(imageHeight);

%run gabor filtering even/odd per orientation

    for orr = 1:12 %all the orientations
  outMagEven = conv2(I, gaborFilter(orr, 'even'), 'same');
  outMagOdd = conv2(I, gaborFilter(orr, 'odd'), 'same');
  
  energyMap = sqrt(outMagOdd.^2 + outMagEven.^2);
  disp(size(energyMap));
  energyMapsO(:,:,orr) = energyMap;
    end
    
    disp(size(energyMapsO));
%actMap are the maps maximized over the orientations
actMaps = zeros(imageHeight);
actMaps(:,:,1) = zeros(imageHeight);
actMaps(:,:,2) = zeros(imageHeight);
%this double loop finds the maximum energy of a given orientation and
%writes that value as an activation value into an actMaps array, so every
%actMaps(32,32,i) i = 1: dataset.length has a 32x32 map of the maximum
%value a orientation was able to get

for k = 1:12 %all the orientations
    
    for n = 1:imageLength
        for m = 1:imageHeight         
        actMaps(n,m,1) = max(energyMapsO(n,m,k), actMaps(n,m,1)); %set the values
        if(energyMapsO(n,m,k) >=  actMaps(n,m,1))
             actMaps(n,m,2) = k;
        end
        end
    end
end
%disp(actMaps);
disp(size(actMaps));
Iout = actMaps(:,:,1);


end
% 
%  function gaborFilter = gaborFilter(orr, phase)
%          %TO CHANGE setup gabor settings
% sigma1 = 6;%p54 this is for coarse scale, =1.5 for fine scale
% aspectratio = 0.5; %paper p51
% bandwidth = 0.56; %sigma/lambda = 0.56 from paper p51
% orientation = [0 30 60 90 120 150 180 210 240 270 300 330]; %Number of Orientations used in paper = 12 from p53
% wavelength = sigma1/0.56; %p51
% phaseOffset = [0, pi/2];
% 
%             if(strcmp(phase,'even'))
%                 gaborFilter = gabor_fn(bandwidth, aspectratio, phaseOffset(1), wavelength, orientation(orr));
%             elseif(strcmp(phase,'odd'))
%                 gaborFilter = gabor_fn(bandwidth, aspectratio, phaseOffset(1), wavelength, orientation(orr));
%             else
%                 disp('not a valid argument');
%             end
% end