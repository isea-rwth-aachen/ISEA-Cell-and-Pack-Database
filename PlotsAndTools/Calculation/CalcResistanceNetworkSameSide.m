function [R_total] = CalcResistanceNetworkSameSide(R_left, R_center, R_right)
% NrOfCrossings correlates to the amount of R_center (left to right crossings) in the ECM
% R_c -> resistance in the center, caluclated interatively

NrOfCrossings = 1000;
R_left = R_left / NrOfCrossings;
R_center = R_center * NrOfCrossings;
R_right = R_right / NrOfCrossings;

R_c = R_center;

for index = 1:NrOfCrossings-1
    R_c = R_c + R_left + R_right;
    R_c = R_c * R_center / (R_c + R_center);
end

R_total = R_c + R_left + R_right;
end