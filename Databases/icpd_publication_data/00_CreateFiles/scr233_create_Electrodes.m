clear all
close all

load('Databases\icpd_publication_data\CurrentCollectors\CurrentCollectorAluminum_MJ1.mat');
load('Databases\icpd_publication_data\CurrentCollectors\CurrentCollectorCopper_MJ1.mat');
load('Databases\icpd_publication_data\CurrentCollectors\CurrentCollectorAluminum_Kokam.mat');
load('Databases\icpd_publication_data\CurrentCollectors\CurrentCollectorCopper_Kokam.mat');
load('Databases\icpd_publication_data\Coatings\Coating_SiC6.mat');
load('Databases\icpd_publication_data\Coatings\Coating_NMC811.mat');
load('Databases\icpd_publication_data\Coatings\Coating_C6_Kokam.mat');
load('Databases\icpd_publication_data\Coatings\Coating_NCO.mat');
load('Databases\icpd_publication_data\Coatings\Coating_C6_Kokam2.mat');
load('Databases\icpd_publication_data\Coatings\Coating_NCO2.mat');

%% Literature/Sources

Electrodes = [];

%% Standard Technologies
%% Anodes

% Electrode_Anode_MJ1
Name = 'Electrode_Anode_MJ1';
CurrentCollector = CurrentCollectorCopper_MJ1;
Coating = Coating_SiC6;
CoatingDimensions = [615,  58, 86.7*1e-3; 615,  58, 86.7*1e-3]; % Breite, Höhe, Tiefe
Porosity = 0.216;
obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
Electrodes.(Name) = obj;

% Electrode_Anode_Kokam
Name = 'Electrode_Anode_Kokam';
CurrentCollector = CurrentCollectorCopper_Kokam;
Coating = Coating_C6_Kokam;
CoatingDimensions = [103,  87, 73.65*1e-3; 103,  87, 73.65*1e-3]; % Breite, Höhe, Tiefe
Porosity = 0.329;
obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Electrodes.(Name) = obj;

% Electrode_Anode_Kokam2
Name = 'Electrode_Anode_Kokam2';
CurrentCollector = CurrentCollectorCopper_Kokam;
Coating = Coating_C6_Kokam2;
CoatingDimensions = [102,  86, 71.8*1e-3; 102,  86, 71.8*1e-3]; % Breite, Höhe, Tiefe
Porosity = 0.329;
obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Electrodes.(Name) = obj;

%% Cathodes

% Electrode_Cathode_MJ1
Name = 'Electrode_Cathode_MJ1';
CurrentCollector = CurrentCollectorAluminum_MJ1;
Coating = Coating_NMC811;
CoatingDimensions = [615,  58, 66.2*1e-3; 615,  58, 66.2*1e-3]; % Breite, Höhe, Tiefe
Porosity = 0.171;
obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
Electrodes.(Name) = obj;

% Electrode_Cathode_Kokam
Name = 'Electrode_Cathode_Kokam';
CurrentCollector = CurrentCollectorAluminum_Kokam;
Coating = Coating_NCO;
CoatingDimensions = [101,  85, 54.45*1e-3; 101,  85, 54.45*1e-3]; % Breite, Höhe, Tiefe
Porosity = 0.296;
obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Electrodes.(Name) = obj;

% Electrode_Cathode_Kokam2
Name = 'Electrode_Cathode_Kokam2';
CurrentCollector = CurrentCollectorAluminum_Kokam;
Coating = Coating_NCO2;
CoatingDimensions = [100,  84, 46.9*1e-3; 100,  84, 46.9*1e-3]; % Breite, Höhe, Tiefe
Porosity = 0.296;
obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Electrodes.(Name) = obj;

%% Save elements
outputStruct = Electrodes;
folder = 'Databases\icpd_publication_data\Electrodes\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end
clear all
close all