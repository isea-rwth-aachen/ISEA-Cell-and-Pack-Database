function [YAML_struct,parameter_log]             = fcn_get_yaml_struct_of_cell(app,cell_struct,SimulationOptions,information_text_name)
%% function for generating a yaml struct for PCM Simulation 
flag_GUI_information    = false;
if exist('app','var') && ~isempty(app)
    flag_GUI_information = true;
end
%% Initialization parameter log
parameter_log           = {};
%% Initialization of YAML-Struct
YAML_struct.Parameter = [];
YAML_struct.Grid = [];
NumberOfElements = isprop(cell_struct.ElectrodeStack,'Cathode') + isprop(cell_struct.ElectrodeStack,'Anode') + isprop(cell_struct.ElectrodeStack,'Separator');
counter = 1;
if isprop(cell_struct.ElectrodeStack,'Cathode')
   Cathode_index = counter;
   counter = counter + 1;
end
if isprop(cell_struct.ElectrodeStack,'Separator')
   Separator_index = counter;
   counter = counter + 1;
end
if isprop(cell_struct.ElectrodeStack,'Anode')
   Anode_index = counter;
   counter = counter + 1;
end
if ~(exist('information_text_name','var') && isfield(app,information_text_name)) && flag_GUI_information
    information_text_name       = 'ExportInformationTextArea';
    app.(information_text_name).Value         = [app.(information_text_name).Value; 'Start of YML-File creation'];
    app.(information_text_name).Value         = [app.(information_text_name).Value; '-----------------------------------------------------------------------------------------------------------'];
end
YAML_struct.VolumeElements = cell(1,NumberOfElements);
YAML_struct.Terminal = [];
%%Terminal
ThermalConductivityCaseAmbient              = 20; %W/(m²*K) %%!!!!!!!!!HARD CODED!!!!!!!!!!
%% get Terminal positions
YAML_struct.Terminal.Positive.VolumeElementsToConnect{1,1}.X = 0;
YAML_struct.Terminal.Positive.VolumeElementsToConnect{1,1}.Y = [];
YAML_struct.Terminal.Positive.VolumeElementsToConnect{1,1}.Z = [];
YAML_struct.Terminal.Positive.Resistance = 0;
if isprop(SimulationOptions,'Division')
    YAML_struct.Terminal.Negative.VolumeElementsToConnect{1,1}.X = SimulationOptions.Division * 3 - 1; % multiplite with three because three volumen typs (anode, separator, cathode)
else
    YAML_struct.Terminal.Negative.VolumeElementsToConnect{1,1}.X = 10 * 3 - 1;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value; 'Field "Division" in SimulationOptions object is empty'];
    end
end
YAML_struct.Terminal.Negative.VolumeElementsToConnect{1,1}.Y = [];
YAML_struct.Terminal.Negative.VolumeElementsToConnect{1,1}.Z = [];
YAML_struct.Terminal.Negative.Resistance = 0;
%% check simulation options
YAML_struct.PulsProfilePath                     = 'DEFAULT PULS PROFILE PATH';
%% Grid cell
if isprop(cell_struct.ElectrodeStack,'Cathode') && ~isempty(cell_struct.ElectrodeStack.Cathode)
    YAML_struct.Grid.X{1,Cathode_index}.Identifier = 'Kathode';
    if isprop(cell_struct.ElectrodeStack.Cathode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Cathode.CoatingDimensions)
        YAML_struct.Grid.X{1,Cathode_index}.Length = (0.5*(cell_struct.ElectrodeStack.Cathode.CoatingDimensions(1,3)+cell_struct.ElectrodeStack.Cathode.CoatingDimensions(2,3)))/1000;
    else
        YAML_struct.Grid.X{1,Cathode_index}.Length = 99999999999999999999;
        display_struct.CathodeCoatingDimensions         = 1;
        parameter_log                                   = [parameter_log; {'Coating thickness cathode' 'ElectrodeStack.Cathode.CoatingDimensions(:,3)'}];
        
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "CoatingDimensions" in Cathode is empty'];
        end
    end
    if isprop(SimulationOptions,'Division') && ~isempty(SimulationOptions.Division)    
        YAML_struct.Grid.X{1,Cathode_index}.Division = SimulationOptions.Division;
    else
        YAML_struct.Grid.X{1,Cathode_index}.Division = 10;
        display_struct.Division = 1;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Division" in SimulationOptions object is empty. Use default value 10.'];
        end
    end
    if isprop(SimulationOptions,'SubDivision') && ~isempty(SimulationOptions.SubDivision)
        YAML_struct.Grid.X{1,Cathode_index}.SubDivision = SimulationOptions.SubDivision;
    else
        YAML_struct.Grid.X{1,Cathode_index}.SubDivision = 1;
        display_struct.SubDivision = 1;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "SubDivision" in SimulationOptions object is empty. Use default value 1.'];
        end
    end
end
if isprop(cell_struct.ElectrodeStack,'Separator') && ~isempty(cell_struct.ElectrodeStack.Separator)
    YAML_struct.Grid.X{1,Separator_index}.Identifier = 'Separator';
    if isprop(cell_struct.ElectrodeStack.Separator,'Dimensions') && ~isempty(cell_struct.ElectrodeStack.Separator.Dimensions)
        YAML_struct.Grid.X{1,Separator_index}.Length = cell_struct.ElectrodeStack.Separator.Dimensions(1,3)/1000;
    else
        YAML_struct.Grid.X{1,Separator_index}.Length = 99999999999999999999;
        display_struct.SeparatorDimensions              = 1;
        parameter_log                                   = [parameter_log; {'Separator thickness' 'ElectrodeStack.Separator.Dimensions(1,3)'}];
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Dimensions" in Separator is empty'];
        end
    end
    if isprop(SimulationOptions,'Division') && ~isempty(SimulationOptions.Division)
        YAML_struct.Grid.X{1,Separator_index}.Division = SimulationOptions.Division;
    else
        YAML_struct.Grid.X{1,Separator_index}.Division = 10;
        if display_struct.Division == 0
            if flag_GUI_information
                app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Division" in SimulationOptions object is empty. Use default value 10.'];
            end
            display_struct.Division = 1;
        end
    end
    if isprop(SimulationOptions,'SubDivision') && ~isempty(SimulationOptions.SubDivision)
        YAML_struct.Grid.X{1,Separator_index}.SubDivision = SimulationOptions.SubDivision;
    else
        YAML_struct.Grid.X{1,Separator_index}.SubDivision = 1;
        if display_struct.SubDivision == 0
            if flag_GUI_information
                app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "SubDivision" in SimulationOptions object is empty. Use default value 1.'];
            end
            display_struct.SubDivision = 1;
        end
    end
