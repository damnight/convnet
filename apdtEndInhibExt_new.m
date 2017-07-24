function extWeightMask = apdtEndInhibExt_new(wImage)

mask = zeros(size(image(1)));
faciValue = 0.3;

for x = 1:size(wImage(1))
    for y = 1:size(wImage(2))

        lOrient = maxEnLoc(image, x,y); %returns [maxEnergy, orientationIndex]
        
        %energy = lOrient(1);
        orient = lOrient(2);
        checker = checkForOrientationHood(image, orient, x, y);
        
        if(checker(1)) %returns true if correct orientation is found
            mask(x,y) = faciValue;
            [i, j] = checker(2,1); %coordR
            mask(i,j) = faciValue;
        elseif(checker(2)) %returns true if correct orientation is found
            mask(x,y) = faciValue;
            [i, j] = checker(2,2); %coordL
            mask(i,j) = faciValue;
        end
                         
        
    end
end

extWeightMask = mask;

end