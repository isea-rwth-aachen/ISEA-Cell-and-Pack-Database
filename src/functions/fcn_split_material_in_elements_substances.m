function [elements,substances] = fcn_split_material_in_elements_substances(material)
%% function to split material in elements and substances
n_materials         = numel(material);
elements            = {};
substances          = {};
for i = 1 : n_materials
    if isa(material(i),'Element')
        name_to_add = convertStringsToChars(GetProperty(material(i),'Name'));
        names_elements                = arrayfun(@(x) convertStringsToChars(GetProperty(elements(x),'Name')),[1:numel(elements)],...
                                                'UniformOutput',false);
        if ismember(name_to_add,names_elements)
            continue;
        end
        elements                      = [elements material(i)];
    elseif isa(material(i), 'Substance')
        substances                    = [substances material(i)];
        sub_mat                       = material(i).Materials;
        [sub_elements,sub_substances] = fcn_split_material_in_elements_substances(sub_mat);
        if ~isempty(sub_elements)
            names_sub_elements            = arrayfun(@(x) convertStringsToChars(GetProperty(sub_elements(x),'Name')),[1:numel(sub_elements)],...
                                                'UniformOutput',false);
            names_elements                = arrayfun(@(x) convertStringsToChars(GetProperty(elements(x),'Name')),[1:numel(elements)],...
                                                'UniformOutput',false);
            idx_exist                     = ismember(names_sub_elements,names_elements);
            elements                      = [elements sub_elements(~idx_exist)];
        end
        if ~isempty(sub_substances)
            names_sub_substances          = arrayfun(@(x) convertStringsToChars(GetProperty(sub_substances(x),'Name')),[1:numel(sub_substances)],...
                                                'UniformOutput',false);
            names_substances              = arrayfun(@(x) convertStringsToChars(GetProperty(substances(x),'Name')),[1:numel(substances)],...
                                                'UniformOutput',false);
            idx_exist                     = ismember(names_sub_substances,names_substances);
            substances                    = [substances sub_substances(~idx_exist)];
        end
    else
        warning('Incorrect data type!');
    end
end
end