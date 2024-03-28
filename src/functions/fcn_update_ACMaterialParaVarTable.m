function fcn_update_ACMaterialParaVarTable(app)
%% function for updating the active material table at the parameter variation tab at the main tab
%% init
global global_ACMaterial;
global global_blends;
fcn_busyLamp(app,'busy','BusyMainLamp');
if isempty(global_ACMaterial)
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
base_cell               = app.CellParaVarDropDown.Value;
base_anode_acm          = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Anode.Coating.ActiveMaterial, 'Name'));
base_cathode_acm        = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Cathode.Coating.ActiveMaterial, 'Name'));
if ~isempty(app.ActiveMaterialParaVarTable.StyleConfigurations) && ~isempty(app.ActiveMaterialParaVarTable.StyleConfigurations.Target)
    removeStyle(app.ActiveMaterialParaVarTable,1);
end
%% write active material table
acm_paraVar_table                           = fcn_write_ACMaterialTable(app,global_ACMaterial);
[~,idx_relevant_entrys]                     = ismember(app.id_class_to_ACMaterialVaraTable,app.id_class_to_ACMaterial_table);
idx_is_logical                              = strcmpi(app.vartypes_ACMaterialVaraTable,'logical');
acm_paraVar_table                           = acm_paraVar_table(:,idx_relevant_entrys);
acm_paraVar_table{:,idx_is_logical}         = false(size(acm_paraVar_table,1),nnz(idx_is_logical));
%% write blend table
blends_paraVar_table                        = fcn_write_BlendsTable(app,global_blends);
[~,idx_relevant_entrys]                     = ismember(app.id_class_to_ACMaterialVaraTable,app.id_class_to_Blends_table);
idx_is_logical                              = strcmpi(app.vartypes_ACMaterialVaraTable,'logical');
blends_paraVar_table                        = blends_paraVar_table(:,idx_relevant_entrys);
blends_paraVar_table{:,idx_is_logical}      = false(size(blends_paraVar_table,1),nnz(idx_is_logical));
%% Output tabele in the GUI
acm_paraVar_table.Properties.VariableNames      = app.ActiveMaterialParaVarTable.ColumnName';
blends_paraVar_table.Properties.VariableNames   = app.ActiveMaterialParaVarTable.ColumnName';
app.ActiveMaterialParaVarTable.RowName          = [acm_paraVar_table.Properties.RowNames; blends_paraVar_table.Properties.RowNames];
app.ActiveMaterialParaVarTable.Data             = [acm_paraVar_table; blends_paraVar_table];
%% style changing for base housing
[~,idx_base_anode]                          = ismember(base_anode_acm,app.ActiveMaterialParaVarTable.RowName);
[~,idx_base_cathode]                        = ismember(base_cathode_acm,app.ActiveMaterialParaVarTable.RowName);
[~,id_is_anode_column]                      = ismember('Is Anode',acm_paraVar_table.Properties.VariableNames);
[~,id_is_cathode_column]                    = ismember('Is Cathode',acm_paraVar_table.Properties.VariableNames);
base_style                                  = uistyle('BackgroundColor', 'green');
addStyle(app.ActiveMaterialParaVarTable,base_style,'row',[idx_base_anode idx_base_cathode]);
app.ActiveMaterialParaVarTable.Data{idx_base_anode,id_is_anode_column}      = true;
app.ActiveMaterialParaVarTable.Data{idx_base_cathode,id_is_cathode_column}  = true;
fcn_busyLamp(app,'ready','BusyMainLamp');
end