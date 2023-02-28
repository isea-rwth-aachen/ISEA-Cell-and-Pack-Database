function [success] = fcn_create_Cells_Permutation(cells, housings, fithousing, fitcapacities, ...
    cathodeVoltages, surfaceCapacities, relVoltageLimits, materialUsageRestrictions, electrolytes, stackFolder, cellFolder, doOptimization)

success = 0;

if ~iscell(relVoltageLimits)
    relVoltageLimits=num2cell(relVoltageLimits);
end

cellnames = fieldnames(cells);
housingnames = fieldnames(housings);
electrolytenames = fieldnames(electrolytes);

AllCells = [];
AllStacks = [];

k=1;
permut = [];
for i_1 = 1 : numel(cellnames)
    for i_2 = 1 : numel(fithousing)
        for i_3 = 1 : numel(cathodeVoltages)
            for i_4 = 1 : numel(surfaceCapacities)
                for i_5 = 1 : numel(relVoltageLimits)
                    for i_6 = 1 : numel(materialUsageRestrictions)
                        for i_7 = 1 : numel(electrolytenames)
                            permut(k, :) = [i_1, i_2, i_3, i_4, i_5, i_6, i_7];
                            AllStacksEnum(k) =  cells.(cellnames{i_1}).ElectrodeStack;
                            AllCellsEnum(k) =  cells.(cellnames{i_1});
                            k=k+1;
                        end
                    end
                end
            end
        end
    end
end

