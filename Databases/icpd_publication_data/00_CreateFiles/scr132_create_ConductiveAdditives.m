clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');

%% Literature
% (1) BatPaC
% (2) paper: Carbon black vs. black carbon and other airborne materials containing elemental carbon: Physical and chemical distinctions
% (3) paper: Electrical conductivity of conductive carbon blacks: influence of surface chemistry and topology
% (4) Bertrand Maquin: Thermal conductivity of submicrometre particles: carbon blacks and solid solutions containing C, B and N

ConductiveAdditives = [];

Name = 'CarbonBlack';
Elements = [PeriodicTable.carbon];
MolarFractions = [6];
obj = ConductiveAdditive(Name, Elements, MolarFractions);
obj = SetProperty(obj, 'Abbreviation', 'Carbon Black');
AddInfo.ShortName = 'CB - C_6';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'Density', 1.83); % from (2)
obj = SetProperty(obj, 'ElectricalConductivity', 4.5*100); % in S/m from (3)
obj = SetProperty(obj, 'Confidential', 'No');
obj = SetProperty(obj, 'Source', '');
ConductiveAdditives.(Name) = obj;

%%Save elements
outputStruct = ConductiveAdditives;
folder = 'Databases\icpd_publication_data\ConductiveAdditives\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\ConductiveAdditives\ConductiveAdditives.mat', 'ConductiveAdditives');
clear all
close all
