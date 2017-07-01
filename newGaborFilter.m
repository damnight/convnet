function newGaborFilter
  pauseTime = 0.5;
  %load images and save in array
  naturalImagesFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images';
  groundTruthFolder = 'D:\User\Marco\Documents\!Studium\Informatik\VIP\matlab\convnet\images\gt';

%show images for testing
natFilePattern = fullfile(naturalImagesFolder, '*.pgm');
natFiles = dir(natFilePattern);

gtFilePattern = fullfile(groundTruthFolder, '*.pgm');
gtFiles = dir(gtFilePattern);


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
%gEven = gabor_fn(bandwidth, aspectratio, pi, wavelength, orientation1);
%gOdd = gabor_fn(bandwidth, aspectratio, pi/2, wavelength, orientation1);

%output Gabor maps
disp('run forloop');
for k = 1:length(natFiles)
  
  
  baseFileName = natFiles(k).name;
  fullFileName = fullfile(naturalImagesFolder, baseFileName);
  I = imread(fullFileName);
  
  outMagOdd = GaborConv(I, wavelength, orientation1, bandwidth, aspectratio) 
  
  Is = imread(fullFileName);
  outMagEven = conv2(Is, gEven);

  imshow(outMagOdd);
  title('Odd');   
  drawnow;
  
  %pause(pauseTime);
  
  %imshow(outMagEven);
  %title('Even'); 
  %drawnow;
  %pause(pauseTime);
end


%setup cnn
%cnn = cnnsetup(cnn, natFiles, train_y);

%opts.alpha = 1;
%opts.batchsize = 50;
%opts.numepochs = 1;

%train cnn
%cnn = cnntrain(cnn, train_x, train_y, opts);

end



%Gabor Filter
function [ ReConv,ImConv ] = GaborConv( Img, P0,Orient, FBW, ABW,varargin )
  %IMG must be MxNx1 of doubles between 0 and 1
  %P0 is the wavelength
  %Orient is the Orientation of the filter in radians
  %FBW is the Frequency Bandwidth in Octaves
  %ABW is the angle bandwidth
  %varargin Variable-length input argument list https://de.mathworks.com/help/matlab/ref/varargin.html
  
  
 ReConv=Img; ImConv=Img;
 ImgFFt=fft2(Img);
 lg2pi=sqrt(log(2)/pi);
 A=P0*lg2pi*(2^FBW+1)/(2^FBW-1); B=P0*lg2pi*(1/tan(0.5*ABW));
 K=1/(A*B); KF=2*pi/P0;
 [N,M]=size(Img); u0=1/P0*cos(Orient); v0=1/P0*sin(Orient);
 FFilt=zeros([M,N]);
 stx=1/(M-1); sty=1/(N-1);
 [U V]=meshgrid(-0.5:stx:0.5,-0.5:sty:0.5);
 Ur=(U-u0)*cos(Orient)+(V-v0)*sin(Orient);
 Vr=-(U-u0)*sin(Orient)+(V-v0)*cos(Orient);
 FFilt=exp(-pi*(Ur.*Ur.*A.*A+Vr.*Vr.*B.*B)) ;
 FFilt=ifftshift(FFilt);
 normFact=sum(sum((abs(ifft2(FFilt)))));
 RezFreq=FFilt.*ImgFFt/normFact; RezSpace=ifft2(RezFreq);
 ReConv=real(RezSpace); ImConv=imag(RezSpace);
end