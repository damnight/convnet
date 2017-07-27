function [maxiEn, orient] = maxEnLoc(image, x, y)

m = 0;
o = 0;

%disp(size(image));

for q = 2:13
    m = max(image(x,y,q), m);
    if( max(image(x,y,q) > m))
        o = q;
    end
end

maxiEn = m;
orient = o;

end