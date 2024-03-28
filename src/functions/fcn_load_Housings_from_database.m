function Housings_array = fcn_load_Housings_from_database(app)
%% function to load housing from the database
%% check pathes
working_path                = app.working_directory;
path_database               = app.path_database;
if ~isempty(app.path_database)
    check_path                  = isfolder(fullfile(path_database,'Housings'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        figure(app.ISEAcellpackdatabaseUIFigure);
    
        if ~ischar(path_database)
            Housings_array                    = {};
            return;
        end
        path_Housings             = fullfile(path_database,'Housings');
    else
        path_Housings             = fullfile(path_database, 'Housings');
    end
elseif ~isempty(app.working_directory)
    check_path                  = isfolder(fullfile(working_path,'Database','Housings'));
    if ~check_path
        path_database           = uigetdir(working_path,'Select a database folder.');
        figure(app.ISEAcellpackdatabaseUIFigure);
        if ~ischar(path_database)
            Housings_array                = {};
            return;
        end
        path_Housings             = fullfile(path_database,'Housings');
    else
        path_Housings             = fullfile(path_database, 'Database','Housings');
    end
else
    path_database = uigetdir('Select a database folder that contains separator data');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if ~ischar(path_database)
        Housings_array                    = {};
        return;
    end
    path_Housings                 = fullfile(path_database,'Housings');
end
%% check for suitable files
temp_dir                    = dir(path_Housings);
data_id                     = [1 : size(temp_dir,1)]';
is_mat_file                 = arrayfun(@(x)  contains(temp_dir(x).name, '.mat'),data_id);
mat_file_name               = arrayfun(@(x) temp_dir(x).name, data_id(is_mat_file), 'UniformOutput', false); 
%% load conductive salts
Housings_array           = cellfun(@(x) fcn_load_Housing_from_matData(fullfile(path_Housings,x)), mat_file_name,'UniformOutput',false);
is_Housing               = cell2mat(cellfun(@(x) isa(x,'Housing') | isa(x,'HousingPouch') | isa(x,'HousingCylindrical') | isa(x,'HousingGeneric') | isa(x,'HousingPrismatic')...
                            , Housings_array,'UniformOutput',false));
Housings_array           = Housings_array(is_Housing)';
end

function housing = fcn_load_Housing_from_matData(path)
try
    load(path);
    base_expression         = "isa(X,'Housing') | isa(X,'HousingPouch') | isa(X,'HousingCylindrical') | isa(X,'HousingGeneric') | isa(X,'HousingPrismatic')";
    vars_workspace          = who;
    expression              = cellfun(@(x) strrep(base_expression, 'X', x), who);
    is_substance            = cellfun(@eval,expression);
    if any(is_substance)
        error('');
    end
    housing    = eval(vars_workspace{is_substance});
catch
    housing     = {}; 
end
end