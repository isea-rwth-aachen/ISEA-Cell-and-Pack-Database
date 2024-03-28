function Cells_table = fcn_write_Cell_Table(app,add_cells)
%% function for creation of a cell table from the variable cells_add_cell
%check for right input data
if isa(add_cells, 'Cell')
    add_cells                                   = arrayfun(@(x) {add_cells(x)}, (1:numel(add_cells)));
end
%% Initialize table
column_names                                    = app.CellsTableColumnName;
vartypes                                        = app.vartypes_CellsTable;
variable_units                                  = app.units_vars_CellsTable;
n_column                                        = length(column_names);
n_Electrodes                                    = numel(add_cells);
if numel(vartypes) ~= n_column && n_column ~= numel(variable_units)
   error('Check the name of the expected columns, the data types of the columns of the cells table and the specified units of the columns of the cells table!'); 
end
Cells_table                                     = table('Size', [n_Electrodes n_column], 'VariableTypes', vartypes);
Cells_table.Properties.VariableNames            = column_names;
rownames                                        = cellfun(@(x) mat2str(x.Name), add_cells, 'UniformOutput', false);
rownames                                        = cellfun(@(x) strrep(x,'"',''), rownames, 'UniformOutput', false);
Cells_table.Properties.RowNames                 = rownames;
Cells_table.Properties.Description              = 'This table contains all available cells.';
Cells_table.Properties.VariableUnits            = variable_units;
%% write the table
Cells_table.Name            = rownames';
for i = 2: n_column
    Cells_table                       = fcn_write_columne_of_table(app,Cells_table,i,add_cells);
end
end

function table = fcn_write_columne_of_table(app,table,id,cells)
%% function to write the individual columns of the table 
id_object                                   = app.id_class_to_CellsTable{id};
vartype                                     = app.vartypes_CellsTable{id};
column_name                                 = app.CellsTableColumnName{id};
n_Cells                                     = numel(cells);
switch column_name
    case 'Edit'
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