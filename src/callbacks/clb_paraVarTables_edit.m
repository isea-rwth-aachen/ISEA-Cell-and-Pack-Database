function clb_paraVarTables_edit(app,event)
%% callback function for parameter variation tables edit
%% init
if ~strcmp(event.Source.ColumnName{event.Indices(2)},'Vary') &&  ~strcmp(event.Source.ColumnName{event.Indices(2)},'# variations')
    return;
end
fcn_busyLamp(app,'busy','BusyMainLamp');
%% check if the base housing or base cathode/anode was deselected
base_cell                   = app.CellParaVarDropDown.Value;
base_housing                = convertStringsToChars(GetProperty(base_cell.Housing,'Name'));
base_anode                  = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Anode.Coating.ActiveMaterial,'Name'));
base_cathode                = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Cathode.Coating.ActiveMaterial,'Name'));
%housing
idx_is_selected             = app.HousingParaVarTable.Data.("Vary");
names_selected              = app.HousingParaVarTable.RowName(idx_is_selected);
is_base_selected            = ismember(base_housing,names_selected);
if all(~is_base_selected)
    idx_base_row                                        = strcmpi(app.HousingParaVarTable.RowName,base_housing);
    app.HousingParaVarTable.Data{idx_base_row,"Vary"}   = true;
end
%anode
idx_as_anode_selected       = app.ActiveMaterialParaVarTable.Data.("Is Anode");
names_anode_selected        = app.ActiveMaterialParaVarTable.RowName(idx_as_anode_selected);
is_base_anode_selected      = ismember(base_anode,names_anode_selected);
if all(~is_base_anode_selected)
    idx_base_row                                                = strcmpi(app.ActiveMaterialParaVarTable.RowName,base_anode);
    app.ActiveMaterialParaVarTable.Data{idx_base_row,"Is Anode"}= true;
end
%cathode
idx_as_cathode_selected     = app.ActiveMaterialParaVarTable.Data.("Is Cathode");
names_cathode_selected      = app.ActiveMaterialParaVarTable.RowName(idx_as_cathode_selected);
is_base_cathode_selected    = ismember(base_cathode,names_cathode_selected);
if all(~is_base_cathode_selected)
    idx_base_row                                                = strcmpi(app.ActiveMaterialParaVarTable.RowName,base_cathode);
    app.ActiveMaterialParaVarTable.Data{idx_base_row,"Is Anode"}= true;
end
%% update labe
fcn_update_NVariation_label(app);
fcn_busyLamp(app,'ready','BusyMainLamp');
end