function clb_baseCell_paraVar_changed(app)
%% callback function for base cell changed due to user input at the parameter variation tab at the main tab
fcn_busyLamp(app, 'busy', 'BusyMainLamp');
fcn_init_paraVariationTab(app,true);
app.VaryParaListBox.Value   = {'None'};
clb_change_para_to_vary_selection(app);
fcn_busyLamp(app, 'ready', 'BusyMainLamp');
end