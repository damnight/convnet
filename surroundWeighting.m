%figure out the weighing for the surroundInhibition
function surroundWeight = surroundWeighting(regionInImage)
%prep variables
orientationList = {0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330};
region = imageOrientations(regionInImage); %regionInImage should look like [row_start:row_end, column_start:column_end]

% loop over all rows and columns
for ii=1:size(imageOrientations,1)
    for jj=1:size(imageOrientations,2)        
        %get the actual pixel values
        %imageOrientations is an array that stores the orientation values (0-11)
        actualOrr = orientationList(imageOrientations(ii, jj)); %this should return a value between 0-330
        
        
        %loop through  the surround region
        for yy=1:size(region,1)
            for xx=1:size(region,2)
                %get the target pixel values
                targetOrr = orientationList(region(yy, xx));
                
                %calculate weight
                orWeight = orWeight(actualOrr, targetOr);
                coords = [ii jj, ...
                          yy xx];
                      
               
                localweight = conv2(spatialWeighting(coords),orWeight);
                
                cumulativeWeight = localweight + cumulativeWeight; 
            end
        end 

    end
end       

surroundWeight = cumulativeWeight;

%distance weighting fucntion half-wave rectified and L1-normalized difference of two
%concentric Gaussian functions
function spatialWeight = spatialWeighting(coords)
%sigma = kernelsize (4|5)
%k = multiplier in the papaer set to 4 (because surround region affecting
%is 2-5 times larger than kernelsize
sigma = [4 5];
k = 4;
x1 = coords(1,1); %target
y1 = cooords(1,0); %target
x2 = coords(0,1); %actual
y2 = coords (0,0); %actual

spatialWeight = max(((1/sqrt((2*pi*(k*sigma)^2)))*exp(-((x1)^2+(y1)^2)/(2*(k*sigma)^2))) - ((1/sqrt((2*pi*(sigma)^2)))*exp(-(((x2)^2+(y2)^2)/(2*(sigma)^2)))),0); %Equation (9); (x^2)+(y^2) = 2; x and y are always 1

end

%determine orientation distribution weight
function orWeight = orWeight(orr, targetOrr)
%orientations are labeled with a number from 0-330 (in steps of 30 (12
%total))
%we want to find a Delta to describe how different they are, opposing
%directions are most different
k=1;
orWeight = (1/2)*(1+cos(targetOrr - orr))^k;

end

end