function clb_load_Housing_from_database(app)
%% callback function for button load from database at housings tab
global global_housings;
Housings_array      = fcn_load_Housings_from_database(app);
if isempty(Housings_array)
    return;
end
global_housings               = [global_housings Housings_array];
end