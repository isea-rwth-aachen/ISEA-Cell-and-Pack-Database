function clb_calcPropCell_MainTab(app,event)
%% callback function for button calc properties pushed at the main tab
global add_Cell;
fcn_busyLamp(app,'busy','BusyMainLamp');
add_Cell        = fcn_get_Cell_object(app,event);
if isempty(add_Cell)
    return;
end
%% deactivate graphical representation
if numel(app.OCVMainUIAxes.Children)
    arrayfun(@(x) set(app.OCVMainUIAxes.Children(x), 'Visible', 'off'), (1:numel(app.OCVMainUIAxes.Children)));
    if isa(app.OCVMainUIAxes.Legend, 'matlab.graphics.illustration.Legend')
        set(app.OCVMainUIAxes.Legend, 'Visible', 'off');
    end
end
if numel(app.HousingMainUIAxes.Children)
    arrayfun(@(x) set(app.HousingMainUIAxes.Children(x), 'Visible', 'off'), (1:numel(app.HousingMainUIAxes.Children)));
    if isa(app.HousingMainUIAxes.Legend, 'matlab.graphics.illustration.Legend')
        set(app.HousingMainUIAxes.Legend, 'Visible', 'off');
    end
end
app.OCVMainUIAxes.Visible                   = false;
app.HousingMainUIAxes.Visible               = false;
app.DynamicCellInformationPanel.Title       = 'Properties of the new cell';
%% activate labels
app.CapacityLabel.Visible                   = true;
app.VolumeLabel.Visible                     = true;
app.WeightLabel.Visible                     = true;
app.InternalResistanceLabel.Visible         = true;
app.GravEnergyDensityLabel.Visible          = true;
app.VolEnergyDensityLabel.Visible           = true;
app.PowerLabel.Visible                      = true;
app.GravPowerDensityLabel.Visible           = true;
app.VolPowerDensityLabel.Visible            = true;
app.NomDisVoltageLabel.Visible              = true;
app.NomChaVoltageLabel.Visible              = true;
app.TypeCell.Visible                        = true;
%% change label text due to cell properties
fcn_update_properties_label_Cell(app);
fcn_busyLamp(app,'ready','BusyMainLamp');
end

