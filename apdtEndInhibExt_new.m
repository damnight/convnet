function extWeightMask = apdtEndInhibExt_new(wImage)

mask = zeros(520);
faciValue = 0.3;
disp('wImage');
disp(size(wImage));

for x = 1:520
    for y = 1:520
        %disp(size(wImage));
        
        lOrient = maxEnLoc(wImage, x,y); %returns [maxEnergy, orientationIndex]
        %disp(lOrient);
        %energy = lOrient(1);
        orient = lOrient(1);
        %figure(2);
        %imshow(wImage);
        [hasNeightbor, hasNeightborAt] = checkForOrientationHood(wImage, orient, x, y);

%         disp('has neighbor at [left-coord right-coord]');
%         disp(hasNeightborAt);
%         disp('has a neighbor [left right]');
%         disp(hasNeightbor);

        
        if(hasNeightbor(1)) %returns true if correct orientation is found
            mask(x,y) = faciValue;
            [i, j] = hasNeightborAt(1); %coordR
            mask(i,j) = faciValue;
            %disp(mask(i, j));
        elseif(hasNeightbor(2)) %returns true if correct orientation is found
            mask(x,y) = faciValue;
            [i, j] = hasNeightborAt(2); %coordL
            mask(i,j) = faciValue;
            %disp(mask(i, j));
        end
                         
        
    end
end

extWeightMask = mask;
%disp(mask);

end