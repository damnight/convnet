
function gaborFilter = gaborFilter(orr, phase)
        %TO CHANGE setup gabor settings
sigma1 = 6;%p54 this is for coarse scale, =1.5 for fine scale
aspectratio = 0.5; %paper p51
bandwidth = 0.56; %sigma/lambda = 0.56 from paper p51
orientation = [0 30 60 90 120 150 180 210 240 270 300 330]; %Number of Orientations used in paper = 12 from p53
wavelength = sigma1/0.56; %p51
phaseOffset = [0, pi/2];

            if(strcmp(phase,'even'))
                gaborFilter = gabor_fn(bandwidth, aspectratio, phaseOffset(1), wavelength, orientation(orr));
            elseif(strcmp(phase,'odd'))
                gaborFilter = gabor_fn(bandwidth, aspectratio, phaseOffset(1), wavelength, orientation(orr));
            else
                disp('not a valid argument');
            end
end