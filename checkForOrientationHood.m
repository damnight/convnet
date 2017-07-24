function hasNeighbor = checkForOrientationHood(image, orient, x, y)
%right, left
%up, down
%rightUp, leftDown
%rightDown, leftUp
hasNeighborT = [false, false; coordR, coordL];

switch orient
    case 1 %0       
        rightOrient = maxEnLoc(image, x+1,y);
        leftOrient = maxEnLoc(image, x-1,y);
        
        if(rightOrient(2) == orient)
            hasNeighborT(1,1) = true;
            hasNeighborT(2,1) = [x+1, y];
            if(leftOrient(2) == orient)
                hasNeighborT(1,2) = true;
                hasNeighborT(2,2) = [ x-1,y];
            end
        end
        hasNeighbor = hasNeighborT;
        
    case 2 %15
        
    case 3 %30
        
    case 4 %45
        rightOrient = maxEnLoc(image, x+1,y+1);
        leftOrient = maxEnLoc(image, x-1,y-1);
        
        if(rightOrient(2) == orient)
            hasNeighborT(1,1) = true;
            hasNeighborT(2,1) = [x+1,y+1];
            if(leftOrient(2) == orient)
                hasNeighborT(1,2) = true;
                hasNeighborT(2,2) =  [x-1,y-1];
            end
        end
        hasNeighbor = hasNeighborT;
        
    case 5 %60
        
    case 6 %75
        
    case 7 %90
        rightOrient = maxEnLoc(image, x,y+1);
        leftOrient = maxEnLoc(image, x,y-1);
        
        if(rightOrient(2) == orient)
            hasNeighborT(1,1) = true;
            hasNeighborT(2,1) = [ x,y+1];
            if(leftOrient(2) == orient)
                hasNeighborT(1,2) = true;
                hasNeighborT(2,2) = [x,y-1];
            end
        end
        hasNeighbor = hasNeighborT;
        
    case 8 %105
        
    case 9 %120
        
    case 10 %135
        rightOrient = maxEnLoc(image, x+1,y-1);
        leftOrient = maxEnLoc(image, x-1,y+1);
        
        if(rightOrient(2) == orient)
            hasNeighborT(1,1) = true;
            hasNeighborT(2,1) = [x+1,y-1];
            if(leftOrient(2) == orient)
                hasNeighborT(1,2) = true;
                hasNeighborT(2,2) = [x-1,y+1];
            end
        end
        
        hasNeighbor = hasNeighborT;
    case 11 %150
        
    case 12 %165
end


end