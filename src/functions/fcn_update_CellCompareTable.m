function fcn_update_CellCompareTable(app)
%% function for updating the comparison table
global global_cells;
n_Cells_cell              = numel(global_cells);
n_Cells_table             = numel(app.ComparisonTable.RowName);
if n_Cells_cell > n_Cells_table
    names_in_table                      = app.ComparisonTable.RowName;
    names_in_global                     = arrayfun(@(x) convertStringsToChars(GetProperty(global_cells(x),'Name')),(1:n_Cells_cell), 'UniformOutput', false);
    Cells_add                           = global_cells(~ismember(names_in_global,names_in_table));
    Comparison_table                    = fcn_write_CellCompareTable(app,Cells_add);
    % i dont know why it is nessecarry but without distinction the data
    % type of checkbox of the table is wrong
    if isempty(app.ComparisonTable.Data)
        app.ComparisonTable.Data                          = [app.ComparisonTable.Data; Comparison_table];
        app.ComparisonTable.Data.("Compare")              = false(numel(Comparison_table.Properties.RowNames),1);
        app.ComparisonTable.RowName                       = [app.ComparisonTable.RowName; Comparison_table.Properties.RowNames];
    else
        app.ComparisonTable.Data                          = [app.ComparisonTable.Data; Comparison_table];
        app.ComparisonTable.RowName                       = [app.ComparisonTable.RowName; Comparison_table.Properties.RowNames];
    end
end
end