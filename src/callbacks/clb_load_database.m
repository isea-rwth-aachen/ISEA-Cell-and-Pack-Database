function clb_load_database(app)
%% callback function for button load database pushed at main tab
fcn_busyLamp(app,'busy','BusyMainLamp');
if isempty(app.path_database)
    path_database       = uigetdir(app.working_directory,'Please select a database folder');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if ischar(path_database) && isfolder(path_database)
        app.path_database                   = path_database;
        app.EditFieldDatabasePath.Value     = path_database;
    else
        return;
    end
end
fcn_load_database(app);
%% update button, dropdowns, lamps
fcn_update_CellCompareTable(app);
fcn_busyLamp(app,'ready','BusyMainLamp');
end