end
if isprop(cell_struct.ElectrodeStack,'Anode') && ~isempty(cell_struct.ElectrodeStack.Anode)
    YAML_struct.Grid.X{1,Anode_index}.Identifier = 'Anode';
    if isprop(cell_struct.ElectrodeStack.Cathode,'CoatingDimensions') && ~isempty(cell_struct.ElectrodeStack.Anode.CoatingDimensions)
        YAML_struct.Grid.X{1,Anode_index}.Length = (0.5*(cell_struct.ElectrodeStack.Anode.CoatingDimensions(1,3)+cell_struct.ElectrodeStack.Anode.CoatingDimensions(2,3)))/1000;
    else
        YAML_struct.Grid.X{1,Anode_index}.Length        = 99999999999999999999;
        display_struct.AnodeCoatingDimensions           = 1;
        parameter_log                                   = [parameter_log; {'Coating thickness anode' 'ElectrodeStack.Anode.CoatingDimensions(:,3)'}];
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "CoatingDimensions" in Anode is empty'];
        end
    end
    if isprop(SimulationOptions,'Division') && ~isempty(SimulationOptions.Division)
        YAML_struct.Grid.X{1,Anode_index}.Division = SimulationOptions.Division;
    else
        YAML_struct.Grid.X{1,Anode_index}.Division = 10;
        if display_struct.Division == 0
            if flag_GUI_information
                app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Division" in SimulationOptions object is empty. Use default value 10.'];
            end
            display_struct.Division = 1;
        end
    end
    if isprop(SimulationOptions,'SubDivision') && ~isempty(SimulationOptions.SubDivision)
        YAML_struct.Grid.X{1,Anode_index}.SubDivision = SimulationOptions.SubDivision;
    else
        YAML_struct.Grid.X{1,Anode_index}.SubDivision = 1;
        if display_struct.SubDivision == 0
            if flag_GUI_information
                app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "SubDivision" in SimulationOptions object is empty. Use default value 1.'];
            end
            display_struct.SubDivision = 1;
        end
    end
end
% Y-Coordinate
if isprop(cell_struct.ElectrodeStack.Separator,'Dimensions')  && ~isempty(cell_struct.ElectrodeStack.Separator.Dimensions)
     Separator_Y = cell_struct.ElectrodeStack.Separator.Dimensions(1,1)/1000;
else
     Separator_Y = Inf;
end    
if isprop(cell_struct.ElectrodeStack.Cathode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Cathode.CoatingDimensions)
    Cathode_Y = (0.5*(cell_struct.ElectrodeStack.Cathode.CoatingDimensions(1,1)+cell_struct.ElectrodeStack.Cathode.CoatingDimensions(2,1)))/1000;
else
    Cathode_Y = Inf;
end
if isprop(cell_struct.ElectrodeStack.Anode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Anode.CoatingDimensions)
     Anode_Y = (0.5*(cell_struct.ElectrodeStack.Anode.CoatingDimensions(1,1)+cell_struct.ElectrodeStack.Anode.CoatingDimensions(2,1)))/1000;
else
     Anode_Y = Inf;
end   
YAML_struct.Grid.Y{1,1}.SubGrid = min([Anode_Y,Cathode_Y,Separator_Y]);
if  min([Anode_Y,Cathode_Y,Separator_Y]) == Inf
    YAML_struct.Grid.Y{1,1}.Length = 99999999999999999999;
    if display_struct.CathodeCoatingDimensions == 0
        display_struct.CathodeCoatingDimensions = 1;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Problems with Grid Y Dimension'];
        end
    end
end
YAML_struct.Grid.Z{1,1}.Division = 1;
YAML_struct.Grid.Z{1,1}.SubDivision = 1;
if isprop(cell_struct.ElectrodeStack.Separator,'Dimensions')  && ~isempty(cell_struct.ElectrodeStack.Separator.Dimensions) && ...
        isprop(cell_struct.ElectrodeStack,'NrOfSeparators')  && ~isempty(cell_struct.ElectrodeStack.NrOfSeparators)
     Separator_Z = cell_struct.ElectrodeStack.NrOfSeparators*cell_struct.ElectrodeStack.Separator.Dimensions(1,2)/1000;
else
    if isprop(cell_struct.ElectrodeStack.Separator,'Dimensions')  && ~isempty(cell_struct.ElectrodeStack.Separator.Dimensions) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Dimensions" in Separator object is empty'];
    end
    if isprop(cell_struct.ElectrodeStack,'NrOfSeparators')  && ~isempty(cell_struct.ElectrodeStack.NrOfSeparators) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "NrOfSeparators" in ElectrodeStack object is empty'];
    end
    Separator_Z = Inf;
end    
if isprop(cell_struct.ElectrodeStack.Cathode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Cathode.CoatingDimensions) && ...
        isprop(cell_struct.ElectrodeStack,'NrOfCathodes')  && ~isempty(cell_struct.ElectrodeStack.NrOfCathodes)
    Cathode_Z = cell_struct.ElectrodeStack.NrOfCathodes*(cell_struct.ElectrodeStack.Cathode.CoatingDimensions(1,2) + cell_struct.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1,2))/1000;
else
    if isprop(cell_struct.ElectrodeStack.Cathode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Cathode.CoatingDimensions) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "CoatingDimensions" in Cathode object is empty'];
    end
    if isprop(cell_struct.ElectrodeStack,'NrOfCathodes')  && ~isempty(cell_struct.ElectrodeStack.NrOfCathodes) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "NrOfCathodes" in ElectrodeStack object is empty'];
    end
    Cathode_Z = Inf;
end
if isprop(cell_struct.ElectrodeStack.Anode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Anode.CoatingDimensions) && ...
        isprop(cell_struct.ElectrodeStack,'NrOfAnodes')  && ~isempty(cell_struct.ElectrodeStack.NrOfAnodes)
    Anode_Z = cell_struct.ElectrodeStack.NrOfAnodes*(cell_struct.ElectrodeStack.Anode.CoatingDimensions(1,2) + cell_struct.ElectrodeStack.Anode.CurrentCollector.Dimensions(1,2))/1000;
else
    if isprop(cell_struct.ElectrodeStack.Anode,'CoatingDimensions')  && ~isempty(cell_struct.ElectrodeStack.Anode.CoatingDimensions) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "CoatingDimensions" in Anode object is empty'];
    end
    if isprop(cell_struct.ElectrodeStack,'NrOfAnodes')  && ~isempty(cell_struct.ElectrodeStack.NrOfAnodes) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "NrOfAnodes" in ElectrodeStack object is empty'];
    end
     Anode_Z = Inf;
end   
if isprop(cell_struct.ElectrodeStack,'NrOfJellyRolls')  && ~isempty(cell_struct.ElectrodeStack.NrOfJellyRolls)
    YAML_struct.Grid.Z{1,1}.Length = min([Anode_Z,Cathode_Z,Separator_Z]) * cell_struct.ElectrodeStack.NrOfJellyRolls;
else
    YAML_struct.Grid.Z{1,1}.Length = min([Anode_Z,Cathode_Z,Separator_Z]);
end
if  min([Anode_Z,Cathode_Z,Separator_Z]) == Inf
    YAML_struct.Grid.Z{1,1}.Length = 99999999999999999999;
    if display_struct.CathodeCoatingDimensions == 0
        display_struct.CathodeCoatingDimensions = 1;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Problems with Grid Z Dimension'];
        end
    end
end
%% Parameter cell and simulation
if isprop(SimulationOptions,'celltemperature') && ~isempty(SimulationOptions.celltemperature)
    YAML_struct.Parameter.CellTemperature = SimulationOptions.celltemperature + 273.15;
else
    YAML_struct.Parameter.CellTemperature = 99999999999999999999;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "celltemperature" in SimulationOptions object is empty'];
    end
