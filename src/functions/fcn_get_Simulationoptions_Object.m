function  simulation_options = fcn_get_Simulationoptions_Object(app)
%% function for creating the simulation options object due to user input
%% init
simulation_options          = [];
%% get data from user input
ambient_temp                = app.AmbientTempField.Value;
cell_temp                   = app.CellTempField.Value;
soc                         = app.SOCField.Value;
switch app.ParticleTypeDropDown.Value
    case 'spherical'
        particle_type           = 'sphericalFDM';
    otherwise
end
particle_divison            = app.ParticleDivisionField.Value;
division                    = app.DivisionField.Value;
%% generate simulation options object
try
    simulation_options          = Simulationsoption('temp',ambient_temp,cell_temp,soc,particle_type,particle_divison,division);
catch ME
    msgbox(ME.message,'Error in create simulation options object', 'error');
    return;
end
end

