function ACMaterial_array = fcn_load_ACMaterial_from_database(app)
%% function to load active material from the database
%% check pathes
working_path                = app.working_directory;
path_database               = app.path_database;
if ~isempty(app.path_database)
    check_path                  = isfolder(fullfile(path_database,'ActiveMaterials'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        figure(app.ISEAcellpackdatabaseUIFigure);
        if ~ischar(path_database)
            ACMaterial_array                    = {};
            return;
        end
        path_ACMaterial             = fullfile(path_database,'ActiveMaterials');
    else
        path_ACMaterial             = fullfile(path_database, 'ActiveMaterials');
    end
elseif ~isempty(app.working_directory)
    check_path                  = isfolder(fullfile(working_path,'Database','ActiveMaterials'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        figure(app.ISEAcellpackdatabaseUIFigure);
        if ~ischar(path_database)
            ACMaterial_array                = {};
            return;
        end
        path_ACMaterial           = fullfile(path_database,'ActiveMaterials');
    else
        path_ACMaterial           = fullfile(path_database, 'Database','ActiveMaterials');
    end
else
    path_database = uigetdir('Select a database folder that contains active material data');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if ~ischar(path_database)
        ACMaterial_array                    = {};
        return;
    end
    path_ACMaterial                = fullfile(path_database,'ActiveMaterials');
end
%% check for suitable files
temp_dir                    = dir(path_ACMaterial);
data_id                     = [1 : size(temp_dir,1)]';
is_mat_file                 = arrayfun(@(x)  contains(temp_dir(x).name, '.mat'),data_id);
mat_file_name               = arrayfun(@(x) temp_dir(x).name, data_id(is_mat_file), 'UniformOutput', false); 
%% load active material
ACMaterial_array            = cellfun(@(x) fcn_load_ACMaterial_from_matData(fullfile(path_ACMaterial,x)), mat_file_name,'UniformOutput',false);
is_ACMaterial               = cell2mat(cellfun(@(x) isa(x,'ActiveMaterial'), ACMaterial_array,'UniformOutput',false));
ACMaterial_array            = ACMaterial_array(is_ACMaterial)';
end

function ACMaterial = fcn_load_ACMaterial_from_matData(path)
try
    load(path);
    base_expression         = "isa(X, 'ActiveMaterial')";
    vars_workspace          = who;
    expression              = cellfun(@(x) strrep(base_expression, 'X', x), who);
    is_substance            = cellfun(@eval,expression);
    if any(is_substance)
        error('');
    end
    ACMaterial                 = eval(vars_workspace{is_substance});
catch
   ACMaterial = {}; 
end
end