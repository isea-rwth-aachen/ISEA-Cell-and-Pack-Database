clear all
close all

load('Databases\icpd_publication_data\00_InputData\Elements\Periodic-Table.mat')

Elements_all  = [];

for index = 1:length(atomic)
    Name = Englishelementname{index};
    Elements_all.(Name) = Element();
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'Name', Name);
    
    ChemFormula = atomicsymbol{index};
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'Abbreviation', ChemFormula);
    
    ChemFormula = atomicsymbol{index};
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'ChemFormula', ChemFormula);
    
    MolarMass = atomicmassNIST2016(index);
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'MolarMass', MolarMass);
    
    Density = densitygmL(index);
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'Density', Density);
    
    ElectricalConductivity = electricalconductivitymhocm(index)*1e8;
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'ElectricalConductivity', ElectricalConductivity);
    
    MeltingPoint = MeltingPointC(index);
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'MeltingPoint', MeltingPoint);
    
    BoilingPoint = BoilingPointC(index);
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'BoilingPoint', BoilingPoint);
    
    AddInfo = [];
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'AddInfo', AddInfo);
    
    Source = ['Periodic Table from ', 'http://www.mrbigler.com/documents/Periodic-Table.xls'];
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'Source', Source);
    
    Confidential = 'No';
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'Confidential', Confidential);
    
    StringOfOxidationStates = commonoxidationstates{index};
    OxidationStates = [];
    for index2 = 1:length(StringOfOxidationStates)
        OxidationState = str2double(StringOfOxidationStates(index2));
        if ~isnan(OxidationState)
            if index2 ~= 1
                if strcmp(StringOfOxidationStates(index2-1), '-') || strcmp(StringOfOxidationStates(index2-1), '?')
                    OxidationStates = [OxidationStates, -1*OxidationState];
                elseif strcmp(StringOfOxidationStates(index2-1), '±')
                    OxidationStates = [OxidationStates, OxidationState, -1*OxidationState];
                else
                    OxidationStates = [OxidationStates, OxidationState];
                end
            else
                OxidationStates = [OxidationStates, OxidationState];
            end
        end
    end
    Elements_all.(Name) = SetProperty(Elements_all.(Name), 'OxidationStates', OxidationStates);
    
end

outputStruct = Elements_all;
fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = Elements_all.(fn{el});
    save(['Databases\icpd_publication_data\Elements\' convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    clear saveVar
end
save('Databases\icpd_publication_data\Elements\Elements_all.mat', 'Elements_all');
PeriodicTable = Elements_all;
save('Databases\icpd_publication_data\Elements\PeriodicTable.mat', 'PeriodicTable');
clear all
close all