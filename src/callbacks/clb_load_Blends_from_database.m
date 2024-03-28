function clb_load_Blends_from_database(app)
%% callback function for button load from database at conductive blends tab
global global_blends;
Blends_array                = fcn_load_Blends_from_database(app);
if isempty(Blends_array)
    return;
end
Blends_add                      = cellfun(@(x) x, Blends_array); %convert in conductive salts object 
global_blends                  = [global_blends Blends_add];
end