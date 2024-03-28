function fcn_update_properties_label_Cell(app)
%% function for updating the exemplary properties labels at interface for adding a new cell
global add_Cell;

%capacity
capacity                                = GetProperty(add_Cell, 'Capacity');
app.CapacityLabel.Text                  = join(['Capacity: ' num2str(capacity) ' Ah']);

%Volume
volume                                  = GetProperty(add_Cell, 'Volume');
app.VolumeLabel.Text                    = join(['Volume: ' num2str(volume) ' cm³']);

%Weight
weight                                  = GetProperty(add_Cell, 'Weight');
app.WeightLabel.Text                    = join(['Weight: ' num2str(weight) ' g']);

%internal resistance
internal_resistance                     = GetProperty(add_Cell, 'InternalResistance');
app.InternalResistanceLabel.Text        = join(['Internal resistance: ' num2str(internal_resistance) ' mΩ']);

%Gravimetric energy density
grav_energy_density                     = GetProperty(add_Cell, 'GravEnergyDensity');
app.GravEnergyDensityLabel.Text         = join(['Gravimetric energy density: ' num2str(grav_energy_density) ' Wh/kg']);

%Volumetric energy density
vol_energy_density                      = GetProperty(add_Cell, 'VolEnergyDensity');
app.VolEnergyDensityLabel.Text          = join(['Volumetric energy density: ' num2str(vol_energy_density) ' Wh/l']);

%power
power                                   = GetProperty(add_Cell, 'Power');
app.PowerLabel.Text                     = join(['Power: ' num2str(power) ' W']);

%Gravimetric power density
grav_power_density                      = GetProperty(add_Cell, 'GravPowerDensity');
app.GravPowerDensityLabel.Text          = join(['Gravimetric power density: ' num2str(grav_power_density) ' W/kg']);

%Volumetric power density
vol_power_density                       = GetProperty(add_Cell, 'VolPowerDensity');
app.VolPowerDensityLabel.Text           = join(['Volumetric power density: ' num2str(vol_power_density) ' W/l']);

%nominal discharge voltage
nominal_discharge                       = GetProperty(add_Cell, 'NominalVoltage');
app.NomDisVoltageLabel.Text             = join(['Nominal discharge voltage: ' num2str(nominal_discharge) ' V']);

%nominal charge voltage
nominal_charge                          = GetProperty(add_Cell, 'NominalVoltageCha');
app.NomChaVoltageLabel.Text             = join(['Nominal charge voltage: ' num2str(nominal_charge) ' V']);

%type
type                                    = GetProperty(add_Cell, 'Type');
app.TypeCell.Text                       = join(['Type of the cell: ' type]);
end