function extWeightMask = apdtEndInhibExt(imInhibMap, k)

permO = {[x+1, y], [x+1, y], [x+1, y+1], [x, y+1], [x-1, y+1], [x-1, y+1], [x-1, y], [x-1, y], [x-1, y-1], [x, y-1], [x+1, y-1], [x+1, y],}
orientationList = {0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330};
actualImage = imInhibMap(:,:,1);
orientationMap = imInhibMap(:,:,2);
%startpoint of surround region is the top left corner, so transposing:
xx = x-(k-2); 
yy = y-(k-2);
%use a filter with the same height and width of the image to convolute over
%the image in the net
mask = zeros(size(imInhibMap,1));

for x=1:size(actualImage,1)
    for y=1:size(actualImage,2)        
       
        %check for a chain in endregion
        j = orientationMap(x, y);       
        
        chain = checkForCont(permO(j), orientationMap, 1);
        
        if(size(chain) >= 3)
            for a = 1:size(chain)
                [x, y] = chain(a);
                mask(x, y) = 0.5; %can be realised with a function or experimenting with values
            end
        else
            %do nothing
        end
    end
end

%at this point the mask will be filled with 0, and where there are longer
%chains of the same orientation there will be 0.5s.
extWeightMask = mask;

end

function ch = checkForCont(x, y, orientationMap, i)

%8 permutations for the immediate surrounding region 
perm = {[x-1, y], [x+1, y], [x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y+1], [x, y+1], [x+1, y+1]}

if(i >= 9)
    ch = chainTemp;
    %checks if orientations are the same, maybe we need a +/- few degrees
    %here
elseif(orientationMap(x,y) == orientationMap(perm(i)))
    chainTemp = chainTemp + perm(i);
else
    checkForCont(perm(i +1), orientationMap, i+1);
end
end