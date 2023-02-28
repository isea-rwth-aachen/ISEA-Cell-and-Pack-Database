clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');
load('Databases\icpd_publication_data\OCV\NMC811.mat');
load('Databases\icpd_publication_data\OCV\Si.mat');
load('Databases\icpd_publication_data\OCV\Graphite.mat');
load('Databases\icpd_publication_data\OCV\Graphite_Kokam.mat');
load('Databases\icpd_publication_data\OCV\NCO.mat');

load('Databases\icpd_publication_data\00_InputData\ActiveMaterials\MaterialPropsFromLit\MaterialPropertiesFromLiterature.mat')

ActiveMaterials = [];

%% Cathodes
%% NMC811

AM_Name='NMC811';
TransferMaterial = PeriodicTable.lithium;
Elements = [PeriodicTable.nickel, PeriodicTable.manganese, PeriodicTable.cobalt, PeriodicTable.oxygen];
MolarFractions = [0.8, 0.1, 0.1, 2.0];
%from https://materialsproject.org/materials/mp-25424/
%from https://materialsproject.org/materials/mp-25373/
%from https://materialsproject.org/materials/mp-25210/
%from https://materialsproject.org/materials/mp-25411/
%from https://materialsproject.org/materials/mp-25234/
%from https://materialsproject.org/materials/mp-22526/
VolumeIncrease = 0.8 * 0.07 + 0.1 * 0.09 + 0.1 * 0; %
x_used = [0.0, 1.0]; % from Balancing-Fit
Density = 0.8 * 4.63 + 0.1 * 4.09 + 0.1 * 4.55; %from
obj = ActiveMaterial(AM_Name, TransferMaterial, Elements, MolarFractions, NMC811, [], PeriodicTable.lithium, x_used, Density);
obj = obj.SetUseRange([0.0, 1.0]);
obj = obj.SetVoltageLimits([0, 5]);
obj = SetProperty(obj, 'RelVolumeIncreaseOnLith', VolumeIncrease);
obj = SetProperty(obj, 'Abbreviation', 'NMC811');
AddInfo.ShortName = 'Li_xNi_{0.8}Mn_{0.1}Co_{0.1}O_2';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'Confidential', 'No');
obj = SetProperty(obj, 'Source', 'https://materialsproject.org/materials');
ActiveMaterials.(AM_Name)=obj;

%% NCO

AM_Name='NCO';
TransferMaterial = PeriodicTable.lithium;
Elements = [PeriodicTable.nickel, PeriodicTable.cobalt, PeriodicTable.oxygen];
MolarFractions = [0.4, 0.6, 2.0];
%from https://materialsproject.org/materials/mp-25424/
%from https://materialsproject.org/materials/mp-25373/
%from https://materialsproject.org/materials/mp-25210/
%from https://materialsproject.org/materials/mp-25411/
%from https://materialsproject.org/materials/mp-25234/
%from https://materialsproject.org/materials/mp-22526/
VolumeIncrease = 0.4 * 0.07 +  0.6 * 0; %
x_used = [0.0, 1.0]; % from Balancing-Fit
Density = 0.4 * 4.63 + 0.6 * 4.55; %from
obj = ActiveMaterial(AM_Name, TransferMaterial, Elements, MolarFractions, NCO, [], PeriodicTable.lithium, x_used, Density);
obj = obj.SetUseRange([0.0, 1.0]);
obj = obj.SetVoltageLimits([0, 5]);
obj = SetProperty(obj, 'RelVolumeIncreaseOnLith', VolumeIncrease);
obj = SetProperty(obj, 'Abbreviation', 'NCO');
AddInfo.ShortName = 'Li_xNi_{0.4}Co_{0.6}O_2';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'Confidential', 'No');
obj = SetProperty(obj, 'Source', 'https://materialsproject.org/materials');
ActiveMaterials.(AM_Name)=obj;

%% Anodes
%% Graphite
Name='Graphite';
TransferMaterial = PeriodicTable.lithium;
Elements = PeriodicTable.carbon;
MolarFractions = 6.0;
x_used = [0.0, 1.0]; % from Balancing-Fit

Density = Density_C6;
ElecCond = ElecCond_C6;
Expansion = Expansion_C6;
obj = ActiveMaterial(Name, TransferMaterial, Elements, MolarFractions, Graphite, [], PeriodicTable.lithium, x_used, Density);
obj = obj.SetUseRange([0.0, 1.0]);
obj = SetProperty(obj, 'RelVolumeIncreaseOnLith', Expansion);
obj = SetProperty(obj, 'Abbreviation', 'C6');
AddInfo.ShortName = 'C_6';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'ElectricalConductivity', ElecCond);
obj = SetProperty(obj, 'Source', '');
obj = SetProperty(obj, 'Confidential', 'No');
ActiveMaterials.(Name)=obj;

%% Graphite_Kokam
Name='Graphite_Kokam';
TransferMaterial = PeriodicTable.lithium;
Elements = PeriodicTable.carbon;
MolarFractions = 6.0;
x_used = [0.0, 1.0]; % from Balancing-Fit

Density = Density_C6;
ElecCond = ElecCond_C6;
Expansion = Expansion_C6;
obj = ActiveMaterial(Name, TransferMaterial, Elements, MolarFractions, Graphite_Kokam, [], PeriodicTable.lithium, x_used, Density);
obj = obj.SetUseRange([0.0, 1.0]);
obj = SetProperty(obj, 'RelVolumeIncreaseOnLith', Expansion);
obj = SetProperty(obj, 'Abbreviation', 'C6');
AddInfo.ShortName = 'C_6';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'ElectricalConductivity', ElecCond);
obj = SetProperty(obj, 'Source', '');
obj = SetProperty(obj, 'Confidential', 'No');
ActiveMaterials.(Name)=obj;

%% Si 
Name = 'Si';
TransferMaterial = PeriodicTable.lithium;
Elements = PeriodicTable.silicon;
MolarFractions = 1;
x_used = [0, 1]; % from Balancig-Fit
Density = Density_Si;
ElecCond = ElecCond_Si;
Expansion = 2.89/4.2; 
obj = ActiveMaterial(Name, TransferMaterial, Elements, MolarFractions, Si, [], PeriodicTable.lithium, x_used, Density);
obj = obj.SetUseRange([0.0, 1.0]);
obj = SetProperty(obj, 'RelVolumeIncreaseOnLith', Expansion);
obj = SetProperty(obj, 'Abbreviation', 'Si');
AddInfo.ShortName = 'Si';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'ElectricalConductivity', ElecCond);
obj = SetProperty(obj, 'Source', 'https://materialsproject.org/batteries/mp-30000000453/');
obj = SetProperty(obj, 'Confidential', 'No');
ActiveMaterials.(Name)=obj;

%% Save elements
outputStruct = ActiveMaterials;
folder = 'Databases\icpd_publication_data\ActiveMaterials\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end
save('Databases\icpd_publication_data\ActiveMaterials\ActiveMaterials.mat', 'ActiveMaterials');

clear all
close all