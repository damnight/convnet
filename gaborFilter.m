
function gaborFilter = gaborFilter(orr, phase)
        %TO CHANGE setup gabor settings
%sigma1 = 1.5;%p54 this is for coarse scale, =1.5 for fine scale
aspectratio = 1; %paper p51
bandwidth = 2.2; %sigma/lambda = 0.56 from paper p51
orientation = [pi, 1/12*pi, 2/12*pi, 3/12*pi, 4/12*pi, 5/12*pi, 6/12*pi, 7/12*pi, 8/12*pi, 9/12*pi, 10/12*pi, 11/12*pi]; %Number of Orientations used in paper = 12 from p53
wavelength = bandwidth / 0.35; %p51
phaseOffset = [0, pi/2];

            if(strcmp(phase,'even'))
                gaborFilter = gabor_fn(bandwidth, aspectratio, 0, wavelength, orientation(orr));
            elseif(strcmp(phase,'odd'))
                gaborFilter = gabor_fn(bandwidth, aspectratio, pi/2, wavelength, orientation(orr));
            else
                disp('not a valid argument');
            end
end