for k = 1 : numel(permut(:, 1)) %parfor for parallellization
    if numel(relVoltageLimits{permut(k, 5)})>1
        Name_relVoltageLimits = strcat(num2str(relVoltageLimits{permut(k, 5)}(1)*1000), 't', num2str(relVoltageLimits{permut(k, 5)}(2)*1000));
    else
        Name_relVoltageLimits = num2str(relVoltageLimits{permut(k, 5)}*1000);
    end
    
    Name_doOptimization = '';
    
    if exist ('doOptimization', 'var')
        if doOptimization
            Name_doOptimization= '_O';
        end
    end
    
    paramNames = [string(cellnames{permut(k, 1)}), string(fithousing{permut(k, 2)}), num2str(cathodeVoltages(permut(k, 3))*1000), ...
        num2str(surfaceCapacities(permut(k, 4))), Name_relVoltageLimits, ...
        num2str(materialUsageRestrictions(permut(k, 6))*1000)];
    
    AllStackNames(k)=strcat('S_', AllStacksEnum(k).Cathode.Coating.ActiveMaterial.Abbreviation, '_', ...
        AllStacksEnum(k).Anode.Coating.ActiveMaterial.Abbreviation, '_', housings.(fithousing{permut(k, 2)}).AddInfo.ShortName,...
        '_', electrolytes.(electrolytenames{permut(k, 7)}).AddInfo.ShortName,...
        '_Ah', num2str(fitcapacities(permut(k, 2))), '_UC', paramNames(3), '_SC', paramNames(4), ...
        '_VL', paramNames(5), '_UR', paramNames(6), Name_doOptimization);
    AllCellNames(k)=strcat('C_', AllStacksEnum(k).Cathode.Coating.ActiveMaterial.Abbreviation, '_', ...
        AllStacksEnum(k).Anode.Coating.ActiveMaterial.Abbreviation, '_', housings.(fithousing{permut(k, 2)}).AddInfo.ShortName,...
        '_', electrolytes.(electrolytenames{permut(k, 7)}).AddInfo.ShortName,...
        '_Ah', num2str(fitcapacities(permut(k, 2))), '_UC', paramNames(3), '_SC', paramNames(4), ...
        '_VL', paramNames(5), '_UR', paramNames(6), Name_doOptimization);
    
    AllStacksEnum(k).Name = AllStackNames(k);
    
    if numel(Name_doOptimization)==0
        if materialUsageRestrictions(permut(k, 6))~=0
            AllStacksEnum(k).Cathode.Coating.ActiveMaterial = AllStacksEnum(k).Cathode.Coating.ActiveMaterial.SetUseRange([materialUsageRestrictions(permut(k, 6)), 1-materialUsageRestrictions(permut(k, 6))]);
            AllStacksEnum(k).Anode.Coating.ActiveMaterial = AllStacksEnum(k).Anode.Coating.ActiveMaterial.SetUseRange([materialUsageRestrictions(permut(k, 6)), 1-materialUsageRestrictions(permut(k, 6))]);
        end
        
        if cathodeVoltages(permut(k, 3))~=5
            AllStacksEnum(k).Cathode.Coating.ActiveMaterial = AllStacksEnum(k).Cathode.Coating.ActiveMaterial.SetVoltageLimits([0, cathodeVoltages(permut(k, 3))]);
        end
        AllStacksEnum(k).Cathode.Coating = AllStacksEnum(k).Cathode.Coating.RefreshCalc();
        AllStacksEnum(k).Anode.Coating = AllStacksEnum(k).Anode.Coating.RefreshCalc();
        AllStacksEnum(k).Cathode = AllStacksEnum(k).Cathode.RefreshCalc();
        AllStacksEnum(k).Anode = AllStacksEnum(k).Anode.RefreshCalc();
        if surfaceCapacities(permut(k, 4)) ~= 0
            AllStacksEnum(k).Cathode=AllStacksEnum(k).Cathode.AdaptThicknessToSurfaceCapacity(surfaceCapacities(permut(k, 4)));
            AllStacksEnum(k).Anode=AllStacksEnum(k).Anode.AdaptThicknessToSurfaceCapacity(surfaceCapacities(permut(k, 4)));
        end
        AllStacksEnum(k).Electrolyte = electrolytes.(electrolytenames{permut(k, 7)});
        AllStacksEnum(k)=AllStacksEnum(k).RefreshCalc();
        if relVoltageLimits{permut(k, 5)} == 0
            AllStacksEnum(k)=AllStacksEnum(k).SetVoltageRange([0, 5], true);
        else
            if numel(relVoltageLimits{permut(k, 5)})>1
                U_min(k) = relVoltageLimits{permut(k, 5)}(1);
                U_max(k) = relVoltageLimits{permut(k, 5)}(2);
            else
                U_min(k) = AllStacksEnum(k).NominalVoltage*(1-relVoltageLimits{permut(k, 5)});
                U_max(k) = AllStacksEnum(k).NominalVoltageCha*(1+relVoltageLimits{permut(k, 5)});
            end
            AllStacksEnum(k)=AllStacksEnum(k).SetVoltageRange([U_min(k), U_max(k)], true);
        end
    else
        MatUse = [materialUsageRestrictions(permut(k, 6)), 1-materialUsageRestrictions(permut(k, 6))];
        if relVoltageLimits{permut(k, 5)} == 0
            U_Lim = [0, 5];
        else
            if numel(relVoltageLimits{permut(k, 5)})>1
                U_Lim = [relVoltageLimits{permut(k, 5)}(1), relVoltageLimits{permut(k, 5)}(2)];
            else
                U_Lim = [AllStacksEnum(k).NominalVoltage*(1-relVoltageLimits{permut(k, 5)}), ...
                    AllStacksEnum(k).NominalVoltageCha*(1+relVoltageLimits{permut(k, 5)})];
            end
        end
        CatVolt = cathodeVoltages(permut(k, 3));
        AllStacksEnum(k)=AllStacksEnum(k).FitStackBestCap(CatVolt, U_Lim, MatUse, MatUse, true);
        AllStacksEnum(k)=AllStacksEnum(k).SetVoltageRange(U_Lim, true);
    end
    
    AllStacksEnum(k) = AllStacksEnum(k).SetProperty('PrismaticWindingStyle', 'LO');
    AllCellsEnum(k).Name = AllCellNames(k);
    AllCellsEnum(k).ElectrodeStack = AllStacksEnum(k);
    
    if fitcapacities(permut(k, 2))
        AllCellsEnum(k).Housing = housings.(fithousing(permut(k, 2)));
        AllCellsEnum(k) = AllCellsEnum(k).FitStackToHousing();
        AllCellsEnum(k) = AllCellsEnum(k).FitCellToCapacity(fitcapacities(permut(k, 2)));
        AllCellsEnum(k) = AllCellsEnum(k).RefreshCalc();
    else
        AllCellsEnum(k).Housing = housings.(fithousing{permut(k, 2)});
        AllCellsEnum(k) = AllCellsEnum(k).FitStackToHousing();
        AllCellsEnum(k) = AllCellsEnum(k).RefreshCalc();
    end
    
    AllCellsEnum(k) = SetProperty(AllCellsEnum(k), 'Source', 'MJU');
    AllCellsEnum(k) = SetProperty(AllCellsEnum(k), 'Confidential', 'No');
    
    disp (strcat(AllCellNames(k), ' was created'))
end
for k = 1 : numel(permut(:, 1))
    AllStacks.(AllStackNames(k))=AllStacksEnum(k);
    AllCells.(AllCellNames(k))=AllCellsEnum(k);
end

%% Save elements
outputStruct = AllCells;
folder = cellFolder;

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' saved']);
    clear saveVar
end

save([cellFolder 'AllCells.mat'], 'AllCells');

%% Save elements
outputStruct = AllStacks;
folder = stackFolder;

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' saved']);
    clear saveVar
end

save([stackFolder 'AllElectrodeStacks.mat'], 'AllStacks');
success = 1;
end