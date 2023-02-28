clear all
close all

% color scale in paraview from 0 to 30
Colors_All = {
    [0, 0, 150]/255 ... % 1 | anode
    [150, 0, 0]/255 ... % 2 | cathode
    [200, 200, 200]/255 ... % 3 | separator
    [220, 0, 220]/255 ... % 4 | electrolyte
    [60, 60, 60]/255 ... % 5 | housing
    [170, 170, 0]/255 ... % 6 | active transfer material
    [100, 100, 130]/255 ... % 7 | CC anode
    [130, 100, 100]/255 ... % 8 | CC cathode
    [60, 60, 60]/255 ... % 9 | cell
    [0, 0, 150]/255 ... % 10 | neg. pole
    [150, 0, 0]/255 ... % 11 | pos. pole
    };

save('PlotsAndTools\ColorListForPlots\Color_List.mat', 'Colors_All')