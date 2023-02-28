clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');
load('Databases\icpd_publication_data\Substances\Substances.mat');

%% Literature/Sources
% (1) BatPaC
% (2) R. E. Gerver: Three-Dimensional Modeling of Electrochemical Performance and Heat Generation of Lithium-Ion Batteries in Tabbed Planar Configurations

Separators = [];

%% Others

%% Test Sep
Name = 'Separator_MJ1';
Materials = [Substances.Polyethylene, Substances.Polypropylene];
WeightFractions = [0.5, 0.5];
Dimensions = [615,  58, 12*1e-3];
Porosity = 0.45;
obj = Separator(Name, Materials, WeightFractions, Dimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
Separators.(Name) = obj;

%% Test Sep
Name = 'Separator_Kokam';
Materials = [Substances.Polyethylene, Substances.Polypropylene];
WeightFractions = [0.5, 0.5];
Dimensions = [105,  89, 19*1e-3];
Porosity = 0.50;
obj = Separator(Name, Materials, WeightFractions, Dimensions, Porosity);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Separators.(Name) = obj;

%%Save elements
outputStruct = Separators;
folder = 'Databases\icpd_publication_data\Separators\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end
clear all
close all