end
if isprop(cell_struct,'MinOpenCircuitVoltage') && ~isempty(cell_struct.MinOpenCircuitVoltage)
    YAML_struct.Parameter.MinVoltage = cell_struct.MinOpenCircuitVoltage;
else
    YAML_struct.Parameter.MinVoltage = 99999999999999999999;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "min_voltage" in SimulationOptions object is empty'];
    end
end
if isprop(cell_struct,'MaxOpenCircuitVoltage') && ~isempty(cell_struct.MaxOpenCircuitVoltage)
    YAML_struct.Parameter.MaxVoltage = cell_struct.MaxOpenCircuitVoltage;
else
    YAML_struct.Parameter.MaxVoltage = 99999999999999999999;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "min_voltage" in SimulationOptions object is empty'];
    end
end
if isprop(cell_struct,'Capacity') && ~isempty(cell_struct.Capacity)
    YAML_struct.Parameter.Current1C = cell_struct.Capacity;
else
    YAML_struct.Parameter.Current1C = 99999999999999999999;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Capacity" in Cell is empty'];
    end
end
% conductivity electrolyte
if isprop(cell_struct.ElectrodeStack.Electrolyte,'ConductivityArrhenius') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius) &&...
        isprop(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius,'Expression') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius.Expression) &&...
        isprop(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius.ActivationEnergy) &&...
            isprop(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius.ReferenceTemperature)
        
    YAML_struct.Parameter.Electrolyte.Conductivity                          = GetYMLOutputStruct(cell_struct.ElectrodeStack.Electrolyte.ConductivityArrhenius);
else
    target_temp                                                             = SimulationOptions.ambienttemperature;
    target_molarity                                                         = (0 : .25 : 2.5) .* 1000; %in mol/m³
    conductivity                                                            = interp2(cell_struct.ElectrodeStack.Electrolyte.TemperatureVector, cell_struct.ElectrodeStack.Electrolyte.ConductiveSaltMolarityVector .* 1000,... 
                                                                                cell_struct.ElectrodeStack.Electrolyte.IonicConductivityMatrix, target_temp, target_molarity,'spline'); %in mol/m³    
    fit_icm                                                                 = easyfit(target_molarity,conductivity,[1,2,3,4,5]);
    expression                                                              = strjoin(arrayfun(@(x) [num2str(fit_icm(x)) '*x^' num2str(5-x)],(1:numel(fit_icm)), 'UniformOutput',false),'+');
    YAML_struct.Parameter.Electrolyte.Conductivity.Expression               = expression;
    YAML_struct.Parameter.Electrolyte.Conductivity.ActivationEnergy         = 0;
    YAML_struct.Parameter.Electrolyte.Conductivity.ReferenceTemperature     = target_temp + 273.15;
    if flag_GUI_information
        app.(information_text_name).Value                                     = [app.(information_text_name).Value;'Field "ConductivityArrhenius" in the Electrolyte is empty. Generate function as a function of lithium concentration for definied ambient temperature based on ICM.'];
    end
end   
% diffusion electrolyte
if isprop(cell_struct.ElectrodeStack.Electrolyte,'DiffusionArrhenius') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius) &&...
    isprop(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius,'Expression') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius.Expression) &&...
        isprop(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius.ActivationEnergy) &&...
            isprop(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius.ReferenceTemperature)
    
    YAML_struct.Parameter.Electrolyte.Diffusion                             = GetYMLOutputStruct(cell_struct.ElectrodeStack.Electrolyte.DiffusionArrhenius);
elseif isprop(cell_struct.ElectrodeStack.Electrolyte, 'DiffusionCoefficient') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.DiffusionCoefficient)
    if flag_GUI_information
        app.(information_text_name).Value                                     = [app.(information_text_name).Value;'Field "DiffusionArrhenius" in the Electrolyte is empty. Generate default scalar arrhenius due to diffusion coefficient.'];
    end
    YAML_struct.Parameter.Electrolyte.Diffusion.Expression                  = cell_struct.ElectrodeStack.Electrolyte.DiffusionCoefficient;
    YAML_struct.Parameter.Electrolyte.Diffusion.ActivationEnergy            = 0;
    YAML_struct.Parameter.Electrolyte.Diffusion.ReferenceTemperature        = 25 + 273.15; % 25°C in K
else
    if flag_GUI_information
        app.(information_text_name).Value                                     = [app.(information_text_name).Value;'Field "DiffusionArrhenius" in the Electrolyte is empty. Parameter is necessary for a meaningful PCM simulation.'];
    end
    YAML_struct.Parameter.Electrolyte.Diffusion.Expression                  = 99999999999999;
    YAML_struct.Parameter.Electrolyte.Diffusion.ActivationEnergy            = 99999999999999;
    YAML_struct.Parameter.Electrolyte.Diffusion.ReferenceTemperature        = 99999999999999; % 25°C in K
    parameter_log                                                           = [parameter_log; {'Diffusion arrhenius electrolyte' 'ElectrodeStack.Electrolyte.DiffusionArrhenius'}];
end  
% transference number electrolyte
if isprop(cell_struct.ElectrodeStack.Electrolyte,'TransferenceNumber') && ~isempty(cell_struct.ElectrodeStack.Electrolyte.TransferenceNumber)
    YAML_struct.Parameter.Electrolyte.TransferenceNumber                    = cell_struct.ElectrodeStack.Electrolyte.TransferenceNumber; 
else
    YAML_struct.Parameter.Electrolyte.TransferenceNumber                    = 0.3;
    if flag_GUI_information
        app.(information_text_name).Value                                     = [app.(information_text_name).Value;'Field "TransferenceNumber" in Electrolyte object is empty. Set the Transference number to the default value of 0.3'];
    end
end
% ambient temperature of the cell
if isprop(SimulationOptions,'ambienttemperature') && ~isempty(SimulationOptions.ambienttemperature)
    YAML_struct.Parameter.Thermal.AmbientTemperature = SimulationOptions.ambienttemperature + 273.15;
else
    YAML_struct.Parameter.Thermal.AmbientTemperature = 99999999999999999999;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ambienttemperature" in SimulationOptions object is empty'];
    end
end
% thermal capacity cell
if isprop(cell_struct.ElectrodeStack,'ThermalCapacity') && ~isempty(cell_struct.ElectrodeStack.ThermalCapacity)
    YAML_struct.Parameter.Thermal.ThermalCapacityCoil = cell_struct.ElectrodeStack.ThermalCapacity;
else
    YAML_struct.Parameter.Thermal.ThermalCapacityCoil = 99999999999999999999;
    if flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalCapacity" in ElectrodeStack is empty'];
    end
end
%thermal resistance cell
if isprop(cell_struct.ElectrodeStack,'ThermalResistance') && isprop(cell_struct.ElectrodeStack,'ActiveSurface')  && ~isempty(cell_struct.ElectrodeStack.ThermalResistance) &&  ~isempty(cell_struct.ElectrodeStack.ActiveSurface)
    YAML_struct.Parameter.Thermal.ThermalConductivityCoilCase = 10000/(cell_struct.ElectrodeStack.ThermalResistance * cell_struct.ElectrodeStack.ActiveSurface);
