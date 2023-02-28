clear all
close all
Li = 6.9675;
B = 10.613;
C = 12.011;
N = 14.007;
O = 15.999;
F = 18.998;
Al = 26.981;
Si = 28.085;
P = 30.974;
S = 32.067;
Ti = 47.867;
V = 50.941;
Cr = 51.996;
Mn = 54.938;
Fe = 55.845;
Co = 58.933;
Ni = 58.693;
Sn = 118.711;

MaterialDataCells = {...
    'NMC811_MJ1', 'LiNi0.82Mn0.063Co0.117O2', Li+0.82*Ni+0.063*Mn+0.117*Co+2*O, 'max', 1;...
    'Graphite', 'C6', 6*C, 'min', 0;...
    'Si', 'Si', Si, 'min', 0;...  
    'Graphite_Kokam', 'C6', 6*C, 'min', 0;...
    'NCO', 'LiNi0.4Co0.6O2', Li+0.4*Ni+0.6*Co+2*O, 'max', 1;...
    };

MaterialData = cell2table(MaterialDataCells);
MaterialData.Properties.VariableNames =["Name", "Formula", "MolarMass", "InitialLithiationType", "InitialLithiation"];
disp(MaterialData)

save('Databases\iCPD_publication_data\00_InputData\ActiveMaterials\OCVs\MaterialData.mat', 'MaterialData')
clear all
close all