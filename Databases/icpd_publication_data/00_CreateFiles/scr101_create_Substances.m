clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');

Substances = [];

%% Polyethylene (PE-HD) 
Name = 'Polyethylene'; %Abbreviation: 'PE'
Materials = [PeriodicTable.carbon, PeriodicTable.hydrogen];
MolarFractions = [2, 4];
Density = 0.94; 
obj = Substance(Name, Materials, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'PE');
AddInfo.ShortName = 'C_2H_4';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'MeltingPoint', 115); %Heat Retention Resistance, Alternatively -> MeltingPoint: 115-135
obj = SetProperty(obj, 'Confidential', 'No');
obj = SetProperty(obj, 'Source', 'https://www.kunststoffe.de/themen/basics/standardthermoplaste/polyethylen-pe/artikel/polyethylen-pe-644757');
Substances.(Name) = obj;

%% Polypropylene  
Name = 'Polypropylene'; %Abbreviation:'PP'
Materials = [PeriodicTable.carbon, PeriodicTable.hydrogen];
MolarFractions = [3,6];
Density = 0.905;
obj = Substance(Name, Materials, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'PP');
AddInfo.ShortName = 'C_3H_6';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'MeltingPoint', 100);  %Heat Retention Resistance (@ 1.8 MPa), Alternatively -> MeltingPoint: 146
obj = SetProperty(obj, 'Confidential', 'No');
obj = SetProperty(obj, 'Source', 'bpf.co.uk/plastipedia/polymers/pp.aspx');
Substances.(Name) = obj;

%% 304 Stainless Steel
Name = 'StainlessSteel'; % 66.5-74% iron, 18-20% chromium, 8-10% nickel, up to 2% manganese, (silicon,nitrogen,carbon) 
Materials = [PeriodicTable.iron ,PeriodicTable.chromium,PeriodicTable.nickel];
MolarFractions = [7.357,2.258,1]; %NO CORRECT INFORMATION, here only for error correction
Density = 7.8;
obj = Substance(Name, Materials, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'Stainless Steel');
AddInfo.ShortName = 'Stainless Steel';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'MeltingPoint' , 1450); %maximum Temperatur (Mechanical): 710°C
obj = SetProperty(obj, 'Source', 'makeitfrom.com/material-properties/1-8-Hard-304-Stainless-Steel');
Substances.(Name) = obj;

%% Save substances
outputStruct = Substances;
folder = 'Databases\icpd_publication_data\Substances\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\Substances\Substances.mat', 'Substances');
clear all
close all
