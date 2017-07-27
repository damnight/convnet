function filter = getFilter(orientationFilter)


a = 0;
b = 0.01;
c = -1;


switch orientationFilter
    
    case 0
 filter = [ b b b b b b b b b
            b b b b b b b b b
            b b b b b b b b b
            a a a a a a a a a
            a a a a a a a a a
            a a a a a a a a a
            b b b b b b b b b
            b b b b b b b b b
            b b b b b b b b b];

    case 45      
  filter = [ b b b b b b b a a 
             b b b b b b a a a
             b b b b b a a a b 
             b b b b a a a b b 
             b b b a a a b b b
             b b a a a b b b b
             b a a a b b b b b
             a a a b b b b b b
             a a b b b b b b b];

        
    case 90
  filter = [ b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b
             b b b a a a b b b];

    case 135
   filter = [ a a b b b b b b b
              a a a b b b b b b
              b a a a b b b b b
              b b a a a b b b b
              b b b a a a b b b
              b b b b a a a b b 
              b b b b b a a a b
              b b b b b b a a a
              b b b b b b b a a];


    otherwise
 filter = [ 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0];


end