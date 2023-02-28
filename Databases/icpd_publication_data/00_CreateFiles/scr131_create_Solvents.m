clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');

Solvents = [];

%% Literature
% 1 - E. R. Logan: A Study of the Physical Properties of Li-Ion Battery Electrolytes Containing Ester
% 2 - M. Ue: Nonaqueous Electrolytes with Advances in Solvents
% 3 - K. Xu: Nonaqueous Liquid Electrolytes for Lithium-Based Rechargeable Batteries
% 4 - BatPaC

%% carbonates
Name = 'EthyleneCarbonate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [3, 4, 3]; % from (1); (2); (3)
Density = 1.32; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'EC');
MeltingPoint = 36.4; % from (3)
BoilingPoint = 248; % from (3)
TemperatureVector = 40; % from (3)
Viscosity = 1.9; % from (3)
RelativePermittivity = 89.78; % from (3)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

Name = 'EthylMethylCarbonate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [4, 8, 3]; % from (1); (2); (3)
Density = 1.01; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'EMC');
MeltingPoint = -53; % from (3)
BoilingPoint = 110; % from (3)
TemperatureVector = 25; % from (3)
Viscosity = 0.65; % from (3)
RelativePermittivity = 2.958; % from (3)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

Name = 'DimethylCarbonate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [3, 6, 3]; % from (1); (2); (3)
Density = 1.06; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'DMC');
MeltingPoint = 4.6; % from (3)
BoilingPoint = 91; % from (3)
TemperatureVector = 20; % from (3)
Viscosity = 0.59; % from (3)
RelativePermittivity = 3.107; % from (3)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

Name = 'PropyleneCarbonate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [4, 6, 3]; % from (1); (2); (3)
Density = 1.2; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'PC');
MeltingPoint = -48.8; % from (3)
BoilingPoint = 242; % from (3)
TemperatureVector = 25; % from (3)
Viscosity = 2.53; % from (3)
RelativePermittivity = 64.92; % from (3)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

Name = 'DiethylCarbonate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [5, 10, 3]; % from (1); (2); (3)
Density = 0.97; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'DEC');
MeltingPoint = -74.3; % from (3)
BoilingPoint = 126; % from (3)
TemperatureVector = 25; % from (3)
Viscosity = 0.75; % from (3)
RelativePermittivity = 2.805; % from (3)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

%% esters
Name = 'MethylAcetate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [3, 6, 2]; % from (1); (2); (3)
Density = 0.93; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'MA');
MeltingPoint = -98; % from (1)
BoilingPoint = 57; % from (1)
TemperatureVector = 25; % from (1)
Viscosity = 0.40; % from (1)
RelativePermittivity = 6.68; % from (1)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

Name = 'EthylAcetate';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.oxygen]; % from (1; 2; 3
MolarFractions = [4, 8, 2]; % from (1); (2); (3)
Density = 0.89; % from (2)
obj = Solvent(Name, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'EA');
MeltingPoint = -84; % from (1)
BoilingPoint = 77; % from (1)
TemperatureVector = 25; % from (1)
Viscosity = 0.46; % from (1)
RelativePermittivity = 6; % from (1)
obj = SetProperty(obj, 'MeltingPoint', MeltingPoint);
obj = SetProperty(obj, 'BoilingPoint', BoilingPoint);
obj = SetProperty(obj, 'TemperatureVector', TemperatureVector);
obj = SetProperty(obj, 'Viscosity', Viscosity);
obj = SetProperty(obj, 'RelativePermittivity', RelativePermittivity);
obj = SetProperty(obj, 'Source', 'M. Ue: Nonaqueous Electrolytes with Advances in Solvents');
obj = SetProperty(obj, 'Confidential', 'No');
Solvents.(Name) = obj;

%%Save elements
outputStruct = Solvents;
folder = 'Databases\icpd_publication_data\Solvents\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\Solvents\Solvents.mat', 'Solvents');
clear all
close all