function blends_table = fcn_write_BlendsTable(app,blends_add_cell)
%% function for creation of a blends table from the variable blends_add_cell
%check for right input data
if isa(blends_add_cell, 'Blend')
    blends_add_cell                     = arrayfun(@(x) {blends_add_cell(x)}, (1:numel(blends_add_cell)));
end
%% Initialize table
column_names                                = app.BlendsTable.ColumnName;
vartypes                                    = app.vartypes_BlendsTable;
variable_units                              = app.units_vars_BlendsTable;
n_column                                    = length(column_names);
n_ConSalts                                  = numel(blends_add_cell);
if numel(vartypes) ~= n_column && n_column ~= numel(variable_units)
   error('Check the name of the expected columns, the data types of the columns of the blends table and the specified units of the columns of the blends table!'); 
end
blends_table                              = table('Size', [n_ConSalts n_column], 'VariableTypes', vartypes);
blends_table.Properties.VariableNames     = column_names;
rownames                                    = cellfun(@(x) mat2str(x.Name), blends_add_cell, 'UniformOutput', false);
rownames                                    = cellfun(@(x) strrep(x,'"',''), rownames, 'UniformOutput', false);
blends_table.Properties.RowNames          = rownames;
blends_table.Properties.Description       = 'This table contains all available blends.';
blends_table.Properties.VariableUnits     = variable_units;
%% write the table
blends_table.Name                         = rownames';
% solvents_table                              = arrayfun(@(x) fcn_write_columne_of_table(app,solvents_table,x,solvents_add_cell),(2:n_column),'UniformOutput',false);
for i = 2: n_column
    blends_table                          = fcn_write_columne_of_table(app,blends_table,i,blends_add_cell);
end
end

function table = fcn_write_columne_of_table(app,table,id,blends)
%% function to write the individual columns of the table 
id_object                                   = app.id_class_to_Blends_table{id};
vartype                                     = app.vartypes_BlendsTable{id};
column_name                                 = app.BlendsTable.ColumnName{id};
n_conSalts                                  = numel(blends);
switch column_name
    case 'Edit'
        table.("Edit")                          = false(n_conSalts,1);
    case {'Elements' 'Transfer Material'}
        % Determine subordinate elements
        sub_materials                               = cellfun(@(x) x.(id_object),blends,'UniformOutput',false);
        [sub_elements,~]                            = cellfun(@(x) fcn_split_material_in_elements_substances(x), sub_materials,'UniformOutput',false);
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), blends, 'UniformOutput', false))) == n_conSalts
            table.Elements                              = strings(n_conSalts,1);
        else
            tmp_names                                   = cellfun(@(x) arrayfun(@(y) convertStringsToChars(GetProperty((x(y)),'Name')), (1:numel(x)),'UniformOutput',false),...
                                                            sub_elements,'UniformOutput',false);
            table.(column_name)                         = cellfun(@(x) strjoin(x,', '),tmp_names, 'UniformOutput', false)';
        end
    case 'Active Material'
        temp_activeMaterials                    = cellfun(@(x) GetProperty(x,'ActiveMaterials'),blends,'UniformOutput', false);
        tmp_names                               = cellfun(@(x) arrayfun(@(y) convertStringsToChars(GetProperty(x(y), 'Name')), (1:numel(x)), 'UniformOutput',false),...
                                                        temp_activeMaterials,'UniformOutput',false);
        table.(column_name)                     = cellfun(@(x) strjoin(x,', '),tmp_names, 'UniformOutput', false)';
    otherwise
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), blends, 'UniformOutput', false))) == n_conSalts
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = strings(n_conSalts,1);
            else
                table.(column_name)                             = zeros(n_conSalts,1);
            end
        else
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = cellfun(@(x) convertStringsToChars(x.(id_object)),blends,'UniformOutput', false)';
            elseif strcmpi(vartype, 'double')
                tmp_entry                               = cellfun(@(x) x.(id_object), blends, 'UniformOutput',false)';
                idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
                tmp_entry(idx_empty)                    = {NaN};
                table.(column_name)                     = cell2mat(tmp_entry);
            end
        end
end
end