else
    if ~isprop(cell_struct.ElectrodeStack,'ThermalResistance') || isempty(cell_struct.ElectrodeStack.ThermalResistance) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalResistance" in ElectrodeStack is empty'];
    end 
    if ~isprop(cell_struct.ElectrodeStack,'ActiveSurface') || isempty(cell_struct.ElectrodeStack.ActiveSurface) && flag_GUI_information
        app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ActiveSurface" in ElectrodeStack is empty'];
    end
    YAML_struct.Parameter.Thermal.ThermalConductivityCoilCase = 99999999999999999999;
    % calculation of the thermal transition coefficient from the electrode stack to the housing    
    if  isprop(cell_struct.ElectrodeStack,'Anode') && ~isempty(cell_struct.ElectrodeStack.Anode) 
        if  isprop(cell_struct.ElectrodeStack.Anode,'CoatingDimensions') && ~isempty(cell_struct.ElectrodeStack.Anode.CoatingDimensions) && ...
            isprop(cell_struct.ElectrodeStack,'NrOfAnodes') && ~isempty(cell_struct.ElectrodeStack.NrOfAnodes) && ...
            isprop(cell_struct.ElectrodeStack.Anode,'Coating') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating) 
            if  isprop(cell_struct.ElectrodeStack.Anode.Coating,'ThermalConductivity') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ThermalConductivity) 
                Anode_ThermalConductivity = cell_struct.ElectrodeStack.NrOfAnodes*(1/cell_struct.ElectrodeStack.Anode.Coating.ThermalConductivity)*((cell_struct.ElectrodeStack.Anode.CoatingDimensions(1,3)+cell_struct.ElectrodeStack.Anode.CoatingDimensions(2,3))/2);
            else
                Anode_ThermalConductivity = 0;
                if flag_GUI_information
                    app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalConductivity" in Coating of the Anode is empty'];
                end
            end
        else
            Anode_ThermalConductivity = 0;
        end
    else
        Anode_ThermalConductivity = 0;
    end
    if  isprop(cell_struct.ElectrodeStack,'Cathode') && ~isempty(cell_struct.ElectrodeStack.Cathode) 
        if  isprop(cell_struct.ElectrodeStack.Cathode,'CoatingDimensions') && ~isempty(cell_struct.ElectrodeStack.Cathode.CoatingDimensions) && ...
            isprop(cell_struct.ElectrodeStack,'NrOfCathodes') && ~isempty(cell_struct.ElectrodeStack.NrOfCathodes) && ...
            isprop(cell_struct.ElectrodeStack.Cathode,'Coating') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating) 
            if  isprop(cell_struct.ElectrodeStack.Cathode.Coating,'ThermalConductivity') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ThermalConductivity)
                Cathode_ThermalConductivity = cell_struct.ElectrodeStack.NrOfCathodes*(1/cell_struct.ElectrodeStack.Cathode.Coating.ThermalConductivity)*((cell_struct.ElectrodeStack.Cathode.CoatingDimensions(1,3)+cell_struct.ElectrodeStack.Cathode.CoatingDimensions(2,3))/2);
            else
                Cathode_ThermalConductivity = 0;
                if flag_GUI_information
                    app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalConductivity" in Coating of the Cathode is empty'];
                end
            end
        else
            Cathode_ThermalConductivity = 0;
        end
    else
        Cathode_ThermalConductivity = 0;
    end
    if  isprop(cell_struct.ElectrodeStack,'Separator') && ~isempty(cell_struct.ElectrodeStack.Separator)
        if    isprop(cell_struct.ElectrodeStack.Separator,'Dimensions') && ~isempty(cell_struct.ElectrodeStack.Separator.Dimensions) && ...
            isprop(cell_struct.ElectrodeStack,'NrOfSeparators') && ~isempty(cell_struct.ElectrodeStack.NrOfSeparators) 
            if  isprop(cell_struct.ElectrodeStack.Separator,'ThermalConductivity') && ~isempty(cell_struct.ElectrodeStack.Separator.ThermalConductivity) 
                Separator_ThermalConductivity = cell_struct.ElectrodeStack.NrOfSeparators*(1/cell_struct.ElectrodeStack.Separator.ThermalConductivity)*cell_struct.ElectrodeStack.Separator.Dimensions(1,3);
            else
                Separator_ThermalConductivity = 0;
                if flag_GUI_information
                    app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalConductivity" in Separator is empty'];
                end
            end
        else
            Separator_ThermalConductivity = 0;
        end
    else
        Separator_ThermalConductivity = 0;
    end
    if strcmp(cell_struct.Housing.Type,'pouch') || strcmp(cell_struct.Housing.Type,'prismatic')
        if isprop(cell_struct,'EstimatedElectrodeStackDimensions') && ~isempty(cell_struct.EstimatedElectrodeStackDimensions)
            complete_ThermalConductivity = 1/((Separator_ThermalConductivity+Cathode_ThermalConductivity+Anode_ThermalConductivity)/(0.5*cell_struct.EstimatedElectrodeStackDimensions(1,3)));
            Surface = 2 * (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000) * (cell_struct.EstimatedElectrodeStackDimensions(1,2)/1000);
            Length = 0.5*(cell_struct.EstimatedElectrodeStackDimensions(1,3)/1000);
            R_th_normal = Length/(Surface*complete_ThermalConductivity);
            Surface = 2 * (cell_struct.EstimatedElectrodeStackDimensions(1,2)/1000) * (cell_struct.EstimatedElectrodeStackDimensions(1,3)/1000);
            Length = 0.5 * (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000);
            R_th_parallel_1 = Length/(Surface*complete_ThermalConductivity);
            Surface = 2 * (cell_struct.EstimatedElectrodeStackDimensions(1,3)/1000) * (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000);
            Length = 0.5 * (cell_struct.EstimatedElectrodeStackDimensions(1,2)/1000);
            R_th_parallel_2 = Length/(Surface*complete_ThermalConductivity);
            Thermal_Resistance = 1/((1/R_th_normal)+(1/R_th_parallel_1)+(1/R_th_parallel_2));
            if isprop(cell_struct.ElectrodeStack,'ActiveSurface') && ~isempty(cell_struct.ElectrodeStack.ActiveSurface)
                YAML_struct.Parameter.Thermal.ThermalConductivityCoilCase = 10000/(Thermal_Resistance * cell_struct.ElectrodeStack.ActiveSurface);
            end            
        elseif flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "EstimatedElectrodeStackDimensions" in Cell is empty'];
        end
    else
        if isprop(cell_struct,'EstimatedElectrodeStackDimensions') && ~isempty(cell_struct.EstimatedElectrodeStackDimensions)
            complete_ThermalConductivity = 1/((Separator_ThermalConductivity+Cathode_ThermalConductivity+Anode_ThermalConductivity)/(cell_struct.EstimatedElectrodeStackDimensions(1,1)));
            Surface = 2 * pi * (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000) * (cell_struct.EstimatedElectrodeStackDimensions(1,2)/1000);
            Length = (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000);
            R_th_normal = Length/(Surface*complete_ThermalConductivity);
            Surface = pi * (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000) * (cell_struct.EstimatedElectrodeStackDimensions(1,1)/1000);
            Length = 0.5 * (cell_struct.EstimatedElectrodeStackDimensions(1,3)/1000);
            R_th_parallel = Length/(Surface*complete_ThermalConductivity);
            Thermal_Resistance = 1/((1/R_th_normal)+(1/R_th_parallel));
            if isprop(cell_struct.ElectrodeStack,'ActiveSurface') && ~isempty(cell_struct.ElectrodeStack.ActiveSurface)
                YAML_struct.Parameter.Thermal.ThermalConductivityCoilCase = 10000/(Thermal_Resistance * cell_struct.ElectrodeStack.ActiveSurface);
            end            
        elseif flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "EstimatedElectrodeStackDimensions" in Cell is empty'];
        end
    end
