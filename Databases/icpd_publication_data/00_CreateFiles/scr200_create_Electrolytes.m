clear all
close all

load('Databases\icpd_publication_data\ConductiveSalts\ConductiveSalts.mat');
load('Databases\icpd_publication_data\Solvents\Solvents.mat');

% Literature
% (1) M. Ue, Y. Sasaki, Y. Tanaka, M. Morita: Nonaqueous Electrolytes with Advances in Solvents
% (2) Guifang Guo: Three-dimensional thermal finite element modeling of lithium-ion battery in thermal abuse application

Electrolytes = [];

TemperatureVector_1 = [-40, -30, -20, -10, 0, 10, 20, 25, 30, 40, 50, 60]; % from (1)
TemperatureVector_MJ1 = [-10, 20, 40, 60]; % from (10.1149/1.1872737)
TemperatureVector_Kokam = [20, 23, 25]; % from (10.1149/2.0551509jes)
ConductiveSaltMolarityVector_1 = [0.5, 0.75, 1, 1.25, 1.5]; % from (1)
ConductiveSaltMolarityVector_MJ1 = [0.5, 1, 2, 3]; % from (10.1149/1.1872737)
ConductiveSaltMolarityVector_Kokam = [0.5, 0.75, 1, 1.25, 1.5]; % from (10.1149/2.0551509jes)
IonicConductivityMatrix_LiPF6_10_EC_90_EMC = [  0.9, 1.4, 1.9, 2.4, 3.0, 3.6, 4.2, 4.4, 4.7, 5.3, 5.8, 6.3; ...
                                       1.2, 1.8, 2.6, 3.3, 4.1, 5.0, 5.9, 6.3, 6.7, 7.5, 8.3, 9.1; ...
                                        1.0, 1.7, 2.6, 3.5, 4.4, 5.4, 6.5, 6.9, 7.4, 8.4, 9.4, 10.4; ...
                                        1.0, 1.7, 2.6, 3.7, 4.8, 5.9, 7.2, 7.6, 8.3, 9.5, 10.7, 11.8; ...
                                        0.7, 1.3, 2.1, 3.1, 4.1, 5.4, 6.7, 7.3, 8.0, 9.3, 10.7, 12.0; ...
                                        ]*100/1000; % from (1)
IonicConductivityMatrix_LiPF6_30_EC_70_EMC = [  NaN, NaN, 3.0, 4.0, 5.1, 6.3, 7.5, 8.0, 8.6, 9.8, 11.1, 12.3; ...
                                        NaN, 2.1, 3.1, 4.3, 5.6, 7.0, 8.6, 9.3, 10.0, 11.5, 13.1, 14.6; ...
                                        1.1, 1.8, 2.9, 4.1, 5.6, 7.2, 8.8, 9.6, 10.5, 12.2, 14.0, 15.8; ...
                                        0.7, 1.3, 2.3, 3.4, 4.8, 6.5, 8.2, 9.0, 9.9, 11.8, 13.7, 15.6; ...
                                        0.4, 1.0, 1.8, 3.0, 4.4, 6.0, 7.7, 8.5, 9.4, 11.3, 13.3, 15.5; ...
                                        ]*100/1000; % from (1)
IonicConductivityMatrix_LiPF6_50_EC_50_EMC = [  NaN, NaN, NaN, 3.8, 4.9, 6.3, 7.6, 8.3, 9.0, 10.4, 11.9, 13.4; ...
                                        NaN, NaN, 2.9, 4.2, 5.6, 7.2, 8.9, 9.8, 10.7, 12.5, 14.5, 16.4; ...
                                        NaN, NaN, 2.7, 4.0, 5.4, 7.0, 8.8, 9.7, 10.6, 12.6, 14.8, 16.9; ...
                                        NaN, NaN, 1.9, 3.1, 4.7, 6.4, 8.4, 9.3, 10.4, 12.6, 14.9, 17.3; ...
                                        NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN; ...
                                        ]*100/1000; % from (1)
