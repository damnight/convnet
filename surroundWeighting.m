%figure out the weighing for the surroundInhibition
function surroundWeight = surroundWeighting(image)
%prep variables
%k is the radius multiplier between CRF and nCRF
orientationList = {0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330};
actualImage = image(:,:,1);
k = 4;


% loop over all rows and columns
for ii=1:size(actualImage,1)
    for jj=1:size(actualImage,2)        

        %startpoint of surround region is the top left corner, so transposing:

        yy = ii-(k-2); 
        xx = jj-(k-2);

        %loop through  the surround region
        for yy = 1:(ii*k)
            for xx = 1:(jj*k)
               %get the target pixel orientation
                targetOrr = orientationList(orientationMap(yy, xx));
                
                %calculate weight based on orientation
                orWeight = orWeighting(actualOrr, targetOrr);
                
                      
               
                %calculate weight based on spatial distance
                coords = [ii jj, ...
                          yy xx];
                spWeight = spatialWeighting(coords);
                
                %multiply (11) the weights into single weighting value
                localweight = spWeight * orWeight;
                
                %accumulate the weights from all the different cells in the
                %surround region
                cumulativeWeight = localweight + cumulativeWeight; 
            end
        end 
    end
end
surroundWeight = cumulativeWeight;
end
