function housing_table = fcn_write_HousingTable(app,housing_add_cell)
%% function for creation of a separators table from the variable housing_add_cell
%check for right input data
if isa(housing_add_cell,'Housing') || isa(housing_add_cell,'HousingPouch') || isa(housing_add_cell,'HousingCylindrical') || isa(housing_add_cell,'HousingGeneric') || isa(housing_add_cell,'HousingPrismatic')
    housing_add_cell                        = arrayfun(@(x) {housing_add_cell(x)}, (1:numel(housing_add_cell)));
end
%% Initialize table
column_names                                = app.HousingsTable.ColumnName;
vartypes                                    = app.vartypes_HousingTable;
variable_units                              = app.units_vars_HousingTable;
n_column                                    = length(column_names);
n_Housings                                  = numel(housing_add_cell);
if numel(vartypes) ~= n_column && n_column ~= numel(variable_units)
   error('Check the name of the expected columns, the data types of the columns of the housing table and the specified units of the columns of the housing table!'); 
end
housing_table                             = table('Size', [n_Housings n_column], 'VariableTypes', vartypes);
housing_table.Properties.VariableNames    = column_names;
rownames                                  = cellfun(@(x) mat2str(x.Name), housing_add_cell, 'UniformOutput', false);
rownames                                  = cellfun(@(x) strrep(x,'"',''), rownames, 'UniformOutput', false);
housing_table.Properties.RowNames         = rownames;
housing_table.Properties.Description      = 'This table contains all available housings.';
housing_table.Properties.VariableUnits    = variable_units;
%% write the table
housing_table.Name                         = rownames';
for i = 2: n_column
    housing_table                          = fcn_write_columne_of_table(app,housing_table,i,housing_add_cell);
end
end

function table = fcn_write_columne_of_table(app,table,id,housings)
%% function to write the individual columns of the table 
id_object                                   = app.id_class_to_HousingTable{id};
vartype                                     = app.vartypes_HousingTable{id};
column_name                                 = app.HousingsTable.ColumnName{id};
n_Housings                                  = numel(housings);
switch column_name
    case 'Edit'
        table.("Edit")                          = false(n_Housings,1);
    case {'Elements' 'Transfer Material'}
        % Determine subordinate elements
        sub_materials                               = cellfun(@(x) x.(id_object),housings,'UniformOutput',false);
        [sub_elements,~]                            = cellfun(@(x) fcn_split_material_in_elements_substances(x), sub_materials,'UniformOutput',false);
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), housings, 'UniformOutput', false))) == n_Housings
            table.Elements                              = strings(n_Housings,1);
        else
            tmp_names                                   = cellfun(@(x) arrayfun(@(y) convertStringsToChars(GetProperty((x(y)),'Name')), (1:numel(x)),'UniformOutput',false),...
                                                            sub_elements,'UniformOutput',false);
            table.(column_name)                         = cellfun(@(x) strjoin(x,', '),tmp_names, 'UniformOutput', false)';
        end
    case {'Active Material' 'Conductive additive' 'Binder' 'Conductive salt' 'Coating' 'Current collector'}
        name_objects                                    = cellfun(@(x) convertStringsToChars(GetProperty(GetProperty(x,id_object),'Name')),housings,'UniformOutput',false);
        table.(column_name)                             = name_objects';
    case {'Solvents' 'Materials' 'Material pos. pole' 'Material neg. pole'}
        name_objects                                    = cellfun(@(x) join(arrayfun(@(y) convertStringsToChars(GetProperty(y,'Name')),GetProperty(x,id_object),'UniformOutput',false), ', '),...
                                                            housings,'UniformOutput',false);
        idx_empty                                       = cell2mat(cellfun(@isempty ,name_objects,'UniformOutput',false));
        name_objects(idx_empty)                         = {NaN};
        table.(column_name)                             = [name_objects{:}]';
    case {'Foil materials'}
        name_materials                          = cell(numel(housings),1);
        idx_pouch                               = cell2mat(cellfun(@(x) isa(x,'HousingPouch'),housings,'UniformOutput', false));
        name_materials(idx_pouch)               = cellfun(@(x) cell2mat(join(cellfun(@(y) convertStringsToChars(GetProperty(y, 'Name')),GetProperty(x, id_object),'UniformOutput',false),', ')),housings(idx_pouch),'UniformOutput',false);
        name_materials(~idx_pouch)              = {NaN};
        table.(column_name)                     = name_materials;
    case {'Weight solvents' 'Temperature vector' 'Weight material' 'Dimensions' 'Tab dimensions' 'Coating dimension' 'Av. stack dimensions'}
        tmp_entry                               = cellfun(@(x) x.(id_object), housings, 'UniformOutput',false)';
        idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
        tmp_entry(idx_empty)                    = {NaN};
        table.(column_name)                     = cellfun(@(x) mat2str(x,3), tmp_entry,'UniformOutput', false);
    case 'Foil thickness'
        tmp_entry                               = cell(numel(housings),1);
        idx_pouch                               = cell2mat(cellfun(@(x) isa(x,'HousingPouch'),housings,'UniformOutput', false));
        tmp_entry(idx_pouch)                    = cellfun(@(x) GetProperty(x, id_object),housings(idx_pouch),'UniformOutput',false)';
        table.(column_name)                     = cellfun(@(x) mat2str(x,3), tmp_entry,'UniformOutput', false);
    case 'Foil weight'
        tmp_entry                               = NaN(numel(housings),1);
        idx_pouch                               = cell2mat(cellfun(@(x) isa(x,'HousingPouch'),housings,'UniformOutput', false));
        tmp_entry(idx_pouch)                    = cell2mat(cellfun(@(x) GetProperty(x, id_object),housings(idx_pouch),'UniformOutput',false))';
        table.(column_name)                     = tmp_entry;
    otherwise
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), housings, 'UniformOutput', false))) == n_Housings
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = strings(n_Housings,1);
            else
                table.(column_name)                             = zeros(n_Housings,1);
            end
        else
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = cellfun(@(x) convertStringsToChars(x.(id_object)),housings,'UniformOutput', false)';
            elseif strcmpi(vartype, 'double')
                tmp_entry                               = cellfun(@(x) x.(id_object), housings, 'UniformOutput',false)';
                idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
                tmp_entry(idx_empty)                    = {NaN};
                table.(column_name)                     = cell2mat(tmp_entry);
            end
        end
end
end