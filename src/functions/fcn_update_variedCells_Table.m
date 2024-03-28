function fcn_update_variedCells_Table(app,cells)
%% function for creation of the table of the varied cells
%% init
varied_cells_table  = [];
if isempty(cells) || any(arrayfun(@(x) ~isa(cells(x),'Cell'),(1:numel(cells))))
    return;
end
base_cell           = app.CellParaVarDropDown.Value;
name_base_cell      = convertStringsToChars(GetProperty(base_cell, 'Name'));
cells               = [base_cell cells];
if ~isempty(app.VariedCellsTable.StyleConfigurations) && ~isempty(app.VariedCellsTable.StyleConfigurations.Target)
    removeStyle(app.VariedCellsTable,1);
end
column_names                                = app.VariedCellsTable.ColumnName';
varied_cells_table                          = table('Size', [numel(cells) numel(column_names)], 'VariableTypes', app.vartypes_VariedCellsTable);
varied_cells_table.Properties.VariableNames = app.VariedCellsTable.ColumnName;
%% write table
temp_table                                  = fcn_write_Cell_Table(app,cells);
[~,idx_relevant_entrys]                     = ismember(app.id_class_to_VariedCellsTable,app.id_class_to_CellsTable);
idx_not_found                               = idx_relevant_entrys == 0;
idx_relevant_entrys(idx_not_found)          = [];
idx_is_logical                              = cellfun(@(x) strcmpi(x,'logical'),app.vartypes_VariedCellsTable);
varied_cells_table(:,~idx_not_found)        = temp_table(:,idx_relevant_entrys);
varied_cells_table{:,idx_is_logical}        = false(size(varied_cells_table,1),1);
varied_cells_table.Properties.RowNames      = {};
%% get missing entrys
if nnz(idx_not_found)
    ids_column_not_found                        = find(idx_not_found);
    temp_table                                  = table('Size', [numel(cells) numel(column_names(ids_column_not_found))], 'VariableTypes', app.vartypes_VariedCellsTable(ids_column_not_found));
    temp_table.Properties.VariableNames         = column_names(ids_column_not_found);
    for i = ids_column_not_found
        temp_table                              = fcn_write_columne_of_table_global(app.id_class_to_VariedCellsTable{i},app.vartypes_VariedCellsTable{i},column_names{i},temp_table,cells);
    end
    varied_cells_table(:,idx_not_found)         = temp_table;
end
%% Output tabele in the GUI
varied_cells_table.Properties.VariableNames     = app.VariedCellsTable.ColumnName';
app.VariedCellsTable.Data                       = varied_cells_table;
%% style changing for base housing
[~,idx_base_cell]                               = ismember(name_base_cell,app.VariedCellsTable.Data.("Name"));
base_style                                      = uistyle('BackgroundColor', 'green');
addStyle(app.VariedCellsTable,base_style,'row',idx_base_cell);
app.VariedCellsTable.Data{idx_base_cell,idx_is_logical}   = true;
end