end
% thermal capacity case
if strcmp(cell_struct.Housing.Type,'pouch')
    YAML_struct.Parameter.Thermal.ThermalConductivityCaseAmbient = ThermalConductivityCaseAmbient;  %% kommt nicht aus Zelle, da abhängig von Luftgeschwindigkeit etc
    if isprop(cell_struct.Housing.FoilMaterials{1,1},'ThermalCapacity') && ~isempty(cell_struct.Housing.FoilMaterials{1,1}.ThermalCapacity)
        YAML_struct.Parameter.Thermal.ThermalCapacityCase = cell_struct.Housing.FoilMaterials{1,1}.ThermalCapacity;
    else
        YAML_struct.Parameter.Thermal.ThermalCapacityCase = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalCapacity" in ElectrodeStack is empty'];
        end
    end
else
    YAML_struct.Parameter.Thermal.ThermalConductivityCaseAmbient = ThermalConductivityCaseAmbient;  %% kommt nicht aus Zelle, da abhängig von Luftgeschwindigkeit etc
    if isprop(cell_struct.Housing.Material,'ThermalCapacity') && ~isempty(cell_struct.Housing.Material.ThermalCapacity)
        YAML_struct.Parameter.Thermal.ThermalCapacityCase = cell_struct.Housing.Material.ThermalCapacity;
    else
        YAML_struct.Parameter.Thermal.ThermalCapacityCase = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalCapacity" in ElectrodeStack is empty'];
        end
    end
end
if isprop(cell_struct.ElectrodeStack,'StateOfCharge') && ~isempty(cell_struct.ElectrodeStack.StateOfCharge) && isprop(SimulationOptions,'StateOfCharge') && ~isempty(SimulationOptions.StateOfCharge)
    [~,SOC_index] = min(abs(cell_struct.ElectrodeStack.StateOfCharge-(SimulationOptions.StateOfCharge/100)));
else
    SOC_index = 1;
    display_struct.StateOfCharge = 1;
    if ~isprop(cell_struct.ElectrodeStack,'StateOfCharge') || isempty(cell_struct.ElectrodeStack.StateOfCharge)
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "StateOfCharge" in ElectrodeStack is empty'];
        end
    end 
    if ~isprop(SimulationOptions,'StateOfCharge') || isempty(SimulationOptionsStateOfCharge)
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "StateOfChargee" in SimulationOptions is empty'];
        end
    end
