%this function sums all the weights(which are calculated each with the
%orientation weighting and spatial weighting) of a single position in
%surround region of the CRF (so going along in the thrid dimension through
%every orientationMap at a specific point(x,y))
function sum = sumOverOrMaps(image, target, original) %target[x,y] is the target pixel, original[x,y] is the source pixel, image is the data(512,512,13)

i = target(1);
j = target(2);
%disp(i);
%disp(j);
accumulator = 0;
sp = spatialWeighting(target, original); %orgImage, target_x, target_y, source = [x, y]; 

%dim = image(:,:,2);
%disp(size(image));
%disp(dim);
for q = 2:13

    targetLayerAtPosition = image(i,j,q);
    %disp(targetLayerAtPosition);
    accumulator = accumulator + (orWeight(original, targetLayerAtPosition) * sp);
    
    
end


sum = accumulator * 0.001;
%disp(sum);

end