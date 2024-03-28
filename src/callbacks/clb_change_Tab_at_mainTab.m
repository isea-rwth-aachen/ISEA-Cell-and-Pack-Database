function clb_change_Tab_at_mainTab(app,event)
%% callback function for changing the selected tab (comparison of different cells, parameter variation or yaml export) at the main tab
global global_variedCells;
selected_tab        = app.TabGroupMainPanel.SelectedTab.Title;
previous_tab        = event.OldValue.Title;
switch selected_tab
    case 'Interface to PCM' 
        fcn_get_dropDown_items(app,'CellExportDropDown','Cell')
    case 'Parameter variation'
        fcn_init_paraVariationTab(app);
    case 'Comparison of different cells'
        fcn_update_CellCompareTable(app);
end
if strcmp(previous_tab,'Parameter variation')
    app.VariedCellsTable.Data                   = [];
    app.ParaVarTable.Data                       = [];
    app.ParaVarTable.RowName                    = [];
    global_variedCells                          = [];
end