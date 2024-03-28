function Comparison_table = fcn_write_CellCompareTable(app,cells_add_cell)
%% function for updating the compare cell table at the main tab
if isa(cells_add_cell, 'Cell')
    cells_add_cell                     = arrayfun(@(x) {cells_add_cell(x)}, (1:numel(cells_add_cell)));
end
%% Initialize table
column_names                                    = app.ComparisonTable.ColumnName;
vartypes                                        = app.vartypes_CompareTable;
variable_units                                  = app.units_vars_CompareTable;
n_column                                        = length(column_names);
n_Cells                                         = numel(cells_add_cell);
if numel(vartypes) ~= n_column && n_column ~= numel(variable_units)
   error('Check the name of the expected columns, the data types of the columns of the cells table and the specified units of the columns of the comparison table!'); 
end
Comparison_table                                = table('Size', [n_Cells n_column], 'VariableTypes', vartypes);
Comparison_table.Properties.VariableNames       = column_names;
rownames                                        = cellfun(@(x) mat2str(x.Name), cells_add_cell, 'UniformOutput', false);
rownames                                        = cellfun(@(x) strrep(x,'"',''), rownames, 'UniformOutput', false);
Comparison_table.Properties.RowNames            = rownames;
Comparison_table.Properties.Description         = 'This table contains all available cells for comparison.';
Comparison_table.Properties.VariableUnits       = variable_units;
%% write the table
for i = 2: n_column
    Comparison_table                       = fcn_write_columne_of_table(app,Comparison_table,i,cells_add_cell);
end
end

function table = fcn_write_columne_of_table(app,table,id,cells)
%% function to write the individual columns of the table 
id_object                                   = app.id_class_to_CompareTable{id};
vartype                                     = app.vartypes_CompareTable{id};
column_name                                 = app.ComparisonTable.ColumnName{id};
n_Cells                                     = numel(cells);
switch column_name
    case {'Edit' 'Compare'}
        table.("Edit")                          = false(n_Cells,1);
    case {'Elements' 'Transfer Material'}
        % Determine subordinate elements
        sub_materials                               = cellfun(@(x) x.(id_object),cells,'UniformOutput',false);
        [sub_elements,~]                            = cellfun(@(x) fcn_split_material_in_elements_substances(x), sub_materials,'UniformOutput',false);
        
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), cells, 'UniformOutput', false))) == n_Cells
            table.Elements                              = strings(n_Cells,1);
        else
            tmp_names                                   = cellfun(@(x) arrayfun(@(y) convertStringsToChars(GetProperty((x(y)),'Name')), (1:numel(x)),'UniformOutput',false),...
                                                            sub_elements,'UniformOutput',false);
            table.(column_name)                         = cellfun(@(x) strjoin(x,', '),tmp_names, 'UniformOutput', false)';
        end
    case {'Active Material' 'Conductive additive' 'Binder' 'Conductive salt' 'Coating' 'Current collector' 'Anode' 'Cathode' 'Separator' 'Electrolyte'}
        name_objects                                    = cellfun(@(x) convertStringsToChars(GetProperty(GetProperty(x,id_object),'Name')),cells,'UniformOutput',false);
        table.(column_name)                             = name_objects';
    case {'Solvents' 'Materials' 'Housing' 'Electrode stack'}
        name_objects                                    = cellfun(@(x) join(arrayfun(@(y) convertStringsToChars(GetProperty(y,'Name')),GetProperty(x,id_object),'UniformOutput',false), ', '),...
                                                            cells,'UniformOutput',false);
        table.(column_name)                             = [name_objects{:}]';
    case {'Weight solvents' 'Temperature vector' 'Weight material' 'Dimensions' 'Tab dimensions' 'Coating dimension'}
        tmp_entry                               = cellfun(@(x) x.(id_object), cells, 'UniformOutput',false)';
        idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
        tmp_entry(idx_empty)                    = {NaN};
        table.(column_name)                     = cellfun(@(x) mat2str(x,3), tmp_entry,'UniformOutput', false);
    otherwise
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), cells, 'UniformOutput', false))) == n_Cells
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = strings(n_Cells,1);
            else
                table.(column_name)                             = zeros(n_Cells,1);
            end
        else
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = cellfun(@(x) convertStringsToChars(x.(id_object)),cells,'UniformOutput', false)';
            elseif strcmpi(vartype, 'double')
                tmp_entry                               = cellfun(@(x) x.(id_object), cells, 'UniformOutput',false)';
                idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
                tmp_entry(idx_empty)                    = {NaN};
                table.(column_name)                     = cell2mat(tmp_entry);
            end
        end
end
end