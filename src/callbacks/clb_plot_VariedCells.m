function clb_plot_VariedCells(app)
%% callback function for button plot variations pushed at the parameter variation tab at the main tab
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
if nnz(idx_selected) > 7
   msgbox('More than 7 cells were selected for plotting. For reasons of clarity, only the first 7 cells are plotted.', 'help');
   id_stop                          = find(idx_selected);
   id_stop                          = id_stop(7);
   idx_selected(id_stop + 1 : end)  = false;
end
names_select                = convertStringsToChars(app.VariedCellsTable.Data{idx_selected,'Name'});
base_cell                   = app.CellParaVarDropDown.Value;
name_base_cell              = convertStringsToChars(GetProperty(base_cell,'Name'));
cells_to_look_in            = [base_cell global_variedCells];
names_global                = arrayfun(@(x) convertStringsToChars(GetProperty(cells_to_look_in(x), 'Name')),(1:numel(cells_to_look_in)),'UniformOutput',false);
[~,ids_to_plot]             = ismember(names_select,names_global);
%% extract data
housings                    = arrayfun(@(x) GetProperty(cells_to_look_in(x), 'Housing'),ids_to_plot, 'UniformOutput',false);
electrode_stacks            = arrayfun(@(x) GetProperty(cells_to_look_in(x), 'ElectrodeStack'),ids_to_plot);
%% plot cells
fcn_plot_Housings(app,housings,[],[],cells_to_look_in(ids_to_plot));
fcn_plot_ElectrodeStacks(app,electrode_stacks,[],[],[],'SOC',cells_to_look_in(ids_to_plot));
fcn_get_spider_plot_cells(app,cells_to_look_in(ids_to_plot),[],true);
fcn_plot_weightDistribution(app,cells_to_look_in(ids_to_plot),[]);
fcn_busyLamp(app,'ready','BusyMainLamp');
end