function table = fcn_write_columne_of_table_global(id_object,vartype,column_name,table,objects)
%% function to write the individual columns of the table 
%% init
n_Objects                                   = numel(objects);
if ~isa(objects,'cell')
   objects                                  = arrayfun(@(x) {objects(x)}, (1:numel(objects))); 
end
%% case destinction
switch column_name
    case {'Edit' 'Select' 'Vary' 'Is Anode' 'Is Cathode' 'Use for conductivity' 'Use for diffusion' 'Use for reaction rate' 'Use for OCV'}
        table.(column_name)                         = false(n_Objects,1);
    case {'Elements' 'Transfer Material'}
        % Determine subordinate elements
        sub_materials                               = cellfun(@(x) x.(id_object),objects,'UniformOutput',false);
        [sub_elements,~]                            = cellfun(@(x) fcn_split_material_in_elements_substances(x), sub_materials,'UniformOutput',false);
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), objects, 'UniformOutput', false))) == n_Objects
            table.Elements                              = strings(n_Objects,1);
        else
            tmp_names                                   = cellfun(@(x) arrayfun(@(y) convertStringsToChars(GetProperty((x(y)),'Name')), (1:numel(x)),'UniformOutput',false),...
                                                            sub_elements,'UniformOutput',false);
            table.(column_name)                         = cellfun(@(x) strjoin(x,', '),tmp_names, 'UniformOutput', false)';
        end
    case {'Active Material' 'Conductive additive' 'Binder' 'Conductive salt' 'Coating' 'Current collector' 'Anode' 'Cathode' 'Separator' 'Electrolyte' 'Component'}
        try
            name_objects                                    = cellfun(@(x) convertStringsToChars(GetProperty(GetProperty(x,id_object),'Name')),objects,'UniformOutput',false);
        catch
            id_object_type                                  = cellfun(@isobject,objects);
            name_objects(1,id_object_type)                  = cellfun(@(x) convertStringsToChars(GetProperty(GetProperty(x,id_object),'Name')),objects(id_object_type),'UniformOutput',false);
            name_objects(1,~id_object_type)                 = cellfun(@(x) convertStringsToChars(GetProperty(x,id_object)),objects(~id_object_type),'UniformOutput',false);
        end
        table.(column_name)                             = name_objects';
    case {'Solvents' 'Materials' 'Housing' 'Electrode stack' 'Transfer material'}
        name_objects                                    = cellfun(@(x) join(arrayfun(@(y) convertStringsToChars(GetProperty(y,'Name')),GetProperty(x,id_object),'UniformOutput',false), ', '),...
                                                            objects,'UniformOutput',false);
        table.(column_name)                             = [name_objects{:}]';
    case {'Weight solvents' 'Temperature vector' 'Weight material' 'Dimensions' 'Tab dimensions' 'Coating dimension' 'Simulated temperature' 'Simulated SOC' 'Sim. temps.' 'Sim. SOCs' 'Temperature', 'SOCs'}
        tmp_entry                                       = cellfun(@(x) x.(id_object), objects, 'UniformOutput',false)';
        idx_empty                                       = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
        tmp_entry(idx_empty)                            = {NaN};
        table.(column_name)                             = cellfun(@(x) mat2str(x,3), tmp_entry,'UniformOutput', false);
    case  {'Active material anode' 'Active material cathode'}
        expressions                                     = arrayfun(@(x) ['objects{' num2str(x) '}.' id_object],(1:numel(objects)),'UniformOutput',false);
        name_objects                                    = cellfun(@eval,expressions,'UniformOutput',false);
        name_objects                                    = cellfun(@convertStringsToChars,name_objects,'UniformOutput',false);
        table.(column_name)                             = name_objects';
    case {'Conductivity' 'Diffusion' 'Reaction rate' 'OCV'}
        field_exist                                     = cellfun(@(x) isprop(x,id_object) & ~isempty(GetProperty(x,id_object)),objects);
        names_arrhenius                                 = cell(numel(objects),1);
        existing_names                                  = cellfun(@(x) convertStringsToChars(x.(id_object).Name),objects(field_exist),'UniformOutput',false);
        names_arrhenius(~field_exist)                   = {'None'};
        names_arrhenius(field_exist)                    = existing_names;
        table.(column_name)                             = names_arrhenius;
    case {'EIS frequencies'}
        min_freq                                        = cellfun(@(x) min(x.(id_object)),objects);
        max_freq                                        = cellfun(@(x) max(x.(id_object)),objects);
        step_freq                                       = cell2mat(cellfun(@(x) min(diff(log10(x.(id_object)))),objects,'UniformOutput', false));
        string_freq                                     = arrayfun(@(x) ['10^(' num2str(log10(min_freq(x))), ':', num2str(step_freq(x)),':', num2str(log10(max_freq(x))), ')'], (1 : numel(objects)),'UniformOutput', false);
        table.(column_name)                             = string_freq';
    case {'Expression'}
        id_double                                       = cellfun(@(x) isnumeric(x.(id_object)),objects);
        id_struct                                       = cellfun(@(x) isstruct(x.(id_object)),objects);
        temp_strings(id_double)                         = cellfun(@(x) num2str(x.(id_object)),objects(id_double),'UniformOutput',false);
        temp_strings(id_struct)                         = {'struct'};
        table.(column_name)                             = temp_strings';
    case {'Modi(i)' 'Eliminated processes'}
        temp_strings                                    = id_object;
        id_modii                                        = cellfun(@(x) cell2mat(cellfun(@(y) x.(y),temp_strings,'UniformOutput',false)),objects,'UniformOutput',false);
        column_text                                     = cellfun(@(x) strjoin(temp_strings(x),', '),id_modii,'UniformOutput',false);
        table.(column_name)                             = column_text';
    otherwise
        if sum(cell2mat(cellfun(@(x) isempty(x.(id_object)), objects, 'UniformOutput', false))) == n_Objects
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = strings(n_Objects,1);
            else
                table.(column_name)                             = zeros(n_Objects,1);
            end
        else
            if strcmpi(vartype, 'string') 
                table.(column_name)                             = cellfun(@(x) convertStringsToChars(x.(id_object)),objects,'UniformOutput', false)';
            elseif strcmpi(vartype, 'double')
                tmp_entry                               = cellfun(@(x) x.(id_object), objects, 'UniformOutput',false)';
                idx_empty                               = cell2mat(cellfun(@isempty ,tmp_entry,'UniformOutput',false));
                tmp_entry(idx_empty)                    = {NaN};
                table.(column_name)                     = cell2mat(tmp_entry);
            elseif strcmpi(vartype, 'logical')
                table.(column_name)                     = cellfun(@(x) logical(x.(id_object)),objects,'UniformOutput', false)';
            elseif strcmpi(vartype, 'datetime')
                table.(column_name)                     = cellfun(@(x) x.(id_object),objects,'UniformOutput', false)';
            end
        end
end
end