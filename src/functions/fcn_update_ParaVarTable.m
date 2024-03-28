function fcn_update_ParaVarTable(app,parameter)
%% function for updating the parameter variation table at the parmeter variation tab at the main tab
%% init
base_cell               = app.CellParaVarDropDown.Value;
if isempty(base_cell)
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
n_parameter             = numel(parameter);
%% get table
parameter_vary_table = fcn_write_ParameterVaryTable(app,base_cell);
if isempty(parameter_vary_table)
    return;
end
%% Get only the selected part of the table
[~,idx_selected]        = ismember(parameter,parameter_vary_table.Properties.RowNames);
%% get previous data
previous_table          = app.ParaVarTable.Data;
if ~isempty(previous_table)
   used_para            = app.ParaVarTable.RowName;
   min_values           = app.ParaVarTable.Data.('min');
   max_values           = app.ParaVarTable.Data.('max');
   n_variations         = app.ParaVarTable.Data.('# variations');
   parameter_vary_table{used_para,'min'}            = min_values;
   parameter_vary_table{used_para,'max'}            = max_values;
   parameter_vary_table{used_para,'# variations'}   = n_variations;
end
%% cut table and show it
parameter_vary_table        = parameter_vary_table(idx_selected,:);
app.ParaVarTable.RowName    = parameter_vary_table.Properties.RowNames;
app.ParaVarTable.Data       = parameter_vary_table;
end