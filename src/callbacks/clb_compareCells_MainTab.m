function clb_compareCells_MainTab(app)
%% callback function for button compare cells pushed at main tab
global global_cells;
fcn_busyLamp(app,'busy','BusyMainLamp');
%% init
idx_Cells_to_plot                   = app.ComparisonTable.Data.("Compare");
identifier                          = app.ComparisonTable.RowName(idx_Cells_to_plot);
if nnz(idx_Cells_to_plot) < 2
    msgbox('Not enough cells were selected for plotting. Please select at least two cells to be plotted using the "Compare" column of the table.', 'No cells could compare.', 'help');
    return;
end
identifiers_global                                  = arrayfun(@(x) convertStringsToChars(global_cells(x).Name),(1:numel(global_cells)),'UniformOutput',false);
[~,idx_Cells_to_plot]                               = ismember(identifier,identifiers_global);
%% get sub objects for plotting
cell_objects                                        = global_cells(idx_Cells_to_plot);
electrode_stacks                                    = arrayfun(@(x) GetProperty(global_cells(x), 'ElectrodeStack'), idx_Cells_to_plot);
housings                                            = arrayfun(@(x) GetProperty(global_cells(x), 'Housing'), idx_Cells_to_plot, 'UniformOutput', false);
name_cells                                          = arrayfun(@(x) strrep(convertStringsToChars(GetProperty(global_cells(x), 'Name')),'_', ' '), idx_Cells_to_plot, 'UniformOutput', false);
type                                                = app.SwitchOCVMain.Value;
%% plot components
if ~app.OwnfigureCompareCheckBox.Value && nnz(idx_Cells_to_plot) < 3
    fcn_plot_Housings(app,housings,[],'ComparisonHousingsUIAxes');
    fcn_plot_Cell_OCV(app,cell_objects,'ComparisonOCVUIAxes',true,[]);
    fcn_get_spider_plot_cells(app,global_cells(idx_Cells_to_plot),'ComparisonSpiderUIAxes');
else
    fcn_plot_Housings(app,housings,[],[],global_cells(idx_Cells_to_plot));
    fcn_plot_ElectrodeStacks(app,electrode_stacks,[],[],[],type,global_cells(idx_Cells_to_plot));
    fcn_get_spider_plot_cells(app,global_cells(idx_Cells_to_plot),[],true);
    fcn_plot_weightDistribution(app,global_cells(idx_Cells_to_plot),[]);
end
fcn_busyLamp(app,'ready','BusyMainLamp');
end