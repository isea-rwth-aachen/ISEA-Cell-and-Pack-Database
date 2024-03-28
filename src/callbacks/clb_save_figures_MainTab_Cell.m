function clb_save_figures_MainTab_Cell(app)
%% callback function for button save figures pushed at graphical representation panel at the main tab
fcn_busyLamp(app,'busy','BusyMainLamp');
fcn_save_figures(app.OCVMainUIAxes,app.HousingMainUIAxes,'OCV', '3D_representation');
fcn_busyLamp(app,'ready','BusyMainLamp');
end

