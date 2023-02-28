clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');
load('Databases\icpd_publication_data\Substances\Substances.mat');

%% Literature/Sources
% (1) BatPaC

CurrentCollectors = [];

%% Others
Name = 'CurrentCollectorCopper_MJ1';
Material = PeriodicTable.copper;
CurrentCollectorDimensions = [615,  58, 11*1e-3]; % in mm; (length/width, height, thickness/depth)
CurrentCollectorTabDimensions = [0, 0, 11*1e-3]; % in mm; (length/width, height, thickness/depth)
obj = CurrentCollector(Name, Material, CurrentCollectorDimensions, CurrentCollectorTabDimensions);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
CurrentCollectors.(Name)=obj;

Name = 'CurrentCollectorAluminum_MJ1';
Material = PeriodicTable.aluminum;
CurrentCollectorDimensions = [615,  58, 17.3*1e-3]; % in mm; (length/width, height, thickness/depth)
CurrentCollectorTabDimensions = [0, 0, 17.3*1e-3]; % in mm; (length/width, height, thickness/depth)
obj = CurrentCollector(Name, Material, CurrentCollectorDimensions, CurrentCollectorTabDimensions);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
CurrentCollectors.(Name)=obj;

Name = 'CurrentCollectorCopper_Kokam';
Material = PeriodicTable.copper;
CurrentCollectorDimensions = [103,  87, 14.7*1e-3]; % in mm; (length/width, height, thickness/depth)
CurrentCollectorTabDimensions = [20, 10, 14.7*1e-3]; % in mm; (length/width, height, thickness/depth)
obj = CurrentCollector(Name, Material, CurrentCollectorDimensions, CurrentCollectorTabDimensions);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
CurrentCollectors.(Name)=obj;

Name = 'CurrentCollectorAluminum_Kokam';
Material = PeriodicTable.aluminum;
CurrentCollectorDimensions = [101, 85, 15.1*1e-3]; % in mm; (length/width, height, thickness/depth)
CurrentCollectorTabDimensions = [20, 10, 15.1*1e-3]; % in mm; (length/width, height, thickness/depth)
obj = CurrentCollector(Name, Material, CurrentCollectorDimensions, CurrentCollectorTabDimensions);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
CurrentCollectors.(Name)=obj;
%%Save elements
outputStruct = CurrentCollectors;
folder = 'Databases\icpd_publication_data\CurrentCollectors\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\CurrentCollectors\CurrentCollectors.mat', 'CurrentCollectors');
clear all
close all