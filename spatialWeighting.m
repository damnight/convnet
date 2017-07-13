function sWeight = spatialWeighting(image, k, sigma)

[pixelCount grayLevels] = imhist(image);
subplot(2, 2, 2); 
xlim([0 grayLevels(end)]); % Scale x axis manually.
gaussian1 = fspecial('Gaussian', k, sigma);
gaussian2 = fspecial('Gaussian', k, sigma);
dog = gaussian1 - gaussian2;
dogFilterImage = conv2(double(image), dog, 'same');
subplot(2, 2, 3); 

sWeight = dogFilterImage;

end