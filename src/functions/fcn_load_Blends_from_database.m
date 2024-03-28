function Blends_array = fcn_load_Blends_from_database(app)
%% function to load blends from the database
%% check pathes
working_path                = app.working_directory;
path_database               = app.path_database;
if ~isempty(app.path_database)
    check_path                  = isfolder(fullfile(path_database,'Blends'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        if ~ischar(path_database)
            Blends_array                    = {};
            return;
        end
        path_Blends             = fullfile(path_database,'Blends');
    else
        path_Blends             = fullfile(path_database, 'Blends');
    end
elseif ~isempty(app.working_directory)
    check_path                  = isfolder(fullfile(working_path,'Database','Blends'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        if ~ischar(path_database)
            Blends_array                = {};
            return;
        end
        path_Blends             = fullfile(path_database,'Blends');
    else
        path_Blends             = fullfile(path_database, 'Database','Blends');
    end
else
    path_database = uigetdir('Select a database folder that contains blends data');
    if ~ischar(path_database)
        Blends_array                    = {};
        return;
    end
    path_Blends                 = fullfile(path_database,'Blends');
end
%% check for suitable files
temp_dir                    = dir(path_Blends);
data_id                     = (1 : size(temp_dir,1))';
is_mat_file                 = arrayfun(@(x)  contains(temp_dir(x).name, '.mat'),data_id);
mat_file_name               = arrayfun(@(x) temp_dir(x).name, data_id(is_mat_file), 'UniformOutput', false); 
%% load blends
Blends_array                = cellfun(@(x) fcn_load_Blends_from_matData(fullfile(path_Blends,x)), mat_file_name,'UniformOutput',false);
is_Blends                   = cell2mat(cellfun(@(x) isa(x,'Blend'), Blends_array,'UniformOutput',false));
Blends_array                = Blends_array(is_Blends)';
end

function blend = fcn_load_Blends_from_matData(path)
try
    load(path);
    base_expression         = "isa(X, 'Blend')";
    vars_workspace          = who;
    expression              = cellfun(@(x) strrep(base_expression, 'X', x), who);
    is_substance            = cellfun(@eval,expression);
    if any(is_substance)
        error('');
    end
    blend    = eval(vars_workspace{is_substance});
catch
   blend     = {}; 
end
end