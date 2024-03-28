function clb_change_para_to_vary_selection(app)
%% callback function for selected parameter and components to vary changed at the parameter variation tab at the main tab
%% init
fcn_busyLamp(app,'busy','BusyMainLamp');
base_cell               = app.CellParaVarDropDown.Value;
choose_para             = app.VaryParaListBox.Value;
if isempty(base_cell)
    fcn_change_visibility_table(app,'HousingParaVarTable','off');
    fcn_change_visibility_table(app,'ActiveMaterialParaVarTable','off');
    fcn_change_visibility_table(app,'ParaVarTable','off');
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
n_choosen_para          = numel(choose_para);
%% update table due to selection of parameters
if ~n_choosen_para
    fcn_change_visibility_table(app,'ParaVarTable','off');
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
if ~ismember('None',choose_para)
    fcn_update_ParaVarTable(app,choose_para);
end
fcn_change_visibility_table(app,'ParaVarTable','on');
fcn_busyLamp(app,'ready','BusyMainLamp');
end