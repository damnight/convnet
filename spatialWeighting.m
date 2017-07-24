%calculates the euclidean distance between two pixels in the image
function sWeight = spatialWeighting(target, source)

sWeight = sqrt(sum((target - source) .^ 2));

end