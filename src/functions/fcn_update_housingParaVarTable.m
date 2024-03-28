function fcn_update_housingParaVarTable(app)
%% function for updating the housing parameter variation table at the parameter variation tab at the main tab
%% init
global global_housings;
global global_cells;
fcn_busyLamp(app,'busy','BusyMainLamp');
if isempty(global_housings)
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
base_cell               = app.CellParaVarDropDown.Value;
base_housing            = convertStringsToChars(GetProperty(base_cell.Housing, 'Name'));
if ~isempty(app.HousingParaVarTable.StyleConfigurations) && ~isempty(app.HousingParaVarTable.StyleConfigurations.Target)
    removeStyle(app.HousingParaVarTable,1);
end
%% write table
housing_paraVar_table                       = fcn_write_HousingTable(app,global_housings);
[~,idx_relevant_entrys]                     = ismember(app.id_class_to_HousingVaraTable,app.id_class_to_HousingTable);
idx_is_logical                              = cellfun(@(x) isempty(x),app.id_class_to_HousingVaraTable);
housing_paraVar_table                       = housing_paraVar_table(:,idx_relevant_entrys);
housing_paraVar_table{:,idx_is_logical}     = false(size(housing_paraVar_table,1),1);
%% Output tabele in the GUI
housing_paraVar_table.Properties.VariableNames  = app.HousingParaVarTable.ColumnName';
app.HousingParaVarTable.RowName                 = housing_paraVar_table.Properties.RowNames;
app.HousingParaVarTable.Data                    = housing_paraVar_table;
%% style changing for base housing
[~,idx_base_housing]                            = ismember(base_housing,app.HousingParaVarTable.RowName);
base_style                                      = uistyle('BackgroundColor', 'green');
addStyle(app.HousingParaVarTable,base_style,'row',idx_base_housing);
app.HousingParaVarTable.Data{idx_base_housing,idx_is_logical}   = true;
fcn_busyLamp(app,'ready','BusyMainLamp');
end