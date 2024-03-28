function ACMaterial_Table = fcn_write_ACMaterialTable(app,ACMaterial_array)
%% function to write the active material Data Table
%% check for right input data
if isa(ACMaterial_array, 'ActiveMaterial')
    ACMaterial_array                  = arrayfun(@(x) {ACMaterial_array(x)}, (1:numel(ACMaterial_array)));
elseif iscell(ACMaterial_array)
    is_OCV                            = cell2mat(cellfun(@(x) isa(x, 'ActiveMaterial'),ACMaterial_array, 'UniformOutput', false));
    ACMaterial_array(~is_OCV)         = [];
end
%% Initialize table
column_names                                        = app.ACMaterialTable.ColumnName;
vartypes                                            = app.vartypes_ACMaterialTable;
variable_units                                      = app.units_vars_ACMaterialTable;
n_column                                            = length(column_names);
n_ACMaterial                                        = numel(ACMaterial_array);
if numel(vartypes) ~= n_column && n_column ~= numel(variable_units)
    error('Check the name of the expected columns, the data types of the columns of the active material table and the specified units of the columns of the active material table!');
end
ACMaterial_Table                                    = table('Size', [n_ACMaterial n_column], 'VariableTypes', vartypes);
ACMaterial_Table.Properties.VariableNames           = column_names;
rownames                                            = cellfun(@(x) mat2str(x.Name), ACMaterial_array, 'UniformOutput', false);
rownames                                            = cellfun(@(x) strrep(x,'"',''), rownames, 'UniformOutput', false);
ACMaterial_Table.Properties.RowNames                = rownames;
ACMaterial_Table.Properties.Description             = 'This table contains all available active material.';
ACMaterial_Table.Properties.VariableUnits           = variable_units;
%% write the table
ACMaterial_Table.Name                               = rownames';
for i = 2: n_column
    ACMaterial_Table                          = fcn_write_columne_of_table(app,ACMaterial_Table,i,ACMaterial_array);
end
end

function table = fcn_write_columne_of_table(app, table, id, ACMaterials)
%% function to write the individual columns of the table
id_object                                   = app.id_class_to_ACMaterial_table{id};
vartype                                     = app.vartypes_ACMaterialTable{id};
column_name                                 = app.ACMaterialTable.ColumnName{id};
n_ACMaterials                               = numel(ACMaterials);
switch column_name
    case 'Edit'
        table.("Edit")                          = false(n_ACMaterials,1);
    case {'Elements' 'Transfer Material'}
        % Determine subordinate elements
        sub_materials                               = cellfun(@(x) x.(id_object), ACMaterials,'UniformOutput',false);
        [sub_elements,~]                            = cellfun(@(x) fcn_split_material_in_elements_substances(x), sub_materials,'UniformOutput',false);
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), ACMaterials, 'UniformOutput', false))) == n_ACMaterials
            table.Elements                              = strings(n_ACMaterials,1);
        else
            tmp_names                                   = cellfun(@(x) arrayfun(@(y) convertStringsToChars(GetProperty((x(y)),'Name')), (1:numel(x)),'UniformOutput',false),...
                sub_elements,'UniformOutput',false);
            table.(column_name)                         = cellfun(@(x) strjoin(x,', '), tmp_names, 'UniformOutput', false)';
        end
    case {'Active Material' 'Conductive additive' 'Binder' 'Conductive salt' 'Coating' 'Current collector'}
        name_objects                                    = cellfun(@(x) convertStringsToChars(GetProperty(GetProperty(x,id_object),'Name')), ACMaterials,'UniformOutput',false);
        table.(column_name)                             = name_objects';
    case {'Solvents' 'Materials' 'Housing' 'Electrode stack'}
        name_objects                                    = cellfun(@(x) join(arrayfun(@(y) convertStringsToChars(GetProperty(y,'Name')),GetProperty(x,id_object),'UniformOutput',false), ', '),...
            ACMaterials,'UniformOutput',false);
        table.(column_name)                             = [name_objects{:}]';
    case {'Weight solvents' 'Temperature vector' 'Weight material' 'Dimensions' 'Tab dimensions' 'Coating dimension'}
        tmp_entry                               = cellfun(@(x) x.(id_object), ACMaterials, 'UniformOutput',false)';
        idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
        tmp_entry(idx_empty)                    = {NaN};
        table.(column_name)                     = cellfun(@(x) mat2str(x,3), tmp_entry,'UniformOutput', false);
    otherwise
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), ACMaterials, 'UniformOutput', false))) == n_ACMaterials
            if strcmpi(vartype, 'string')
                table.(column_name)                             = strings(n_ACMaterials,1);
            else
                table.(column_name)                             = zeros(n_ACMaterials,1);
            end
        else
            if strcmpi(vartype, 'string')
                table.(column_name)                             = cellfun(@(x) convertStringsToChars(x.(id_object)), ACMaterials,'UniformOutput', false)';
            elseif strcmpi(vartype, 'double')
                tmp_entry                               = cellfun(@(x) x.(id_object), ACMaterials, 'UniformOutput',false)';
                idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
                tmp_entry(idx_empty)                    = {NaN};
                table.(column_name)                     = cell2mat(tmp_entry);
            end
        end
end
end