end
%% VolumeElements
% Cathode
if isprop(cell_struct.ElectrodeStack,'Cathode') && ~isempty(cell_struct.ElectrodeStack.Cathode)
    YAML_struct.VolumeElements{1,Cathode_index}.Identifier = 'Kathode';
    YAML_struct.VolumeElements{1,Cathode_index}.Polarity = 'POSITIVE';
    if isprop(cell_struct.ElectrodeStack.Cathode,'ElectrolyteAvailableVolume') && ~isempty(cell_struct.ElectrodeStack.Cathode.ElectrolyteAvailableVolume) && isprop(cell_struct.ElectrodeStack.Cathode,'Volume') && ~isempty(cell_struct.ElectrodeStack.Cathode.Volume)
        YAML_struct.VolumeElements{1,Cathode_index}.Electrolyte.VolumeFraction = cell_struct.ElectrodeStack.Cathode.ElectrolyteAvailableVolume/cell_struct.ElectrodeStack.Cathode.Volume;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Electrolyte.VolumeFraction = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "celltemperture" in SimulationOptions object is empty'];
        end
    end
    if isprop(cell_struct.ElectrodeStack.Cathode,'ElectrolyteTortuosity') && ~isempty(cell_struct.ElectrodeStack.Cathode.ElectrolyteTortuosity)
        YAML_struct.VolumeElements{1,Cathode_index}.Electrolyte.Tortuosity = cell_struct.ElectrodeStack.Cathode.ElectrolyteTortuosity;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Electrolyte.Tortuosity = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalCapacity" in ElectrodeStack is empty'];
        end
    end
    YAML_struct.VolumeElements{1,Cathode_index}.Electrolyte.InitialConcentration = cell_struct.ElectrodeStack.InitElectrolyteConcentration;
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating,'ArrheniusConductivity') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity) &&...
            isprop(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity,'Expression') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity.Expression) &&...
            isprop(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity.ActivationEnergy) &&...
            isprop(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity.ReferenceTemperature)
        
        YAML_struct.VolumeElements{1,Cathode_index}.Conductivity                        = GetYMLOutputStruct(cell_struct.ElectrodeStack.Cathode.Coating.ArrheniusConductivity);
    elseif isprop(cell_struct.ElectrodeStack.Cathode.Coating, 'ElectricalConductivity') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ElectricalConductivity)
        if flag_GUI_information
            app.(information_text_name).Value                                             = [app.(information_text_name).Value;'Field "ArrheniusConductivity" in the Activematerial of the Cathode is empty. Use the coating conductivity as default value.'];
        end
            YAML_struct.VolumeElements{1,Cathode_index}.Conductivity.ReferenceTemperature   = 298.15; %°K --> 25°C
        YAML_struct.VolumeElements{1,Cathode_index}.Conductivity.ActivationEnergy       = 0;
        YAML_struct.VolumeElements{1,Cathode_index}.Conductivity.Expression             = cell_struct.ElectrodeStack.Cathode.Coating.ElectricalConductivity;
    else
        if flag_GUI_information
            app.(information_text_name).Value                                             = [app.(information_text_name).Value;'Field "ArrheniusConductivity" in the Activematerial of the Cathode is empty.'];
        end
        YAML_struct.VolumeElements{1,Cathode_index}.Conductivity.ReferenceTemperature   = 9999999999999;
        YAML_struct.VolumeElements{1,Cathode_index}.Conductivity.ActivationEnergy       = 9999999999999;
        YAML_struct.VolumeElements{1,Cathode_index}.Conductivity.Expression             = 9999999999999;
        parameter_log                                                                   = [parameter_log; {'Arrhenius conductivity' 'ElectrodeStack.Cathode.Coating.ActiveMaterial.ConductivityArrhenius'}];
    end    
    if isprop(SimulationOptions, 'ParticleType') && ~isempty(SimulationOptions.ParticleType)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Type = SimulationOptions.ParticleType;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Type = 'sphericalFDM';
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ParticleType" in SimulationOptions is empty. Use sphericalFDM as default value.'];
        end
    end
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'ArrheniusReactionRate') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate) &&...
             isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate,'Expression') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate.Expression) &&...
                isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate.ActivationEnergy) &&...
                    isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate.ReferenceTemperature)
        
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate                          = GetYMLOutputStruct(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate);      
    elseif isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial, 'ReactionRate')
        if flag_GUI_information
            app.(information_text_name).Value                                                             = [app.(information_text_name).Value;'Field "ArrheniusReactionRate" in the Activematerial of the Cathode is empty. Use default scalar arrhenius due to reaction rate.'];
        end
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate.ReferenceTemperature     = 298.15; %°K --> 25°C;
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate.ActivationEnergy         = 0;
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate.Expression               = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ReactionRate;
    else
        if flag_GUI_information
            app.(information_text_name).Value                                                             = [app.(information_text_name).Value;'Field "ArrheniusReactionRate" in the Activematerial of the Cathode is empty. Parameter necessary for meaningful PCM simulation.'];
        end
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate.ReferenceTemperature     = 9999999999999999999;
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate.ActivationEnergy         = 9999999999999999999;
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ReactionRate.Expression               = 9999999999999999999;
        parameter_log                                                                                   = [parameter_log; {'Arrhenius reaction rate cathode' 'ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusReactionRate'}];
    end  
    % maximum lithium concentration
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial, 'MaxLithiumConcentration') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MaxLithiumConcentration)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.MaxConcentration = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MaxLithiumConcentration;
    elseif isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'OccupancyRate') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OccupancyRate)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.MaxConcentration = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2) / cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MolarMass * cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.Density *1E6; 
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.MaxConcentration = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "OccupancyRate" in the Activematerial of the Cathode is empty'];
        end
    end
    YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ElectricConnention = 0;
    if ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.SEIResistance)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ResistanceSEI = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.SEIResistance;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.ResistanceSEI = 0;
    end
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial, 'OpenCircuitPotentialLith') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OpenCircuitPotentialLith) &&...
           isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial, 'OccupancyRate') &&  ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OccupancyRate)
       
       mean_lithiation_delithiation_potential                                           = mean([cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OpenCircuitPotentialLith cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OpenCircuitPotential],2); %Hysteresis handling
       max_lithiation                                                                   = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2);
       min_lithiation                                                                   = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(1);
       soc                                                                              = (cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OccupancyRate - min_lithiation) ./ (max_lithiation - min_lithiation);
       if numel(soc) > 101 && ~numel(soc) < 100 
          stepsize              = floor(numel(soc) / 100); 
          modified_soc          = round(soc(1 : stepsize : numel(soc)),4);
          modified_potential    = round(mean_lithiation_delithiation_potential(1 : stepsize : numel(soc)),4);
          if modified_soc(1) ~= 0
             modified_soc(1)            = 0;
             modified_potential(1)      = interp1(modified_soc,modified_potential,0,'spline');
          end
          if modified_soc(end) ~= 1
             modified_soc(end)          = 1;
             modified_potential(end)    = interp1(modified_soc,modified_potential,1,'spline');
          end
          soc                                       = modified_soc;
          mean_lithiation_delithiation_potential    = modified_potential;
       end
       spline                                                                           = pchip(soc,mean_lithiation_delithiation_potential);
       YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OCV.Spline.X_Value     = spline.breaks;
       YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OCV.Spline.Coefs       = spline.coefs;
       YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OCV.ActivationEnergy   = 0.0; %spline and no arrhenius
       YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OCV.ReferenceTemperature = 298.15; %°K --> 25°C
    else
       YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OCV.Spline.X_Value    = 99999999999999999999;
       YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OCV.Spline.Coefs      = [99999999999999999999 99999999999999999999 99999999999999999999 99999999999999999999];
       parameter_log                                                                   = [parameter_log; {'OCP LookUp-Table Cathode' 'ElectrodeStack.Cathode.Coating.ActiveMaterial.OpenCircuitPotentialLith'}];
       if flag_GUI_information
        app.(information_text_name).Value                                             = [app.(information_text_name).Value;'Field "OpenCircuitPotential" in the Activematerial of the Cathode is empty. NO meaningful PCM simulation possible.'];
       end
    end  
    % diffusion active material cathode
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'ArrheniusDiffusion') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion) &&...
            isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion,'Expression') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion.Expression) &&...
                isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion.ActivationEnergy) &&...
                    isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion.ReferenceTemperature)

        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Diffusion                             = GetYMLOutputStruct(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ArrheniusDiffusion);                 
    else
        if flag_GUI_information
            app.(information_text_name).Value                                                             = [app.(information_text_name).Value;['Field "ArrheniusDiffusion" in the Activematerial of the Cathode is empty. Using the default value ' num2str(1E-10) ' .']];
        end
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Diffusion.ReferenceTemperature        = 298.15; %°K --> 25°C
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Diffusion.ActivationEnergy            = 0;
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Diffusion.Expression                  = 1E-10; %m²/s --> from mark junker
    end 
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'ParticleRadius') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ParticleRadius)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Radius = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.ParticleRadius * 1E-6;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Radius = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ParticleRadius" in the Activematerial of the Cathode is empty'];
        end
        parameter_log                                                                               = [parameter_log; {'Particle radius cathode' 'ElectrodeStack.Cathode.Coating.ActiveMaterial.ParticleRadius'}];
    end
    if isprop(SimulationOptions,'ParticleDivision') && ~isempty(SimulationOptions.ParticleDivision)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Division = SimulationOptions.ParticleDivision;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.Division = 10;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ParticleDivision" in the SimulationOptions is empty. Use default value 10.'];
        end
    end
    if isprop(cell_struct.ElectrodeStack.Cathode,'Porosity') && ~isempty(cell_struct.ElectrodeStack.Cathode.Porosity) && ...
            isprop(cell_struct.ElectrodeStack.Cathode.Coating,'VolumeFractionActiveMaterial') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.VolumeFractionActiveMaterial)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.VolumeFraction = (1-cell_struct.ElectrodeStack.Cathode.Porosity) * cell_struct.ElectrodeStack.Cathode.Coating.VolumeFractionActiveMaterial;
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.VolumeFraction = 99999999999999999999;
        if  isprop(cell_struct.ElectrodeStack.Cathode,'Porosity') && ~isempty(cell_struct.ElectrodeStack.Cathode.Porosity) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Porosity" in the Cathode is empty'];
        end
        if isprop(cell_struct.ElectrodeStack.Cathode.Coating,'VolumeFractionActiveMaterial') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.VolumeFractionActiveMaterial) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "VolumeFractionActiveMaterial" in the Coating of the Cathode is empty'];
        end
    end
    if isprop(cell_struct.ElectrodeStack,'CathodeUsedOccupancyRate') && ~isempty(cell_struct.ElectrodeStack.CathodeUsedOccupancyRate) && ...
            isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'MinMaxOccupancyRange') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.InitialConcentration = cell_struct.ElectrodeStack.CathodeUsedOccupancyRate(length(cell_struct.ElectrodeStack.CathodeUsedOccupancyRate) + 1 - SOC_index)/...
                                                                                            cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2);
    else
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.InitialConcentration = 99999999999999999999;
        if  isprop(cell_struct.ElectrodeStack,'CathodeOccupancyRate') && ~isempty(cell_struct.ElectrodeStack.CathodeOccupancyRate) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "OccupancyRate" in the ElectrodeStack is empty'];
        end
        if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'OccupancyRate') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.OccupancyRate) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "OccupancyRate" in the Activematerial of the Cathode is empty'];
        end
    end
    %double layer capacitance density
    if isprop(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial,'DoubleLayerCapacitanceDensity') && ~isempty(cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.DoubleLayerCapacitanceDensity)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.DoubleLayerCapacitanceDensity         = cell_struct.ElectrodeStack.Cathode.Coating.ActiveMaterial.DoubleLayerCapacitanceDensity;
    end
    % occupancy rate limites
    if isprop(cell_struct.ElectrodeStack,'CathodeUsedOccupancyRange') && ~isempty(cell_struct.ElectrodeStack.CathodeUsedOccupancyRange)
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OccupancyRange.Min                        = cell_struct.ElectrodeStack.CathodeUsedOccupancyRange(1);
        YAML_struct.VolumeElements{1,Cathode_index}.Particle{1,1}.OccupancyRange.Max                        = cell_struct.ElectrodeStack.CathodeUsedOccupancyRange(2);
    end
