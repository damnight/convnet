function SurroundCNNMonday

%TO CHANGE load test images
testImage1 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\bear.pgm');
testImage2 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\goat.pgm');
testImage3 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\elephant.pgm');
testImage4 = imread('D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gazelle.pgm');

%TO CHANGE resize images
testImage1 = imresize(testImage1, 0.0625);
testImage2 = imresize(testImage2, 0.0625);
testImage3 = imresize(testImage3, 0.0625);
testImage4 = imresize(testImage4, 0.0625);

%TO CHANGE save in Array structure
I = [testImage1 testImage2 testImage3 testImage4];

%TO CHANGE setup gabor settings
sigma1 = 6;%p54 this is for coarse scale, =1.5 for fine scale
aspectratio = 0.5; %paper p51
bandwidth = 0.56; %sigma/lambda = 0.56 from paper p51
orientation1 = 90; %Number of Orientations used in paper = 12 from p53
wavelength = sigma1/0.56; %p51
phaseOffset = [0, pi/2];
gEven = gabor_fn(bandwidth, aspectratio, phaseOffset(1), wavelength, orientation1);
gOdd = gabor_fn(bandwidth, aspectratio, phaseOffset(2), wavelength, orientation1);


%TO CHANGE initialize actMaps variable
actMaps = zeros(32);
actMaps(:,:,2) = zeros(32);
%TO CHANGE run gabor filtering even/odd per orientation
for index = 1:4
  outMagEven = conv2(testImage1, gEven, 'same');
  outMagOdd = conv2(testImage1, gOdd, 'same');
  
  disp(size(outMagEven));
  imshow(outMagEven);
  title('even');
  pause(0.5);
  imshow(outMagOdd);
  title('odd');
  pause(0.5);
  
  Igabor = sqrt(outMagOdd.^2 + outMagEven.^2);
 
  disp(size(Igabor));

  
  imshow(Igabor);
  title(index);
  pause(1);
  
  actMaps(:,:,index) = Igabor;
end

%DEBUG
img = actMaps(:,:,1);
imshow(img);
title('img at second layer');

end