function [hasNeighborT, hasNeightborAt] = checkForOrientationHood(image, orient, x, y)
%right, left
%up, down
%rightUp, leftDown
%rightDown, leftUp
%disp(orient);

hasNeighborT = [false, false]; 
hasNeightborAt = [[0 0], [0 0]];
%disp(hasNeightborAt);

switch orient
    case 0 %the padding
       hasNeighborT = [false, false]; 
       hasNeightborAt = [[0 0], [0 0]];
        
    case 1 %0       
        [energy, rightOrient] = maxEnLoc(image, x+1,y);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y);
        %disp(rightOrient);
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1, y];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [ x-1,y];
            end
        end
        %disp(hasNeighborT);

        
    case 2 %15 
                [energy, rightOrient] = maxEnLoc(image, x+1,y);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y);
        %disp(rightOrient);
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1, y];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [ x-1,y];
            end
        end
        %disp(hasNeighborT);

        
    case 3 %30  
        [energy, rightOrient] = maxEnLoc(image, x+1,y);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y);
        %disp(rightOrient);
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1, y];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [ x-1,y];
            end
        end
        %disp(hasNeighborT);

        
    case 4 %45
        [energy, rightOrient] = maxEnLoc(image, x+1,y+1);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y-1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1,y+1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) =  [x-1,y-1];
            end
        end
        
    case 5 %60   
             [energy, rightOrient] = maxEnLoc(image, x+1,y+1);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y-1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1,y+1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) =  [x-1,y-1];
            end
        end

        
    case 6 %75    
              [energy, rightOrient]= maxEnLoc(image, x+1,y+1);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y-1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1,y+1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) =  [x-1,y-1];
            end
        end

        
    case 7 %90
     [energy, rightOrient] = maxEnLoc(image, x,y+1);
       [energyl, leftOrient] = maxEnLoc(image, x,y-1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [ x,y+1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [x,y-1];
            end
        end

        
    case 8 %105
         [energy, rightOrient] = maxEnLoc(image, x,y+1);
        [energyl, leftOrient] = maxEnLoc(image, x,y-1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [ x,y+1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [x,y-1];
            end
        end

        
    case 9 %120 
        [energy, rightOrient] = maxEnLoc(image, x,y+1);
        [energyl, leftOrient] = maxEnLoc(image, x,y-1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [ x,y+1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [x,y-1];
            end
        end

        
    case 10 %135
        [energy, rightOrient] = maxEnLoc(image, x+1,y-1);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y+1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1,y-1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [x-1,y+1];
            end
        end

        
    case 11 %150
         [energy, rightOrient] = maxEnLoc(image, x+1,y-1);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y+1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1,y-1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [x-1,y+1];
            end
        end
        

        
    case 12 %165
        [energy, rightOrient] = maxEnLoc(image, x+1,y-1);
        [energyl, leftOrient] = maxEnLoc(image, x-1,y+1);
        
        if(rightOrient == orient)
            hasNeighborT(1,1) = true;
            hasNeightborAt(1,1) = [x+1,y-1];
            if(leftOrient == orient)
                hasNeighborT(1,2) = true;
                hasNeightborAt(1,2) = [x-1,y+1];
            end
        end

        
    otherwise
       hasNeighborT = [false, false]; 
       hasNeightborAt = [[0 0], [0 0]];
        
end


end