IonicConductivityMatrix_LiPF6_60_EC_40_EMC = [  NaN, NaN, NaN, NaN, NaN, NaN, 7.4, 8.1, 8.8, 10.3, 11.8, 13.3; ...
                                        NaN, NaN, NaN, NaN, 5.4, 7.0, 8.8, 9.7, 10.6, 12.5, 14.5, 16.5; ...
                                        NaN, NaN, NaN, 3.5, 5.1, 6.8, 8.6, 9.5, 10.5, 12.6, 14.8, 17.0; ...
                                        NaN, NaN, NaN, 2.9, 4.3, 6.2, 8.2, 9.2, 10.2, 12.5, 15.0, 17.5; ...
                                        NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN; ...
                                        ]*100/1000; % from (1)
                                    
IonicConductivityMatrix_MJ1 = [ 5.1, 5.6, 2.3, 0.25;...
    8.5, 11, 7, 2.6;...
    11.5, 15.5, 11.6, 5.7;...
    14.3, 20.1, 17.4, 9.6]*100/1000; % from (10.1149/1.1872737)

IonicConductivityMatrix_Kokam = [ 7.4, 7.75, 8.0;...
    8.55, 9, 9.3;...
    8.75, 9.25, 9.7;...
    8.55, 9.05, 9.4;...
    7.8, 8.4, 8.6]*100/1000; % from (10.1149/2.0551509jes)


%% 1M LiPF6 / 10 vol% PC, 27 vol% EC, 63 vol% DMC
Name = 'Electrolyte_1M_LiPF6_10_PC_27_EC_63_DMC';
ConductiveSalt = ConductiveSalts.Lithium_hexafluorophosphate;
ConductiveSaltMolarity = 1;
SolventsUsed = [Solvents.PropyleneCarbonate, Solvents.EthyleneCarbonate, Solvents.DimethylCarbonate];
SolventVolumeFractions = [0.1, 0.27, 0.63];
TemperatureVector = TemperatureVector_MJ1;
ConductiveSaltMolarityVector = ConductiveSaltMolarityVector_MJ1;
IonicConductivityMatrix = IonicConductivityMatrix_MJ1;
ICM.TemperatureVector = TemperatureVector;
ICM.ConductiveSaltMolarityVector = ConductiveSaltMolarityVector;
ICM.IonicConductivityMatrix=IonicConductivityMatrix;
obj = Electrolyte(Name, ConductiveSalt, ConductiveSaltMolarity, SolventsUsed, SolventVolumeFractions, ICM);
obj = SetProperty(obj, 'Source', '10.1149/1.1872737');
obj = SetProperty(obj, 'Confidential', 'no');
AddInfo.ShortName = 'MJ1';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Electrolytes.(Name) = obj;

%% 1M LiPF6 / 50 vol% EC, 50 vol% EMC LP30 
Name = 'Electrolyte_LP50';
ConductiveSalt = ConductiveSalts.Lithium_hexafluorophosphate;
ConductiveSaltMolarity = 1;
SolventsUsed = [Solvents.EthyleneCarbonate, Solvents.EthylMethylCarbonate];
SolventVolumeFractions = [0.433, 0.567];
TemperatureVector = TemperatureVector_Kokam;
ConductiveSaltMolarityVector = ConductiveSaltMolarityVector_Kokam;
IonicConductivityMatrix = IonicConductivityMatrix_Kokam;
ICM.TemperatureVector = TemperatureVector;
ICM.ConductiveSaltMolarityVector = ConductiveSaltMolarityVector;
ICM.IonicConductivityMatrix=IonicConductivityMatrix;
obj = Electrolyte(Name, ConductiveSalt, ConductiveSaltMolarity, SolventsUsed, SolventVolumeFractions, ICM);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'no');
AddInfo.ShortName = 'LP30';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Electrolytes.(Name) = obj;

%%Save elements
outputStruct = Electrolytes;
folder = 'Databases\icpd_publication_data\Electrolytes\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\Electrolytes\Electrolytes.mat', 'Electrolytes');
clear all
close all