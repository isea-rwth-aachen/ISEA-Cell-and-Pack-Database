clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');

%% Literature
% (1) BatPaC
% (2) http://www.chemie.de/lexikon/Polyvinylidenfluorid.html
% (3) https://holscot.com/glossary/pvdf/; Abruf 16.10.2019

Binders= [];

Name = 'PVdF';
Elements = [PeriodicTable.carbon, PeriodicTable.hydrogen, PeriodicTable.fluorine];
MolarFractions = [2, 2, 2];
obj = Binder(Name, Elements, MolarFractions);
obj = SetProperty(obj, 'Abbreviation', 'PVdF');
AddInfo.ShortName = 'PVdF';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'Density', 1.77); % from (2)
obj = SetProperty(obj, 'ElectricalConductivity', 1e-9); % is known to be an isolator
obj = SetProperty(obj, 'Confidential', 'No');
obj = SetProperty(obj, 'Source', 'https://holscot.com/glossary/pvdf/');
Binders.(Name) = obj;

%%Save elements
outputStruct = Binders;
folder = 'Databases\icpd_publication_data\Binders\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end
save('Databases\icpd_publication_data\Binders\Binders.mat', 'Binders');
clear all
close all