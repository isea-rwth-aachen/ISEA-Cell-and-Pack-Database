function clb_plotCell_MainTab(app,event)
%% callback function for button plot cell pushed at the main tab
global add_Cell;
fcn_busyLamp(app,'busy','BusyMainLamp');
if exist('event','var')
    add_Cell        = fcn_get_Cell_object(app,event);
else
    add_Cell        = fcn_get_Cell_object(app);
end
if isempty(add_Cell)
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
type            = app.SwitchOCVMainCell.Value;
if ~app.OwnfigureCheckBox.Value
    %% deactivate label representation
    app.CapacityLabel.Visible                   = false;
    app.VolumeLabel.Visible                     = false;
    app.WeightLabel.Visible                     = false;
    app.InternalResistanceLabel.Visible         = false;
    app.GravEnergyDensityLabel.Visible          = false;
    app.VolEnergyDensityLabel.Visible           = false;
    app.PowerLabel.Visible                      = false;
    app.GravPowerDensityLabel.Visible           = false;
    app.VolPowerDensityLabel.Visible            = false;
    app.NomDisVoltageLabel.Visible              = false;
    app.NomChaVoltageLabel.Visible              = false;
    app.TypeCell.Visible                        = false;
    app.DynamicCellInformationPanel.Title       = 'Graphical representation of the cell';
    %% activate axes
    app.OCVMainUIAxes.Visible                   = true;
    app.HousingMainUIAxes.Visible               = true;
    %% plot electrode stack
    electrode_stack                             = GetProperty(add_Cell, 'ElectrodeStack');
    fcn_plot_ElectrodeStacks(app,electrode_stack,[],[],'OCVMainUIAxes',type);
    %% plot housing
    housing                                     = GetProperty(add_Cell, 'Housing');
    fcn_plot_Housings(app,{housing},'HousingMainUIAxes');
else
    %% plot electrode stack
    electrode_stack                             = GetProperty(add_Cell, 'ElectrodeStack');
    fcn_plot_ElectrodeStacks(app,electrode_stack,[],[],[],type,add_Cell);
    %% plot housing
    housing                                     = GetProperty(add_Cell, 'Housing');
    fcn_plot_Housings(app,{housing},[],[],add_Cell);
    %% plot weight distribution
    fcn_plot_weightDistribution(app,add_Cell);
end
fcn_busyLamp(app,'ready','BusyMainLamp');
end