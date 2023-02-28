clear all
close all

load('Databases\icpd_publication_data\Electrodes\Electrode_Cathode_MJ1.mat');
load('Databases\icpd_publication_data\Electrodes\Electrode_Anode_MJ1.mat');
load('Databases\icpd_publication_data\Separators\Separator_MJ1.mat');
load('Databases\icpd_publication_data\Electrolytes\Electrolyte_1M_LiPF6_10_PC_27_EC_63_DMC.mat');

load('Databases\icpd_publication_data\Electrodes\Electrode_Cathode_Kokam.mat');
load('Databases\icpd_publication_data\Electrodes\Electrode_Anode_Kokam.mat');
load('Databases\icpd_publication_data\Separators\Separator_Kokam.mat');
load('Databases\icpd_publication_data\Electrolytes\Electrolyte_LP50.mat');

load('Databases\icpd_publication_data\Electrodes\Electrode_Cathode_Kokam2.mat');
load('Databases\icpd_publication_data\Electrodes\Electrode_Anode_Kokam2.mat');

ElectrodeStacks = [];

%% Std
Name = 'ElectrodeStack_MJ1';
Anode = Electrode_Anode_MJ1;
NrOfAnodes = 1;
Cathode = Electrode_Cathode_MJ1;
NrOfCathodes = 1;
Separator = Separator_MJ1;
NrOfSeparators = 2;
Electrolyte = Electrolyte_1M_LiPF6_10_PC_27_EC_63_DMC;
InitialOccupancyRanges = [0, 1];
obj = ElectrodeStack(Name, Anode, NrOfAnodes, Cathode, NrOfCathodes, Separator, NrOfSeparators, Electrolyte, InitialOccupancyRanges);
obj = obj.SetVoltageRange([2.5, 4.2], true);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
ElectrodeStacks.(Name) = obj;

Name = 'ElectrodeStack_Kokam';
Anode = Electrode_Anode_Kokam;
NrOfAnodes = 24;
Cathode = Electrode_Cathode_Kokam;
NrOfCathodes = 25;
Separator = Separator_Kokam;
NrOfSeparators = 50;
Electrolyte = Electrolyte_LP50;
InitialOccupancyRanges = [0, 1];
obj = ElectrodeStack(Name, Anode, NrOfAnodes, Cathode, NrOfCathodes, Separator, NrOfSeparators, Electrolyte, InitialOccupancyRanges);
obj = obj.SetVoltageRange([2.85, 4.15], true);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
ElectrodeStacks.(Name) = obj;

Name = 'ElectrodeStack_Kokam2';
Anode = Electrode_Anode_Kokam2;
NrOfAnodes = 23;
Cathode = Electrode_Cathode_Kokam2;
NrOfCathodes = 24;
Separator = Separator_Kokam;
NrOfSeparators = 50;
Electrolyte = Electrolyte_LP50;
InitialOccupancyRanges = [0, 1];
obj = ElectrodeStack(Name, Anode, NrOfAnodes, Cathode, NrOfCathodes, Separator, NrOfSeparators, Electrolyte, InitialOccupancyRanges);
obj = obj.SetVoltageRange([2.85, 4.15], true);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
ElectrodeStacks.(Name) = obj;

%% Save elements
outputStruct = ElectrodeStacks;
folder = 'Databases\icpd_publication_data\ElectrodeStacks\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\ElectrodeStacks\ElectrodeStacks.mat', 'ElectrodeStacks');
clear all
close all