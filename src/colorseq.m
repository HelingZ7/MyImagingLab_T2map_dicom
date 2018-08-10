function roicolor=colorseq(i)
% including 13 unique Colors for plots
% (1-7 matching matlab default plotting colors - matlab version from 2015 to 2018) 
% index is mod 13 of i

% Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com

i=rem(i,13);
    switch i
        case 1
            roicolor=[113 188 255]/255;
        case 2
            roicolor=[216 82 24]/255;
        case 3
            roicolor=[236 176 31]/255;
        case 4
            roicolor=[125 46 141]/255;
        case 5
            roicolor=[118 171 47]/255;
        case 6
            roicolor=[76 189 237]/255;
        case 7
            roicolor=[161 19 46]/255;
        case 8
            roicolor=[0.5 0.5 0]; %earth
        case 9
            roicolor=[0.5 0 1]; %purple
        case 10
            roicolor=[1 1 0]; %yellow
        case 11
            roicolor=[0.2 0.2 0.2]; %steel gray
        case 12
            roicolor=[1 0.5 0.5]; %pink
        case 0
            roicolor=[0.1 0.1 0.8]; %dark blue
    end
end