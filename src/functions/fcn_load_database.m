function fcn_load_database(app)
clb_load_ACMaterial(app);
clb_load_Blends_from_database(app);
clb_load_Housing_from_database(app);
housingsList=dir([app.path_database,'\Housings']);
housingsNames={};
for idxHouse=4:length(housingsList)
    if strcmp(housingsList(idxHouse).name,'Housings.mat')
        continue
    end
    housingsNames={housingsNames{:},strrep(housingsList(idxHouse).name,'.mat','')};
end
app.HousingMainDropDown.Items=housingsNames';
%% load electrode stacks
electrodeStacksList=dir([app.path_database,'\ElectrodeStacks']);
electrodeStacksNames={};
for idxStack=4:length(electrodeStacksList)
    if strcmp(electrodeStacksList(idxStack).name,'ElectrodeStacks.mat')
        continue
    end
    electrodeStacksNames={electrodeStacksNames{:},strrep(electrodeStacksList(idxStack).name,'.mat','')};
end
app.ElectrodeStackMainDropDown.Items=electrodeStacksNames';
%% load cells
clb_load_Cells_from_database(app);
cellsList=dir([app.path_database,'\Cells']);
cellsNames={};
for idxCell=4:length(cellsList)
    if strcmp(cellsList(idxCell).name,'Cells.mat')
        continue
    end
    cellsNames={cellsNames{:},strrep(cellsList(idxCell).name,'.mat','')};
end
app.CellParaVarDropDown.Items=cellsNames';
app.CellExportDropDown.Items=cellsNames';
end