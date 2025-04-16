%0. Read image
im = imread('hello.jpg');
image(im);
%1. prep image for processing (convert to graysclae)
gray = (0.2989 * double(im(:,:,1)) + 0.5870 * double(im(:,:,2)) + 0.1140 * double(im(:,:,3)))/255;

%2. run the sobelfilter
edgeIm = sobel_mex(gray, 0.7);

%3. display output image
im3 = repmat(edgeIm, [1 1 3]);
image(im3);

%4. build own sobelfilter to be used in above sequence
% edgeImage = sobel(originalImage, threshold)
% Sobel edge detection. Given a normalized image (with double values)
% return an image where the edges are detected w.r.t. threshold value.
function edgeImage = sobel(originalImage, threshold) %#codegen
assert(all(size(originalImage) <= [1024 1024]));
assert(isa(originalImage, 'double'));
assert(isa(threshold, 'double'));

k = [1 2 1; 0 0 0; -1 -2 -1]; %the filter
H = conv2(double(originalImage),k, 'same');
V = conv2(double(originalImage),k','same');
E = sqrt(H.*H + V.*V);
edgeImage = uint8((E > threshold) * 255);

%4.Edge orientation histogram
%
% [eoh] = edgeOrientationHistogram(im)
%
% Extract the MPEG-7 "Edge Orientation Histogram" descriptor
% 
% Input image should be a single-band image, but if it's a multiband (e.g. RGB) image
% only the 1st band will be used.
% Compute 4 directional edges and 1 non-directional edge
% The output "eoh" is a 4x4x5 matrix
%
% The image is split into 4x4 non-overlapping rectangular regions
% In each region, a 1x5 edge orientation histogram is computed (horizontal, vertical,
% 2 diagonals and 1 non-directional)
%
function [eoh] = edgeOrientationHistogram(im)

% define the filters for the 5 types of edges
f2 = zeros(3,3,5);
f2(:,:,1) = [1 2 1;0 0 0;-1 -2 -1];
f2(:,:,2) = [-1 0 1;-2 0 2;-1 0 1];
f2(:,:,3) = [2 2 -1;2 -1 -1; -1 -1 -1];
f2(:,:,4) = [-1 2 2; -1 -1 2; -1 -1 -1];
f2(:,:,5) = [-1 0 1;0 0 0;1 0 -1];

ys = size(im,1);
xs = size(im,2);


gf = gaussianFilter(11,1.5);
im = filter2(gf, im(:,:,1));
im2 = zeros(ys,xs,5);
for i = 1:5
    im2(:,:,i) = abs(filter2(f2(:,:,i), im));
end

[mmax, maxp] = max(im2,[],3);

im2 = maxp;

ime = edge(im, 'canny', [], 1.5)+0;
im2 = im2.*ime;

eoh = zeros(4,4,6);
for j = 1:4
    for i = 1:4
        clip = im2(round((j-1)*ys/4+1):round(j*ys/4),round((i-1)*xs/4+1):round(i*xs/4));
        eoh(j,i,:) = permute(hist(makelinear(clip), 0:5), [1 3 2]);
    end
end

eoh = eoh(:,:,2:6);

%4. adjusted histogram 12 orient
% parameters
%- the image
% - the number of vertical and horizontal divisions
function [data] = edgeOrientationHistogram(im, r)

% define the filters for the 5 types of edges
f2 = zeros(5,4,12);

f2(:,:,1) = [ 1  1  1  1  1
              0  0  0  0  0
              0  0  0  0  0
             -1 -1 -1 -1 -1]%(0deg)
         
f2(:,:,2) = [1  1  1  1  0 
             1  1  0  0  0 
             0  0  0 -1 -1 
             0 -1 -1 -1 -1];%(30deg)
         
f2(:,:,3)  =[1 1  1  0 -1
             1 1  0  0 -1
             1 0  0 -1 -1
             1 0 -1 -1 -1];%(60deg)

f2(:,:,4) = [-1 -1 0 1 1
             -1 -1 0 1 1
             -1 -1 0 1 1
             -1 -1 0 1 1]%(90deg)

f2(:,:,5)  = [1 0 -1 -1 -1 
              1 0  0 -1 -1
              1 1  0  0 -1
              1 1  1  0 -1]%(120deg)
          
f2(:,:,6)  =  [0 -1 -1 -1 -1
               1  0  0 -1 -1
               1  1  0  0 -1
               1  1  1  1  0];%(150deg)    
           
f2(:,:,7) = [-1 -1 -1 -1 -1
              0  0  0  0  0
              0  0  0  0  0
              1  1  1  1  1]; %(180deg)
          
f2(:,:,8) = [-1  -1 -1 -1  0 
              -1  -1  0  0  0 
               0   0  0  1  1 
               0   1  1  1  1]; %(210deg)
           
f2(:,:,9) = [-1 -1  -1  0 1
               -1 -1   0  0 1
               -1  0   0  1 1
               -1  0   1  1 1]; %(240deg)
           
f2(:,:,10) = [1 1 0 -1 -1
             1 1 0 -1 -1
             1 1 0 -1 -1
             1 1 0 -1 -1]; %(270deg)
         
f2(:,:,11) = [-1 0 1  1  1 
             -1 0  0  1  1
             -1 -1  0  0  1
             -1 -1  -1  0  -1];%(300deg)

f2(:,:,12) =  [ 0  1  1  1  1
              -1  0  0  1  1
              -1 -1  0  0  1
              -1 -1 -1 -1  0];%(330deg)


% the size of the image
ys = size(im,1);
xs = size(im,2);

% The image has to be in gray scale (intensities)
if (isrgb(im))
    im = rgb2gray(im);
endif

% Build a new matrix of the same size of the image
% and 12 dimensions to save the gradients
im2 = zeros(ys,xs,12);

% iterate over the posible directions
for i = 1:12
    % apply the sobel mask
    im2(:,:,i) = filter2(f2(:,:,i), im);
end

% calculate the max sobel gradient
[mmax, maxp] = max(im2,[],4);
% save just the index (type) of the orientation and ignore the value of the gradient
im2 = maxp;

% detect the edges using the default Octave parameters
ime = edge(im, 'canny');

% multiply against the types of orientations detected
% by the Sobel masks
im2 = im2.*ime;

% produce a structure to save all the bins of the histogram of each region
eoh = zeros(r,r,6);
% for each region
for j = 1:r
    for i = 1:r
        % extract the subimage
        clip = im2(round((j-1)*ys/r+1):round(j*ys/r),round((i-1)*xs/r+1):round(i*xs/r));
        % calculate the histogram for the region
        eoh(j,i,:) = (hist(makelinear(clip), 0:5)*100)/numel(clip);
    end
end

% take out the zeros
eoh = eoh(:,:,2:6);

% represent all the histograms on one vector
data = zeros(1,numel(eoh));
data(:) = eoh(:);