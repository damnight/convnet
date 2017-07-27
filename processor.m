function processor
ori = {'original', '0', '15', '30' , '45', '60', '75', '90', '105', '120', '135', '150', '165'};
warning('off','all')
%load images
imds = initImds;



%preprocess
procImages = preprocessImage;
%imshow(procImages(:,:,1));
sample = procImages(:,:,:);

for q = 1:13
figure(q);
imshow(sample(:,:,q));
title(['gaborfilter ', ori(q)]);
end


figure();
for l = 1:13
subplot(4,4,l), imshow(sample(:,:,l),[]);
title(['gaborfilter ', ori(l)]);
end

%surroundInhibit
sInh = surroundWeighting_new1(sample);
%disp(sInh);
%sInh = padarray(sInh, [4 4]); only for 'valid' conv
imshow(sInh(:,:,1));
title('surround inhib');

%resize (to coarse res) and adapt end inhibit
coarseImage1 = imresize(sample(:,:,1), 0.5);
coarseImage2 = imresize(coarseImage1(:,:,1), 2);
coarseImage = coarseImage2(:,:,1);
coarseImage(:,:,2:13) = sample(:,:,2:13);

disp('size coareImage');
disp(size(coarseImage));
eInh = adptEndInhib(sample, coarseImage, sInh);


%extend end inhibition
weightmask = apdtEndInhibExt_new(coarseImage);
%disp(weightmask);
%imshow(weightmask);
%imshow(eInh);

%bring inhibition maps together
eFac = conv2(weightmask, eInh(:,:,1), 'same');

X = [size(sample), size(sInh), size(eInh), size(eFac)];
disp(X);
%disp(weightmask);


finalImage = double(sample(:,:,1)) - double(sInh(:,:,1)) - double(eInh(:,:,1)) + double(eFac);
%disp(finalImage);
%imshow(finalImage);
b = imbinarize(finalImage, 250);
figure
subplot(1,3,1), imshow(sample(:,:,1)), title('original');
subplot(1,3,2), imshow(finalImage), title('final image');
subplot(1,3,3), imshow(b), title('binary map');

%create bitmap
%figure(1);
%imshow(finalImage);


end