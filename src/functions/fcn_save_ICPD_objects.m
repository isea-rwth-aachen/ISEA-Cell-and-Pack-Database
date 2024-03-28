function fcn_save_ICPD_objects(app,objects_to_save,flag_overwrite)
%% function for saving ICPD objects to the database
%% init
if nargin < 3
    flag_overwrite      = false;
end
n_data              = numel(objects_to_save);
if isempty(objects_to_save)
    return;
elseif strcmp(underlyingType(objects_to_save),'cell')
    temp_data_types     = cellfun(@(x) underlyingType(x),objects_to_save,'UniformOutput',false);
    
    if all(contains(temp_data_types, 'Housing'))
        data_type           = {'Housing'};
        names_data          = cellfun(@(x) convertStringsToChars(GetProperty(x,'Name')),objects_to_save,'UniformOutput',false);
    else
        data_type           = temp_data_types;
        names_data          = cellfun(@(x) convertStringsToChars(GetProperty(x,'Name')),objects_to_save,'UniformOutput',false);
    end
else
    data_type           = unique(arrayfun(@(x) underlyingType(objects_to_save(x)),(1:n_data),'UniformOutput',false));
    names_data          = arrayfun(@(x) convertStringsToChars(GetProperty(objects_to_save(x),'Name')),(1:n_data),'UniformOutput',false);    
end
%% check if objects are not the same type
if numel(data_type) > 1
    ids_types           = cellfun(@(x) strcmpi(x,cellfun(@(y) underlyingType(y),objects_to_save,'UniformOutput',false)),temp_data_types,'UniformOutput',false);
    object_per_type     = arrayfun(@(x) objects_to_save(ids_types{x}),(1:numel(ids_types)),'UniformOutput',false);
    object_per_type     = cellfun(@(x) [x{:}],object_per_type,'UniformOutput',false);
    cellfun(@(x) fcn_save_ICPD_objects(app,x,true),object_per_type);
    return;
end
%% check database folder
if isempty(app.path_database) || ~isfolder(app.path_database)
    path_database       = uigetdir(pwd,'Select database path');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if ischar(path_database) && isfolder(path_database)
        return;
    else
        app.path_database   = path_database;
    end
end
%% get file names
if strcmp(data_type, 'OCV')
    folder_name             = {'OCV'};
elseif strcmp(data_type, 'Arrhenius')
    folder_name             = {'Arrhenius'};
else
    folder_name             = strcat(data_type,'s');
end
if ~isfolder(fullfile(app.path_database, folder_name))
    mkdir(cell2mat(fullfile(app.path_database, folder_name)));
end
data_save_names         = cellfun(@(x) [x,'.mat'],names_data,'UniformOutput',false);
%% check for existing files
if ~flag_overwrite
    existing_data           = dir(cell2mat(fullfile(app.path_database, folder_name)));
    data_id                 = (1 : size(existing_data,1))';
    is_mat_file             = arrayfun(@(x) contains(existing_data(x).name, '.mat'),data_id);
    mat_file_name           = arrayfun(@(x) existing_data(x).name, data_id(is_mat_file), 'UniformOutput', false); 
    if ~isempty(mat_file_name)
        [idx_exist,~]           = ismember(data_save_names,mat_file_name);
    else
        idx_exist               = false(n_data,1);
    end
    if isempty(data_save_names(~idx_exist))
        return;
    end
    data_save_names_left    = data_save_names(~idx_exist);
    objects_to_save_left    = objects_to_save(~idx_exist);
else
    data_save_names_left    = data_save_names;
    objects_to_save_left    = objects_to_save;
end
%% save objects
arrayfun(@(x) fcn_save_single_object(cell2mat(fullfile(app.path_database, folder_name, data_save_names_left(x))),objects_to_save_left(x)),(1:numel(data_save_names_left)));
end

function fcn_save_single_object(path,object)
if isa(object,'cell')
   object               = object{:}; 
end
name_object             = convertStringsToChars(GetProperty(object,'Name'));
save_var.(name_object)  = object;
save(path,'-struct','save_var');
end