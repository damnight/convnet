function imageWeighted = surroundWeighting_new1(image)
%target[x,y] pixel
%original[x,y] pixel
%image(520,520,13) 512x512 with 4 padding


weight = 0;
ex_weight = 0;
% disp(size(image));
% disp(weight);
% disp(image);

imageN = image;
% disp(size(imageN));
% 
% dimen = image(:,:,2);
% disp(dimen);

%run over entire image with x,y this is the double for loop a convolution
%would replace
[cols] = size(image);
i = 0;
j = 0;

filter1 = zeros(9,9,4);
filter1(:,:,1) = getFilter(0);
filter1(:,:,2) = getFilter(45);
filter1(:,:,3) = getFilter(90);
filter1(:,:,4) = getFilter(135);

imageWeighted = convn(image, filter1, 'same');
disp('image unweighted: ');
disp(image(1:10,1:10,1));

disp('image weighted sample');
disp(size(imageWeighted));
disp(floor(imageWeighted(1:10,1:10,1)));
%imageWeighted = floor(imageWeighted(:,:,1));
%disp(imageWeighted);

figure();
disp(size(imageWeighted));
g = uint8(imageWeighted(:,:,1));
imshow(imageWeighted(:,:,1), []);
title('image weighted');


% for x = 5:512
%     for y = 5:512
%         
%         %convolution region in the image
%         xmax = x + 4;
%         xmin = x - 4;
%         ymax = y + 4;
%         ymin = y - 4;
%         
%         %run over surrounding 9x9 region with u,v
%         for u = -4:4
%             for v = -4:4
%                 
%                 i = x+u; %4 is the padding added in preprocessing
%                 j = y+v;
%         
%                 weight = weight + sumOverOrMaps(image, [i,j], [x,y]); %[i,j] target; [x,y] original
%                 
%             end
%         end
%         %after a region is check we write the weight to our original pixel
%         %disp(size(image(x,y,1)));
%         %disp(weight);
%         %disp(image(x,y,1));
%         imageN(x,y,1) = image(x,y,1) - weight;
%         %imageN(:,:,1) = conv2(double(image(:,:,1)), double(weight), 'same');
% 
%     end
% end
%         disp(image(1:15,1:15,1));
%         disp(imageN(1:15,1:15,1));
%         
% figure(2);
% disp(imageN(:,:,1));
% imshow(imageN(:,:,1));
% imageWeighted = imageN;
%disp(imageN);
end