%determine orientation distribution weight
function orWeight = orWeight(actualOrr, targetOrr)
%orientations are labeled with a number from 0-330 (in steps of 30 (12
%total))
%we want to find a Delta to describe how different they are, opposing
%directions are most different
k=1;
orientation = (1/2) *(1 + cos(double(targetOrr) - double(actualOrr))) .^ k;

orWeight = orientation(1);

end