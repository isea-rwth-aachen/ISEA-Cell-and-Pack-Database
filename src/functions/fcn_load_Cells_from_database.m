function [Cells_Data, Cells_array] = fcn_load_Cells_from_database(app)
%% function to load cells from the database
%% check pathes
working_path                = app.working_directory;
path_database               = app.path_database;
if ~isempty(app.path_database)
    check_path                  = isfolder(fullfile(path_database,'Cells'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        figure(app.ISEAcellpackdatabaseUIFigure);
        if ~ischar(path_database)
            Cells_Data                     = {};
            Cells_array                    = {};
            return;
        end
        path_Cells             = fullfile(path_database,'Cells');
    else
        path_Cells             = fullfile(path_database, 'Cells');
    end
elseif ~isempty(app.working_directory)
    check_path                  = isfolder(fullfile(working_path,'Database','Cells'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        figure(app.ISEAcellpackdatabaseUIFigure);
        if ~ischar(path_database)
            Cells_Data                 = {};
            Cells_array                = {};
            return;
        end
        path_Cells             = fullfile(path_database,'Cells');
    else
        path_Cells             = fullfile(path_database, 'Database','Cells');
    end
else
    path_database = uigetdir('Select a database folder that contains cells data');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if ~ischar(path_database)
        Cells_Data                     = {};
        Cells_array                    = {};
        return;
    end
    path_Cells                 = fullfile(path_database,'Cells');
end
%% check for suitable files
temp_dir                    = dir(path_Cells);
data_id                     = [1 : size(temp_dir,1)]';
is_mat_file                 = arrayfun(@(x)  contains(temp_dir(x).name, '.mat'),data_id);
mat_file_name               = arrayfun(@(x) temp_dir(x).name, data_id(is_mat_file), 'UniformOutput', false); 
%% load conductive salts
Cells_array           = cellfun(@(x) fcn_load_Cell_from_matData(fullfile(path_Cells,x)), mat_file_name,'UniformOutput',false);
is_Cell               = cell2mat(cellfun(@(x) isa(x,'Cell'), Cells_array,'UniformOutput',false));
Cells_array           = Cells_array(is_Cell)';
%% create conductive salts table
Cells_Data             = fcn_write_Cell_Table(app,Cells_array);
end

function cell = fcn_load_Cell_from_matData(path)
try
    load(path);
    base_expression         = "isa(X, 'Cell')";
    vars_workspace          = who;
    expression              = cellfun(@(x) strrep(base_expression, 'X', x), who);
    is_substance            = cellfun(@eval,expression);
        if any(is_substance)
        error('');
    end
    cell    = eval(vars_workspace{is_substance});
catch
    cell     = {}; 
end
end