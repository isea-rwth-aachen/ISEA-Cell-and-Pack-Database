function clb_load_ACMaterial(app)
%% callback function for button load from database at Active Material tab
global global_ACMaterial;
ACMaterial_array                            = fcn_load_ACMaterial_from_database(app);
if isempty(ACMaterial_array)
    return;
end
ACMaterial_add                              = cellfun(@(x) x, ACMaterial_array); %convert in OCV object 
global_ACMaterial                           = [global_ACMaterial ACMaterial_add];
end

