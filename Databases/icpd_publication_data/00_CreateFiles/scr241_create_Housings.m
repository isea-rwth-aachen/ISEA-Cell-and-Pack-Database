clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');
load('Databases\icpd_publication_data\Substances\Substances.mat');

%% Literature
% (1) MA awa-mma
% (2) MA mku-dly
% (3) HiWi mku-pkr
% (4) J. B. Quinn: Energy Density of Cylindrical Li-Ion Cells: A Comparison of Commercial 18650 to the 21700 Cells

Housings = [];

%% Tesla Model S Panasonic 3.25Ah
Name = 'HousingCylindrical_18650';
% Material = PeriodicTable.aluminum;
Material = Substances.StainlessSteel;
Dimensions = [18/2, 65]; % radius, height
WallThickness = 0.25;  % from (1)
RestrictionsOfInnerDimensions = [0, 0.5, 0, 3.3]; % [delta radius outside, delta radius inside, bottom, top]
MaterialPosPole = PeriodicTable.aluminum;
SizeOfPosPole = [10/2, 0.5];
MaterialNegPole = PeriodicTable.aluminum;
SizeOfNegPole = [9.5/2, 0.3];
AdditionalMaterials = {PeriodicTable.aluminum};
AdditionalMaterialWeights = [0.8];
obj = HousingCylindrical(Name, Material, Dimensions, WallThickness, RestrictionsOfInnerDimensions, MaterialPosPole, SizeOfPosPole, MaterialNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'MKu');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = '18650';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% 21700 from (4)
Name = 'HousingCylindrical_21700'; % from (4)
% Material = PeriodicTable.aluminum;
Material = Substances.StainlessSteel;
Dimensions = [21/2, 70]; % radius, height
WallThickness = 0.2;
RestrictionsOfInnerDimensions = [0, 0.5, 0, 5]; % [delta radius outside, delta radius inside, bottom, top]
MaterialPosPole = PeriodicTable.aluminum;
SizeOfPosPole = [11/2, 0.5];
MaterialNegPole = PeriodicTable.aluminum;
SizeOfNegPole = [11/2, 0.3];
AdditionalMaterials = {};
AdditionalMaterialWeights = [];
obj = HousingCylindrical(Name, Material, Dimensions, WallThickness, RestrictionsOfInnerDimensions, MaterialPosPole, SizeOfPosPole, MaterialNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'MKu');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = '21700';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Kokam 7.5Ah
Name = 'HousingPouch_Kokam7_5Ah';
FoilMaterials = {Substances.Polypropylene, PeriodicTable.aluminum};
FoilThicknesses = [0.076, 0.075]; % from (1)
Dimensions = [118,  97, 8;]; % from (3)
RestrictionsOfInnerDimensions = [5, 5, 5, 10, 0, 0]; % [left, right, bottom, top, front, back]
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [0, 0];
SizeOfPosPole = [0, 0, 0];
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [0, 0];
SizeOfNegPole = [0, 0, 0];
AdditionalMaterials = {};
AdditionalMaterialWeights = []; % extention of the two poles into the cell (they have a larger width than the poles themselves)
obj = HousingPouch(Name, FoilMaterials, FoilThicknesses, Dimensions, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Pouch_S';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Housing Pouch Small
Name = 'HousingPouchS';
FoilMaterials = {Substances.Polypropylene, PeriodicTable.aluminum};
FoilThicknesses = [0.076, 0.075]; % from (1)
Dimensions = [118,  97, 8;]; % from (3)
RestrictionsOfInnerDimensions = [5, 5, 5, 10, 0, 0]; % [left, right, bottom, top, front, back]
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [0, 0];
SizeOfPosPole = [0, 0, 0];
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [0, 0];
SizeOfNegPole = [0, 0, 0];
AdditionalMaterials = {};
AdditionalMaterialWeights = []; % extention of the two poles into the cell (they have a larger width than the poles themselves)
obj = HousingPouch(Name, FoilMaterials, FoilThicknesses, Dimensions, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Pouch_S';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Housing Pouch Medium
Name = 'HousingPouchM';
FoilMaterials = {Substances.Polypropylene, PeriodicTable.aluminum};
FoilThicknesses = [0.076, 0.075]; % from (1)
Dimensions = [218,  263, 7]; % from (3)
RestrictionsOfInnerDimensions = [8.5, 7, 12.5, 21, 0, 0]; % [left, right, bottom, top, front, back]
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [166, 3.5];
SizeOfPosPole = [4, 20, 0.5];
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [93, 3.5];
SizeOfNegPole = [4, 20, 0.5];
AdditionalMaterials = {PeriodicTable.aluminum};
AdditionalMaterialWeights = [2*70*20*0.5*1e-3*PeriodicTable.aluminum.Density]; % extention of the two poles into the cell (they have a larger width than the poles themselves)
obj = HousingPouch(Name, FoilMaterials, FoilThicknesses, Dimensions, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'ISEA');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Pouch_M';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Housing Pouch Large
Name = 'HousingPouchL';
FoilMaterials = {Substances.Polypropylene, PeriodicTable.aluminum};
FoilThicknesses = [0.1, 0.1]; % from (3)
Dimensions = [326,  159, 12.5]; % from (3)
RestrictionsOfInnerDimensions = [9, 7.68, 4.68, 16, 0, 0]; % [left, right, bottom, top, front, back]
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [245.5, 6];
SizeOfPosPole = [105, 8, 0.5];
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [80.5, 6];
SizeOfNegPole = [105, 8, 0.5];
AdditionalMaterials = {PeriodicTable.aluminum};
AdditionalMaterialWeights = [2*105*16*0.5*1e-3*PeriodicTable.aluminum.Density]; % extention of the two poles into the cell
obj = HousingPouch(Name, FoilMaterials, FoilThicknesses, Dimensions, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'ISEA');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Pouch_L';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Housing Prismatic Small
Name = 'HousingPrismaticS';
Material = PeriodicTable.aluminum;
Dimensions = [61.8,  93.8, 12.7]; % width, height, depth
WallThickness = 0.65;
RestrictionsOfInnerDimensions = [0, 0, 0, 9.5, 0, 0]; % [left, right, bottom, top, front, back]
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [52, 6.3];
SizeOfPosPole = [7, 3.5, 7.1];
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [9, 6.3]; 
SizeOfNegPole = [7, 3.5, 7.1];
AdditionalMaterials = {Substances.Polypropylene};
AdditionalMaterialWeights = [2*0.8+0.2]; % additional plastic elements
obj = HousingPrismatic(Name, Material, Dimensions, WallThickness, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'MKu');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Prismatic_S';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Housing Prismatic Medium
Name = 'HousingPrismaticM';
Material = PeriodicTable.aluminum;
Dimensions = [115,  103.2, 23.0]; % width, height, depth
WallThickness = 0.7; % from (2)
% WallThickness = 0.8; % from (3)
RestrictionsOfInnerDimensions = [8+0.8, 8+0.8, 1, 4.5-0.7, 0, 0]; % [left, right, bottom, top, front, back]; 4.5mm measurement included wall thickness 
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [98, 11.5]; 
SizeOfPosPole = [15, 2, 10]; % from (2) and (3)
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [24.5, 11.5];
SizeOfNegPole = [15, 2, 10]; % from (2) and (3)
AdditionalMaterials = {Substances.Polypropylene, PeriodicTable.aluminum};
AdditionalMaterialWeights = [2*3.6 + ((34*21 + 49*21) - 2 * 15*10)*2*1e-3*Substances.Polypropylene.Density, 4*1.6]; % additional plastic elements (plastic around the poles is calculated via volume and density of polypropylene) and connectors within the cell
obj = HousingPrismatic(Name, Material, Dimensions, WallThickness, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'ISEA');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Prismatic_M';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Housing Prismatic Large
Name = 'HousingPrismaticL';
Material = Substances.StainlessSteel;
Dimensions = [172, 126, 45]; % width, height, depth
WallThickness = 0.61;
RestrictionsOfInnerDimensions = [12, 10, 0, 4, 0, 0]; % [left, right, bottom, top, front, back]
MaterialPosPole = PeriodicTable.aluminum;
PositionOfPosPole = [152, 22.5];
SizeOfPosPole = [24, 8, 18];
MaterialNegPole = PeriodicTable.aluminum;
PositionOfNegPole = [20, 22.5];
SizeOfNegPole = [24, 8, 18];
AdditionalMaterials = {};
AdditionalMaterialWeights = [];
obj = HousingPrismatic(Name, Material, Dimensions, WallThickness, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights);
obj = SetProperty(obj, 'Source', 'ISEA');
obj = SetProperty(obj, 'Confidential', 'No');
AddInfo.ShortName = 'Prismatic_L';
obj = SetProperty(obj, 'AddInfo', AddInfo);
Housings.(Name) = obj;

%% Save elements
outputStruct = Housings;
folder = 'Databases\icpd_publication_data\Housings\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\Housings\Housings.mat', 'Housings');
clear all
close all