%% clb_save_Variations
% Callback function for the button save variations pushed at the parameter
% variation tab of the main tab
function clb_save_Variations(app)
%% init
global global_variedCells;
fcn_busyLamp(app,'busy','BusyMainLamp');
if isempty(global_variedCells)
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
idx_logical                 = strcmp(app.vartypes_VariedCellsTable, 'logical');
idx_selected                = app.VariedCellsTable.Data{:,idx_logical};
if ~nnz(idx_selected)
    msgbox('No cell was selected for plotting. Please select the appropriate cells.', 'help');
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
names_select                = convertStringsToChars(app.VariedCellsTable.Data{idx_selected,'Name'});
base_cell                   = app.CellParaVarDropDown.Value;
base_cell_name              = base_cell.Name;
names_select(strcmp(base_cell_name, names_select))      = [];
names_global                = arrayfun(@(x) convertStringsToChars(GetProperty(global_variedCells(x), 'Name')),(1:numel(global_variedCells)),'UniformOutput',false);
[ids_to_save,~]             = ismember(names_select,names_global);
%% save data 
fcn_save_ICPD_objects(app,global_variedCells(ids_to_save));
msgbox('Varied cells are saved at the path of the database.','Cell variations are saved','help');
%% user message
fcn_busyLamp(app,'ready','BusyMainLamp');
end