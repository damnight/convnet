function imageWeighted = surroundWeighting_new(image)
%target[x,y] pixel
%original[x,y] pixel
%image(520,520,13) 512x512 with 4 padding


weight = 0;
disp(size(image));
disp(weight);
disp(image);

imageN = image;
disp(size(imageN));

dimen = image(:,:,2);
disp(dimen);

%run over entire image with x,y this is the double for loop a convolution
%would replace
for x = 1:size(image(1))
    for y = 1:size(image(2))
        
        %convolution region in the image
        xmax = x + 4;
        xmin = x - 4;
        ymax = y + 4;
        ymin = y - 4;
        
        %run over surrounding 9x9 region with u,v
        for u = xmin:xmax
            for v = ymin:ymax
                
                i = x+u+4; %4 is the padding added in preprocessing
                j = y+v+4;
        
                weight = weight + sumOverOrMaps(image, [i,j], [x,y]); %[i,j] target; [x,y] original
            
            end
        end
        %after a region is check we write the weight to our original pixecl
        imageN(x,y,1) = image(x,y,1) * weight;
        
    end
end

imageWeighted = imageN;
disp(imageN);
end