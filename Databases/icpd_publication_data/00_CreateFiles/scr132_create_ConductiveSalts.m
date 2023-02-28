clear all
close all

load('Databases\icpd_publication_data\Elements\PeriodicTable.mat');

ConductiveSalts = [];

%% lithiumhexafluorophosphate
Name = 'Lithium_hexafluorophosphate';
TransferMaterial = PeriodicTable.lithium;
Elements = [PeriodicTable.phosphorus, PeriodicTable.fluorine];
MolarFractions = [1, 6];
Density = 1.5;
obj = ConductiveSalt(Name, TransferMaterial, Elements, MolarFractions, Density);
obj = SetProperty(obj, 'Abbreviation', 'LiPF6');
AddInfo.ShortName = 'LiPF_6';
obj = SetProperty(obj, 'AddInfo', AddInfo);
obj = SetProperty(obj, 'Source', 'M. Ue, Y. Sasaki, Y. Tanaka, M. Morita: Nonaqueous Electrolytes with Advances in Solvents - Chapter 2; K. Xu, Chem. Rev. 104 (2004), 4303; https://www.zsw-bw.de/fileadmin/user_upload/PDFs/Vorlesungen/lib/170206_Uni-Ulm_Lecture_LIB_Wachtler_Electrolytes.pdf');
obj = SetProperty(obj, 'Confidential', 'No');
ConductiveSalts.(Name) = obj;

%%Save elements
outputStruct = ConductiveSalts;
folder = 'Databases\icpd_publication_data\ConductiveSalts\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\ConductiveSalts\ConductiveSalts.mat', 'ConductiveSalts');
clear all
close all