clear all
close all

MatFolder = 'Databases\icpd_publication_data\00_InputData\ActiveMaterials\OCVs';
F = 96485; %[As/mol]

%%
load([MatFolder '\MaterialData.mat'])
SubFolders = dir(MatFolder);
for i = 3:numel(SubFolders)
    Subfolder = SubFolders(i);
    Files = dir([Subfolder.folder '\' Subfolder.name]);
    for j = 3:numel(Files)
        File = Files(j);
        [filepath,name,ext] = fileparts([File.folder '\' File.name]);
        if strcmp(ext, ".csv")
            inputFile = [File.folder '\' File.name];
            AM = strsplit(name, '_');
            AM = AM(1);
            
            Column = strcmp(AM, table2array(MaterialData(:,1)));
            if sum(Column)==1
                clear inputText inputData Data
                molarMass = MaterialData{Column, 3};
                fixPoint_xLi = MaterialData{Column, 5};
                
                inputText = fileread(inputFile);
                inputText = strrep(inputText, ', ', '?');
                inputText = strrep(inputText, '; ', '?');
                inputText = strrep(inputText, ',', '.');
                inputText = strrep(inputText, '?', ', ');
                inputData = textscan(inputText, '%f %f', 'Delimiter',',');
                inputData = cell2mat(inputData);
                
                [Data.ah, ind] = unique(inputData(:,1)');
                Data.ocv = inputData(ind,2)';
                
                if Data.ocv(1)<Data.ocv(end) %decreasing OCV
                    Data.ocv=flip(Data.ocv);
                    Data.ah=flip(Data.ah);
                end
                if Data.ah(1)>Data.ah(end) %decreasing OCV
                    Data.ah=max(Data.ah)-Data.ah;
                end
                
                if MaterialData{Column, 4}=="min"
                    fixPoint_mAh = min(Data.ah);
                elseif MaterialData{Column, 4}=="max"
                    fixPoint_mAh = max(Data.ah);
                else
                    disp ([MaterialData(Column, 4) ' is no defined type'])
                    continue
                end
                
                Data.x_Li = fixPoint_xLi + (Data.ah-fixPoint_mAh)*3600/1000*molarMass/F;
                
                save([filepath '\' name '.mat'], '-struct', 'Data');
                disp ([name '.mat was saved'])
            else
                disp ([name ' is not distinct in MaterialData Table'])
            end
        end
    end
end
clear all
close all