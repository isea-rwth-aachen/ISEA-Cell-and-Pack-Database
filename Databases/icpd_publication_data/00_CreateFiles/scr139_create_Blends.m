clear all
close all

load('Databases\icpd_publication_data\ActiveMaterials\Graphite.mat');
load('Databases\icpd_publication_data\ActiveMaterials\Si.mat');

Blends = [];

%%%%%%%%%
%% C6 + Si Blends
%%%%%%%%

%% Si005_C6.
Name = 'Si0035_C6';
ActiveMaterials = [Si, Graphite];
AMsWeightFractions = [0.035, 0.965];
obj = Blend(Name, ActiveMaterials, AMsWeightFractions);
obj = SetProperty(obj, 'Source', 'sbi');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Si 3.5 wt% + C6 96.5 wt%';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'Abbreviation', 'Si0035_C6');
Blends.(Name)=obj;

%% Save elements
outputStruct = Blends;
folder = 'Databases\icpd_publication_data\Blends\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\Blends\Blends.mat', 'Blends');
clear all
close all