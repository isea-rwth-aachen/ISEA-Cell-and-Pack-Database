function fcn_init_paraVariationTab(app,flag_changed)
%% function for updating the parameter variation tab at the main tab
%% init
global global_cells;
fcn_busyLamp(app, 'busy', 'BusyMainLamp');
if isempty(global_cells)
    fcn_busyLamp(app, 'ready', 'BusyMainLamp');
    return;
end
idx_dropDown            = cell2mat(cellfun(@(x) isa(app.(x),'matlab.ui.control.DropDown'), fieldnames(app),'UniformOutput',false));
name_Fields             = fieldnames(app);
name_dropDown_all       = name_Fields(idx_dropDown);
%% get drop down data
% base cell
idx_temp                = contains(name_dropDown_all, 'CellParaVar');
if ~exist('flag_changed','var') || ~flag_changed
    fcn_get_dropDown_items(app,name_dropDown_all(idx_temp),'Cell');
end
current_cell_name       = app.(name_dropDown_all{idx_temp}).Value;
names_global_cells      = arrayfun(@(x) convertStringsToChars(GetProperty(x,'Name')),global_cells,'UniformOutput',false);
current_cell            = current_cell_name;
%% get label data
capacity                = GetProperty(current_cell, 'Capacity');
power                   = GetProperty(current_cell, 'Power');
app.CapacityParaVarLabel.Text   = strcat('Capacity:  ', num2str(capacity,4), ' Ah');
app.PowerParaVarLabel.Text      = strcat('Power:  ', num2str(power,4), ' W');
%% init list of parameter and components to vary
parameters_to_vary              = cellfun(@(x) x{1},app.id_para_to_listElement,'UniformOutput',false);
app.VaryParaListBox.Items       = ['None' parameters_to_vary];
clb_change_para_to_vary_selection(app);
fcn_update_housingParaVarTable(app);
fcn_change_visibility_table(app,'HousingParaVarTable','on');
pause(0.7);
fcn_update_ACMaterialParaVarTable(app);
fcn_change_visibility_table(app,'ActiveMaterialParaVarTable','on');
pause(0.7);
fcn_busyLamp(app, 'ready', 'BusyMainLamp');
end