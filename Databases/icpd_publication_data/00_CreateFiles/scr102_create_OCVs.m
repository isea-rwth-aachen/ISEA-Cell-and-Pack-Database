clear all
close all

MatFolder = 'Databases\icpd_publication_data\00_InputData\ActiveMaterials\OCVs';
load([MatFolder '\MaterialData.mat'])
load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');

materials = MaterialData{:, 1};
OCVs = [];
OCV_input = [];

for i = 1 : numel(materials)
    disp([materials{i} ' creation started']);
    OCV_input.([materials{i} '_Lith'])=load([MatFolder '\' materials{i} '\'  materials{i} '_OCV_Lith.mat']);
    OCV_input.([materials{i} '_DeLith'])=load([MatFolder '\' materials{i} '\'  materials{i} '_OCV_DeLith.mat']);
    OCV_Name=[materials{i} ''];
    obj = OCV(OCV_Name, OCV_input.([materials{i} '_DeLith']).ocv, OCV_input.([materials{i} '_DeLith']).x_Li, OCV_input.([materials{i} '_Lith']).ocv, OCV_input.([materials{i} '_Lith']).x_Li);
    obj = SetProperty(obj, 'Confidential', 'No');
    OCVs.(OCV_Name)=obj;
end

%% Save OCVs
outputStruct = OCVs;
folder = 'Databases\icpd_publication_data\OCV\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

clear all
close all