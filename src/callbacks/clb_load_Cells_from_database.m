function clb_load_Cells_from_database(app)
%% callback function for button load from database at cells tab
global global_cells;
[Cells_Data,Cells_array]      = fcn_load_Cells_from_database(app);
if isempty(Cells_Data)
    return;
end
Cell_add                                   = cellfun(@(x) x, Cells_array); %convert in conductive salts object 
global_cells                                = [global_cells Cell_add];
end