end

% Seperator
if isprop(cell_struct.ElectrodeStack,'Separator') && ~isempty(cell_struct.ElectrodeStack.Separator)
    YAML_struct.VolumeElements{1,Separator_index}.Identifier = 'Separator';
    YAML_struct.VolumeElements{1,Separator_index}.Polarity = 'SEPARATOR';
    if isprop(cell_struct.ElectrodeStack.Separator,'ElectrolyteAvailableVolume') && ~isempty(cell_struct.ElectrodeStack.Separator.ElectrolyteAvailableVolume) && isprop(cell_struct.ElectrodeStack.Separator,'Volume') && ~isempty(cell_struct.ElectrodeStack.Separator.Volume)
        YAML_struct.VolumeElements{1,Separator_index}.Electrolyte.VolumeFraction = cell_struct.ElectrodeStack.Separator.ElectrolyteAvailableVolume/cell_struct.ElectrodeStack.Separator.Volume;
    else
        YAML_struct.VolumeElements{1,Separator_index}.Electrolyte.VolumeFraction = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalCapacity" in ElectrodeStack is empty'];
        end
    end
    if isprop(cell_struct.ElectrodeStack.Separator,'Tortuosity') && ~isempty(cell_struct.ElectrodeStack.Separator.Tortuosity)
        YAML_struct.VolumeElements{1,Separator_index}.Electrolyte.Tortuosity = cell_struct.ElectrodeStack.Separator.Tortuosity;
    else
        YAML_struct.VolumeElements{1,Separator_index}.Electrolyte.Tortuosity = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ThermalCapacity" in ElectrodeStack is empty'];
        end
    end
    YAML_struct.VolumeElements{1,Separator_index}.Electrolyte.InitialConcentration = cell_struct.ElectrodeStack.InitElectrolyteConcentration;
end

