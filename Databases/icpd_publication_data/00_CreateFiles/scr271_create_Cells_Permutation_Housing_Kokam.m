clear all
close all

Cells = load('Databases\icpd_publication_data\Cells\Cell_Kokam7_5Ahv2.mat');
load('Databases\icpd_publication_data\Housings\Housings.mat');
load('Databases\icpd_publication_data\Electrolytes\Electrolytes.mat');

cells = Cells; 
cellnames = fieldnames(cells);
housings = Housings; 
housingnames = fieldnames(housings);
fithousing = ["HousingCylindrical_18650", "HousingCylindrical_21700","HousingPouchS", "HousingPouchM", "HousingPouchL", "HousingPrismaticS", "HousingPrismaticM", "HousingPrismaticL"];
fitcapacities = [0, 0, 0, 0, 0, 0, 0, 0];
cathodeVoltages = [5]; 
surfaceCapacities = [0]; 
relVoltageLimits = [0]; 
materialUsageRestrictions = [0]; 
electrolytes.ECEMC = Electrolytes.Electrolyte_LP50; 

stackFolder = 'Databases\icpd_publication_data\ElectrodeStacks_Housing_Kokam\';
cellFolder = 'Databases\icpd_publication_data\Cells_Housing_Kokam\';

a = fcn_create_Cells_Permutation(cells, housings, fithousing, fitcapacities, cathodeVoltages, ...
    surfaceCapacities, relVoltageLimits, materialUsageRestrictions, electrolytes, stackFolder, cellFolder);

clear all
close all