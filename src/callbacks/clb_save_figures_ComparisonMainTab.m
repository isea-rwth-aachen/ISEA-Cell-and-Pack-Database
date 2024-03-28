function clb_save_figures_ComparisonMainTab(app)
%% callback function for button save figures pushed at comparison panel at the main tab
fcn_busyLamp(app,'busy','BusyMainLamp');
if ~isempty(app.ComparisonOCVUIAxes.Children) && ~isempty(app.ComparisonHousingsUIAxes.Children) && ~isempty(app.ComparisonSpiderUIAxes.Children)
    fcn_save_figures(app.ComparisonOCVUIAxes,app.ComparisonHousingsUIAxes, app.ComparisonSpiderUIAxes,'Discharge_OCVs', '3D_representation', 'Spider_diagram');
end
fcn_busyLamp(app,'ready','BusyMainLamp');
end