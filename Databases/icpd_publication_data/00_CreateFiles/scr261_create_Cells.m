clear all
close all

Cells = [];

%% literature and sources
load('Databases\icpd_publication_data\ElectrodeStacks\ElectrodeStack_MJ1.mat');
load('Databases\icpd_publication_data\Housings\HousingCylindrical_18650.mat');

load('Databases\icpd_publication_data\ElectrodeStacks\ElectrodeStack_Kokam.mat');
load('Databases\icpd_publication_data\Housings\HousingPouch_Kokam7_5Ah.mat');

load('Databases\icpd_publication_data\ElectrodeStacks\ElectrodeStack_Kokam2.mat');

%% cells
Name = 'Cell_MJ1';
ElectrodeStack = ElectrodeStack_MJ1;
Housing = HousingCylindrical_18650;
obj = Cell(Name, ElectrodeStack, Housing);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
Cells.(Name) = obj;

save('Databases\icpd_publication_data\Cells_Std\Cells_Std.mat', 'Cells');

Name = 'Cell_Kokam7_5Ah';
ElectrodeStack = ElectrodeStack_Kokam;
Housing = HousingPouch_Kokam7_5Ah;
obj = Cell(Name, ElectrodeStack, Housing);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Cells.(Name) = obj;

Name = 'Cell_Kokam7_5Ahv2';
ElectrodeStack = ElectrodeStack_Kokam2;
Housing = HousingPouch_Kokam7_5Ah;
obj = Cell(Name, ElectrodeStack, Housing);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Cells.(Name) = obj;

%% Save elements
outputStruct = Cells;
folder = 'Databases\icpd_publication_data\Cells\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end
clear all
close all