% Anode
if isprop(cell_struct.ElectrodeStack,'Anode') && ~isempty(cell_struct.ElectrodeStack.Anode)
    YAML_struct.VolumeElements{1,Anode_index}.Identifier = 'Anode';
    YAML_struct.VolumeElements{1,Anode_index}.Polarity = 'NEGATIVE';
    if isprop(cell_struct.ElectrodeStack.Anode,'ElectrolyteAvailableVolume') && ~isempty(cell_struct.ElectrodeStack.Anode.ElectrolyteAvailableVolume) && isprop(cell_struct.ElectrodeStack.Anode,'Volume') && ~isempty(cell_struct.ElectrodeStack.Anode.Volume)
        YAML_struct.VolumeElements{1,Anode_index}.Electrolyte.VolumeFraction = cell_struct.ElectrodeStack.Anode.ElectrolyteAvailableVolume/cell_struct.ElectrodeStack.Anode.Volume;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Electrolyte.VolumeFraction = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "celltemperture" in SimulationOptions object is empty'];
        end
    end
    if isprop(cell_struct.ElectrodeStack.Anode,'ElectrolyteTortuosity') && ~isempty(cell_struct.ElectrodeStack.Anode.ElectrolyteTortuosity)
        YAML_struct.VolumeElements{1,Anode_index}.Electrolyte.Tortuosity = cell_struct.ElectrodeStack.Anode.ElectrolyteTortuosity;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Electrolyte.Tortuosity = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ElectrolyteTortuosity" in Anode is empty'];
        end
    end
    YAML_struct.VolumeElements{1,Anode_index}.Electrolyte.InitialConcentration = cell_struct.ElectrodeStack.InitElectrolyteConcentration;
    if isprop(cell_struct.ElectrodeStack.Anode.Coating,'ArrheniusConductivity') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity) &&...
            isprop(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity,'Expression') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity.Expression) &&...
            isprop(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity.ActivationEnergy) &&...
            isprop(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity.ReferenceTemperature)
        
        YAML_struct.VolumeElements{1,Anode_index}.Conductivity                          = GetYMLOutputStruct(cell_struct.ElectrodeStack.Anode.Coating.ArrheniusConductivity);
    else
        if flag_GUI_information
            app.(information_text_name).Value                                             = [app.(information_text_name).Value;'Field "ArrheniusConductivity" in the Activematerial of the Anode is empty. Use the coating conductivity as default value.'];
        end
        YAML_struct.VolumeElements{1,Anode_index}.Conductivity.ReferenceTemperature     = 298.15; %°K --> 25°C
        YAML_struct.VolumeElements{1,Anode_index}.Conductivity.ActivationEnergy         = 0;
        YAML_struct.VolumeElements{1,Anode_index}.Conductivity.Expression               = cell_struct.ElectrodeStack.Anode.Coating.ElectricalConductivity;
        parameter_log                                                                   = [parameter_log; {'Arrhenius conductivity Anode' 'ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusConductivity'}];
    end    
    
    if isprop(SimulationOptions, 'ParticleType') && ~isempty(SimulationOptions.ParticleType)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Type = SimulationOptions.ParticleType;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Type = 'sphericalFDM';
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ParticleType" in SimulationOptions is empty. Use sphericalFDM as default value.'];
        end
    end
    if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'ArrheniusReactionRate') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate) &&...
             isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate,'Expression') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate.Expression) &&...
                isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate.ActivationEnergy) &&...
                    isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate.ReferenceTemperature)
        
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate                          = GetYMLOutputStruct(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate);        
    elseif isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial, 'ReactionRate') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ReactionRate)
        if flag_GUI_information
            app.(information_text_name).Value                                                           = [app.(information_text_name).Value;'Field "ArrheniusReactionRate" in the Activematerial of the Anode is empty. Use default scalar arrhenius due to reaction rate.'];
        end
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate.ReferenceTemperature     = 298.15; %°K --> 25°C;
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate.ActivationEnergy         = 0;
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate.Expression               = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ReactionRate;
    else
        if flag_GUI_information
            app.(information_text_name).Value                                                           = [app.(information_text_name).Value;'Field "ArrheniusReactionRate" in the Activematerial of the Anode is empty. Parameter necessary for meaningful PCM simulation.'];
        end
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate.ReferenceTemperature     = 9999999999999999999;
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate.ActivationEnergy         = 9999999999999999999;
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ReactionRate.Expression               = 9999999999999999999;
        parameter_log                                                                                 = [parameter_log; {'Arrhenius reaction rate Anode' 'ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate'}];
    end     
    if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'OccupancyRate') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OccupancyRate)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.MaxConcentration = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2) / cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.MolarMass * cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.Density *1E6; 
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.MaxConcentration = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "OccupancyRate" in the Activematerial of the Anode is empty'];
        end
    end
    YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ElectricConnention  = 0;
    if ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.SEIResistance)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ResistanceSEI = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.SEIResistance;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.ResistanceSEI = 0;
    end
    if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial, 'OpenCircuitPotentialLith') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OpenCircuitPotentialLith) &&...
           isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial, 'OccupancyRate') &&  ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OccupancyRate)
       
       mean_lithiation_delithiation_potential                                             = mean([cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OpenCircuitPotentialLith cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OpenCircuitPotential],2); %Hysteresis handling
       max_lithiation                                                                   = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2);
       min_lithiation                                                                   = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(1);
       soc                                                                              = (cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OccupancyRate - min_lithiation) ./ (max_lithiation - min_lithiation);
       if numel(soc) > 101 && ~numel(soc) < 100 
          stepsize              = floor(numel(soc) / 100); 
          modified_soc          = round(soc(1 : stepsize : numel(soc)),4);
          modified_potential    = round(mean_lithiation_delithiation_potential(1 : stepsize : numel(soc)),4);
          if modified_soc(1) ~= 0
             modified_soc(1)            = 0;
             modified_potential(1)      = interp1(modified_soc,modified_potential,0,'spline');
          end
          if modified_soc(end) ~= 1
             modified_soc(end)          = 1;
             modified_potential(end)    = interp1(modified_soc,modified_potential,1,'spline');
          end
          soc                                       = modified_soc;
          mean_lithiation_delithiation_potential    = modified_potential;
       end
       spline                                                                           = pchip(soc,mean_lithiation_delithiation_potential);
       YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OCV.Spline.X_Value       = spline.breaks;
       YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OCV.Spline.Coefs         = spline.coefs;
       YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OCV.ActivationEnergy     = 0.0; %spline and no arrhenius
       YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OCV.ReferenceTemperature = 298.15; %°K --> 25°C
    else
       YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OCV.Spline.X_Value       = 99999999999999999999;
       YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OCV.Spline.Coefs         = [99999999999999999999 99999999999999999999 99999999999999999999 99999999999999999999];
       parameter_log                                                                    = [parameter_log; {'OCP LookUp-Table Anode' 'ElectrodeStack.Anode.Coating.ActiveMaterial.OpenCircuitPotentialLith'}];
       if flag_GUI_information
        app.(information_text_name).Value                                              = [app.(information_text_name).Value;'Field "OpenCircuitPotential" in the Activematerial of the Anode is empty. NO meaningful PCM simulation possible.'];
       end
    end  
    % diffusion active material anode
    if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'ArrheniusDiffusion') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion) &&...
            isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion,'Expression') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion.Expression) &&...
                isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion,'ActivationEnergy') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion.ActivationEnergy) &&...
                    isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion,'ReferenceTemperature') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion.ReferenceTemperature)
        
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Diffusion                           = GetYMLOutputStruct(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusDiffusion);               
    else
        if flag_GUI_information
            app.(information_text_name).Value                                                         = [app.(information_text_name).Value;['Field "ArrheniusDiffusion" in the Activematerial of the Anode is empty. Using the default value ' num2str(1E-10) ' .']];
        end
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Diffusion.ReferenceTemperature      = 298.15; %°K --> 25°C
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Diffusion.ActivationEnergy          = 0;
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Diffusion.Expression                = 1E-10; %m²/s --> from mark junker
    end   
    % particel radius anode
    if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'ParticleRadius') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ParticleRadius)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Radius = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.ParticleRadius * 1E-6;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Radius = 1E-6;
        if flag_GUI_information
            app.(information_text_name).Value                                                         = [app.(information_text_name).Value;'Field "ParticleRadius" in the Activematerial of the Anode is empty'];
        end
        parameter_log                                                                               = [parameter_log; {'Particle radius anode' 'ElectrodeStack.Anode.Coating.ActiveMaterial.ParticleRadius'}];
    end
    % particel division anode
    if isprop(SimulationOptions,'ParticleDivision') && ~isempty(SimulationOptions.ParticleDivision)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Division = SimulationOptions.ParticleDivision;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.Division = 99999999999999999999;
        if flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "ParticleDivision" in SimulationOptions is empty'];
        end
    end
    %porosity anode
    if isprop(cell_struct.ElectrodeStack.Anode,'Porosity') && ~isempty(cell_struct.ElectrodeStack.Anode.Porosity) && ...
            isprop(cell_struct.ElectrodeStack.Anode.Coating,'VolumeFractionActiveMaterial') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.VolumeFractionActiveMaterial)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.VolumeFraction = (1-cell_struct.ElectrodeStack.Anode.Porosity) * cell_struct.ElectrodeStack.Anode.Coating.VolumeFractionActiveMaterial;
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.VolumeFraction = 99999999999999999999;
        if  isprop(cell_struct.Electrode.Anode,'Porosity') && ~isempty(cell_struct.ElectrodeStack.Anode.Porosity) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "Porosity" in the Anode is empty'];
        end
        if isprop(cell_struct.ElectrodeStack.Anode.Coating,'VolumeFractionActiveMaterial') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.VolumeFractionActiveMaterial) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "VolumeFractionActiveMaterial" in the Coating of the Anode is empty'];
        end
    end
    if isprop(cell_struct.ElectrodeStack,'AnodeUsedOccupancyRate') && ~isempty(cell_struct.ElectrodeStack.AnodeUsedOccupancyRate) && ...
            isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'MinMaxOccupancyRange') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.InitialConcentration = cell_struct.ElectrodeStack.AnodeUsedOccupancyRate(SOC_index)/cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2);
    else
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.InitialConcentration = 99999999999999999999;
        if  isprop(cell_struct.ElectrodeStack,'AnodeOccupancyRate') && ~isempty(cell_struct.ElectrodeStack.AnodeOccupancyRate) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "OccupancyRate" in the ElectrodeStack is empty'];
        end
        if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'OccupancyRate') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.OccupancyRate) && flag_GUI_information
            app.(information_text_name).Value             = [app.(information_text_name).Value;'Field "OccupancyRate" in the Activematerial of the Anode is empty'];
        end
    end
    %double layer capacitance density
    if isprop(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial,'DoubleLayerCapacitanceDensity') && ~isempty(cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.DoubleLayerCapacitanceDensity)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.DoubleLayerCapacitanceDensity           = cell_struct.ElectrodeStack.Anode.Coating.ActiveMaterial.DoubleLayerCapacitanceDensity;
    end
    % occupancy rate limites
    if isprop(cell_struct.ElectrodeStack,'AnodeUsedOccupancyRange') && ~isempty(cell_struct.ElectrodeStack.AnodeUsedOccupancyRange)
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OccupancyRange.Min                        = cell_struct.ElectrodeStack.AnodeUsedOccupancyRange(1);
        YAML_struct.VolumeElements{1,Anode_index}.Particle{1,1}.OccupancyRange.Max                        = cell_struct.ElectrodeStack.AnodeUsedOccupancyRange(2);
    end
end
if flag_GUI_information
    app.(information_text_name).Value             = [app.(information_text_name).Value;'-----------------------------------------------------------------------------------------------------------'];
    app.(information_text_name).Value             = [app.(information_text_name).Value;'End of YML-File creation'];
end
end