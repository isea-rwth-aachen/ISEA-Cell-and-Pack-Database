function [RMSE] = FcnCalcDeviation(Cell, x_set)
nr_of_samples=100;

AM_Anode = Cell.ElectrodeStack.Anode.Coating.ActiveMaterial;
AM_Cathode = Cell.ElectrodeStack.Cathode.Coating.ActiveMaterial;

OR_Anode_calc = linspace(x_set(1), x_set(2), nr_of_samples);
OR_Cathode_calc = linspace(x_set(4), x_set(3), nr_of_samples);

% Calculation of the voltage values of anode and cathode at the supporting points
% vector length: 1000
OCP_Anode_calc = spline(AM_Anode.OccupancyRate, AM_Anode.OpenCircuitPotential, OR_Anode_calc);
OCP_Cathode_calc = spline(AM_Cathode.OccupancyRate, AM_Cathode.OpenCircuitPotential, OR_Cathode_calc);

% calculated ocv of the full cell
% vector length: 1000
OCV_Cell_calc = fliplr(OCP_Cathode_calc) - OCP_Anode_calc;

% 1000 supporting point at the measured ocv
SOC_Cell_measured = linspace(min(Cell.StateOfCharge), max(Cell.StateOfCharge), nr_of_samples);

% Calculation of the voltage values of the measured cell at the supporting points
% vector length: 1000
OCV_Cell_measured = spline(Cell.StateOfCharge, Cell.OpenCircuitVoltage, SOC_Cell_measured);

% calculation of rmse
RMSE = OCV_Cell_calc - OCV_Cell_measured;
RMSE = RMSE .* RMSE;
RMSE = sqrt(sum(RMSE)/length(RMSE));
end

