clear all
close all

Cells = load('Databases\icpd_publication_data\Cells\Cell_MJ1.mat');
load('Databases\icpd_publication_data\Housings\Housings.mat');
load('Databases\icpd_publication_data\Electrolytes\Electrolytes.mat');

cells = Cells; 
cellnames = fieldnames(cells);
housings = Housings; 
housingnames = fieldnames(housings);
fithousing = ["HousingCylindrical_18650"];
fitcapacities = [0];
cathodeVoltages = [5]; 
surfaceCapacities = [0, 2, 4, 6, 8, 10]; 
relVoltageLimits = [0]; 
materialUsageRestrictions = [0]; 
electrolytes.ECEMC = Electrolytes.Electrolyte_1M_LiPF6_10_PC_27_EC_63_DMC; 

stackFolder = 'Databases\icpd_publication_data\ElectrodeStacks_Cap_MJ1\';
cellFolder = 'Databases\icpd_publication_data\Cells_Cap_MJ1\';

a = fcn_create_Cells_Permutation(cells, housings, fithousing, fitcapacities, cathodeVoltages, ...
    surfaceCapacities, relVoltageLimits, materialUsageRestrictions, electrolytes, stackFolder, cellFolder);

clear all
close all