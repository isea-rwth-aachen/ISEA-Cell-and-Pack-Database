function clb_initialise_GUI(app)
%% Function to initialize the ICPD GUI
%% initialize global variables
global global_ACMaterial;
global global_blends;
global global_housings;
global global_electrodeStacks;
global global_cells;
global global_simOptions;
global global_variedCells;
global_ACMaterial               = {};
global_blends                   = {};
global_housings                 = {};
global_electrodeStacks          = {};
global_cells                    = {};
global_simOptions               = {};
global_variedCells              = {};
%% check pathes
pathes_to_exist                 = {'Classes' 'src\functions'};
path_not_exist                  = logical(cell2mat(cellfun(@(x) ~isfolder(fullfile(pwd,x)), pathes_to_exist,'UniformOutput', false)));
if any(path_not_exist)
    new_path                    = uigetdir(pwd, 'Select the working directory');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if isempty(new_path) || new_path == 0 || ~isfolder(new_path)
        clearvars -global
        delete(app);
        return;
    else
        app.working_directory       = new_path;
        addpath(genpath(new_path));
    end
else
    app.working_directory       = pwd;
end
%% set propertys
% active materials 
app.vartypes_ACMaterialTable        = {'string', 'string' 'double' 'double' 'string' 'double' 'double' 'double' 'double' 'logical'}; %Data types of the columns must be updated if the table of substances is changed!
app.units_vars_ACMaterialTable      = {'' '' 'g/mol' 'g/cm³' '' 'mAh/g' '' 'V' 'V' ''};
app.id_class_to_ACMaterial_table    = {'Name' 'ChemFormula' 'MolarMass' 'Density' 'TransferMaterial' 'GravCapacity' 'RelVolumeIncreaseOnLith' 'MaxOpenCircuitPotential' 'MinOpenCircuitPotentialLith' ''};
app.ACMaterialTable.ColumnName     = {'Name','Formula','Molar mass','Density','Transfer material','Grav. capacity','Rel. volume increase','Max OCP','Min. OCP','Edit'};
% blends 
app.vartypes_BlendsTable            = {'string' 'string' 'string' 'double' 'double' 'string' 'double' 'double' 'double' 'double' 'logical'}; %Data types of the columns must be updated if the table of substances is changed!
app.units_vars_BlendsTable          = {'' '' '' 'g/mol' 'g/cm³' '' 'mAh/g' '' 'V' 'V' ''};
app.id_class_to_Blends_table        = {'Name' 'ChemFormula' 'ActiveMaterial' 'MolarMass' 'Density' 'TransferMaterial' 'GravCapacity' 'RelVolumeIncreaseOnLith' 'MaxOpenCircuitPotential' 'MinOpenCircuitPotentialLith' ''};
app.BlendsTable.ColumnName          = {'Name','Formula','Active Material','Molar mass','Density','Transfer Material','Grav. capacity','Rel. volume increase','Max. OPC','Min. OPC','Edit'};
% housings
app.vartypes_HousingTable                   = {'string' 'string' 'string' 'string' 'string' 'double' 'double' 'double' 'double' 'string' 'string' 'double' 'double' 'logical'}; %Data types of the columns must be updated if the table of substances is changed!
app.units_vars_HousingTable                 = {'' '' '' '' '' 'mm' 'g' 'cm³' 'cm³' 'mm' '' 'mm' 'g' ''};
app.id_class_to_HousingTable                = {'Name' 'Type' 'Material' 'MaterialPosPole' 'MaterialNegPole' 'WallThickness' 'Weight' 'Volume'...
                                                    'InnerVolume' 'AvailableStackDimensions' 'FoilMaterials' 'FoilThicknesses' 'FoilWeight' ''};
app.HousingsTable.ColumnName                = {'Name','Type','Materials','Material pos. pole','Material neg. pole','Wall thickness','Weight','Volume','Inner volume','Av. stack dimensions','Foil materials','Foil thickness','Foil weight','Edit'};
app.backup_table_Housing                    = table;
% electrode stacks
app.vartypes_ElectrodeStackTable            = {'string' 'string' 'double' 'string' 'double' 'string' 'double' 'string' 'double' 'double' 'double' 'double' 'double' 'double' 'double' 'double' ...
                                                'logical'}; %Data types of the columns must be updated if the table of electrode stacks is changed!
app.units_vars_ElectrodeStackTable          = {'' '' '' '' '' '' '' '' 'cm³' 'g' 'cm²' 'Ah' 'V' 'V' 'V' 'mOhm' ''};
app.id_class_to_ElectrodeStackTable         = {'Name' 'Anode' 'NrOfAnodes' 'Cathode' 'NrOfCathodes' 'Separator' 'NrOfSeparators' 'Electrolyte' 'Volume' 'Weight' ...
                                                    'ActiveSurface' 'Capacity' 'NominalVoltage' 'MinOpenCircuitVoltage' 'MaxOpenCircuitVoltage' 'InternalResistance' ''};
app.backup_table_ElectrodeStack             = table;
% cells
app.vartypes_CellsTable                     = {'string' 'string' 'string' 'double' 'double' 'double' 'double' 'double' 'double' 'double' 'double' 'double' 'double' 'string' ...
                                                'logical'}; %Data types of the columns must be updated if the table of electrode stacks is changed!
app.units_vars_CellsTable                   = {'' '' '' 'V' 'V' 'V' 'Wh' 'Wh/kg' 'Wh/l' 'mOhm' 'W' 'W/kg' 'W/l' 'Type' ''};
app.id_class_to_CellsTable                  = {'Name' 'ElectrodeStack' 'Housing' 'MaxOpenCircuitVoltageCha' 'NominalVoltage' 'MinOpenCircuitVoltage' 'Energy' 'GravEnergyDensity' 'VolEnergyDensity' 'InternalResistance' ...
                                                    'Power' 'GravPowerDensity' 'VolPowerDensity' 'Type' ''};
app.backup_table_Cells                      = table;
app.CellsTableColumnName                    = {'Name','Electrode stack','Housing','Max. OCV','Nom. OCV','Min. OCV','Energy','Gravimetric energy density',...
                                                'Volumetric energy density','Internal resistance','Power','Gravimetric power density',...
                                                'Volumetric power density','Type','Edit'};
% compare table
app.vartypes_CompareTable                   = {'logical' 'string' 'double' 'double' }; %Data types of the columns must be updated if the compare table is changed!
app.units_vars_CompareTable                 = {'' '' 'Ah' 'W'};
app.id_class_to_CompareTable                = {'' 'Type' 'Energy' 'Power' };
% simulation options tables
app.vartypes_simOptTable                    = {'logical' 'string' 'string' 'double' 'double' 'string' 'double' 'double' 'double' 'double' 'string' 'string'}; %Data types of the columns must be updated if the compare table is changed!
app.units_vars_simOptTable                  = {'' '°C' '%' '°C' '%' '' '' '' 'μs' 'μs' '' ''};
app.id_class_to_simOptTable                 = {'' 'SimulatedTemperatures' 'SimulatedSOCs' 'ambienttemperature' 'StateOfCharge' 'ParticleType' 'ParticleDivision' 'Division' 'StepSize' 'SimulationTime' {'qOCVModus' 'EISModus' 'PulsModus' 'GITTModus' 'ParameterOptiModus'}...
                                                    {'EliminateParticleDiffusion' 'EliminateConcentrationPot' 'EliminateElectrolyteDiffusion' 'EliminatePorousReaction' 'EliminatePorousElectrolyte'}};
% parameter variation table
app.vartypes_paraVarTable                   = {'logical' 'double' 'double' 'double' 'double'}; %Data types of the columns must be updated if the compare table is changed!
app.units_vars_paraVarTable                 = {'' 'x' 'x' 'x' 'x'};
app.id_para_to_listElement                  = {{'Min. common occupancy rate anode'; 'ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1)'}, {'Max. common occupancy rate anode'; 'ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)'},...
                                                {'Min. common occupancy rate cathode'; 'ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1)'},{'Max. common occupancy rate cathode'; 'ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)'}...
                                                    {'Coating thickness anode'; 'ElectrodeStack.Anode.CoatingDimensions(:,3)'}, {'Coating thickness cathode' ; 'ElectrodeStack.Cathode.CoatingDimensions(:,3)'}, {'Porosity cathode' ; 'ElectrodeStack.Cathode.Porosity'}, {'Porosity anode' ; 'ElectrodeStack.Anode.Porosity'}};
% active material variation table
app.vartypes_ACMaterialVaraTable            = {'logical' 'logical' 'string' 'double' 'double' 'double'}; %Data types of the columns must be updated if the compare table is changed!
app.units_vars_ACMaterialVaraTable          = {'' '' '' 'mAh/g' 'V' 'V'};
app.id_class_to_ACMaterialVaraTable         = {'' '' 'ChemFormula' 'GravCapacity' 'MaxOpenCircuitPotential' 'MinOpenCircuitPotentialLith'};
% housing variation table
app.vartypes_HousingVaraTable               = {'logical' 'string' 'double' 'double'}; %Data types of the columns must be updated if the compare table is changed!
app.units_vars_HousingVaraTable             = {'' '' 'cm³' 'g'};
app.id_class_to_HousingVaraTable            = {'' 'Type' 'InnerVolume' 'Weight'};
% varied cells table
app.vartypes_VariedCellsTable               = {'string' 'logical' 'string' 'string' 'string' 'double' 'double' 'double' 'double' 'double' 'double'}; %Data types of the columns must be updated if the compare table is changed!
app.units_vars_VariedCellsTable             = {'' '' '' '' '' 'Wh' 'W' 'V' 'W/kg' 'W/kg' 'mOhm'};
app.id_class_to_VariedCellsTable            = {'Name' '' 'Housing' 'ElectrodeStack.Anode.Coating.ActiveMaterial.Name' 'ElectrodeStack.Cathode.Coating.ActiveMaterial.Name' 'Energy' 'Power' 'NominalVoltage' 'GravEnergyDensity' 'GravPowerDensity' 'InternalResistance'};
%% sensitivity analysis and parameter variation definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HERE DEFINITION OF THE PRIMARY PARAMETER TO VARI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameter variation at analyse tab
app.parameters_to_vari                      = {'None', 'Thickness', 'Max. Concentration', 'Volumne fraction', 'Reaction rate', 'Double-Layer-Capacity-Density','Particle radius', 'Diffusion coefficient', 'SEI resistance', 'Transference number', 'Conductivity',...
                                                'Porosity', 'Terminal resistance', 'Initial Lithium concentration electrolyte', 'Cycleable lithium', 'Tortuosity'};
app.parameters_to_vari_unit                 = {'-', '\mu m', 'mol/m^3', '-', '\frac{m^{2.5}}{s \sqrt{mol}}', 'F/m^2', '\mu m', 'm^2/s', '\Omega m^2', '-', 'S/m', '-','\Omega', 'mol/m^3', 'mol' , ''};
app.parameters_to_vari_components           = {'', {'Anode','Cathode','Separator'}, {'Anode', 'Cathode'}, {'Anode','Cathode'},  {'Anode', 'Cathode'}, {'Anode', 'Cathode'},{'Anode', 'Cathode'},  {'Anode', 'Cathode','Electrolyte'}, {'Anode', 'Cathode'}, {'Electrolyte'},...
                                                {'Anode', 'Cathode','Electrolyte'},{'Anode','Cathode','Separator'},{'Anode', 'Cathode'},{'Electrolyte'},{'ElectrodeStack'},{'Anode','Cathode','Separator'}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
app.parameters_to_vari_Table_VarTypes       = {'logical', 'string', 'double', 'double', 'double', 'double', 'string'};
app.SA_parameter                            = app.parameters_to_vari;
[~,id_none]                                 = ismember('None',app.SA_parameter);
app.SA_parameter(id_none)                   = [];  
temp_formular                               = app.parameters_to_vari_unit;
temp_formular(id_none)                      = [];
temp_components                             = app.parameters_to_vari_components;
temp_components(id_none)                    = [];  
app.SA_parameter_unit                       = arrayfun(@(x) reshape(repmat(temp_formular(x),1,numel(temp_components{x})),numel(temp_components{x}),1),(1 : numel(app.SA_parameter)),'UniformOutput',false);
app.SA_parameter_unit                       = vertcat(app.SA_parameter_unit{:});
temp                                        = arrayfun(@(x) arrayfun(@(y) strjoin([app.SA_parameter(x) temp_components{x}(y)],', '),(1 : numel(temp_components{x})),'UniformOutput',false),(1 : numel(app.SA_parameter)),'UniformOutput',false);
app.SA_parameter                            = cellfun(@(x) x',temp,'UniformOutput',false);
app.SA_parameter                            = vertcat(app.SA_parameter{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HERE PATH TO PRIMARY PARAMETER DEFINITION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%have to have to same length as the app.SA_parameter --- thats only the
%path to the parameter, exception handles due to arrhenius or more
%dimensions take place in the function: fcn_vari_parameter_of_cell
parameter_path                              = {'ElectrodeStack.Anode.CoatingDimensions'; 'ElectrodeStack.Cathode.CoatingDimensions'; 'ElectrodeStack.Separator.Dimensions'; 'ElectrodeStack.Anode.Coating.ActiveMaterial.MaxLithiumConcentration';...
                                                'ElectrodeStack.Cathode.Coating.ActiveMaterial.MaxLithiumConcentration'; 'ElectrodeStack.Anode.Coating.VolumeFractionActiveMaterial'; 'ElectrodeStack.Cathode.Coating.VolumeFractionActiveMaterial';...
                                                'ElectrodeStack.Anode.Coating.ActiveMaterial.ReactionRate'; 'ElectrodeStack.Cathode.Coating.ActiveMaterial.ReactionRate'; 'ElectrodeStack.Anode.Coating.ActiveMaterial.DoubleLayerCapacitanceDensity';...
                                                'ElectrodeStack.Cathode.Coating.ActiveMaterial.DoubleLayerCapacitanceDensity'; 'ElectrodeStack.Anode.Coating.ActiveMaterial.ParticleRadius'; 'ElectrodeStack.Cathode.Coating.ActiveMaterial.ParticleRadius';...
                                                'ElectrodeStack.Anode.Coating.ActiveMaterial.NominalDiffusionCoefficent'; 'ElectrodeStack.Cathode.Coating.ActiveMaterial.NominalDiffusionCoefficent'; 'ElectrodeStack.Electrolyte.DiffusionCoefficient';...
                                                'ElectrodeStack.Anode.Coating.ActiveMaterial.SEIResistance'; 'ElectrodeStack.Cathode.Coating.ActiveMaterial.SEIResistance'; 'ElectrodeStack.Electrolyte.TransferenceNumber';'ElectrodeStack.Anode.Coating.ActiveMaterial.ElectricalConductivity';...
                                                'ElectrodeStack.Cathode.Coating.ActiveMaterial.ElectricalConductivity';'ElectrodeStack.Electrolyte.IonicConductivityNominal';'ElectrodeStack.Anode.Porosity';'ElectrodeStack.Cathode.Porosity';...
                                                'ElectrodeStack.Separator.Porosity'; 'ElectrodeStack.Anode.TerminalResistance'; 'ElectrodeStack.Cathode.TerminalResistance'; 'ElectrodeStack.InitElectrolyteConcentration';'ElectrodeStack.MolLithiumElectrodes';...
                                                'ElectrodeStack.Anode.ElectrolyteTortuosity'; 'ElectrodeStack.Cathode.ElectrolyteTortuosity'; 'ElectrodeStack.Separator.Tortuosity'};
app.parameter_path_to_class                                 = table('Size',[numel(app.SA_parameter),2],'VariableTypes', {'string' 'string'}, 'VariableNames',{'Parameter identificator' 'Parameter path'});
app.parameter_path_to_class.("Parameter identificator")     = app.SA_parameter;
app.parameter_path_to_class.("Parameter path")              = parameter_path;
app.SA_parameter_formular_symbol            = {'L^-'; 'L^+';'L^s'; 'c_{max}^-' ; 'c_{max}^+'; '\epsilon^-'; '\epsilon^+'; 'k^-'; 'k^+'; 'C_{dl}^-'; 'C_{dl}^+'; 'r^-'; 'r^+'; 'D^-'; 'D^+'; 'D^e'; 'R_{SEI}^-'; 'R_{SEI}^+'; 't^+'; '\sigma^-'; '\sigma^+'; '\sigma^e';...
                                                '\epsilon^-_e';'\epsilon^+_e';'\epsilon^s_e';'R_{Terminal}^-';'R_{Terminal}^+'; 'c_0^e';'c_{cycle}'; '\kappa^-';'\kappa^+';'\kappa^e'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SECONDARY PARAMETER DEFINITION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
primary_parameter                           = {'Max. Concentration' 'Cycleable lithium' 'Volumne fraction' 'Reaction rate' 'Diffusion coefficient' 'Conductivity'}; %primary parameter with dependenc to secondary parameter
primary_parameter_component                 = {{'Anode', 'Cathode'} {'Anode', 'Cathode'} {'Anode', 'Cathode'} {'Anode', 'Cathode'} {'Electrolyte'} {'Electrolyte'}};
secondary_parameter                         = {{'Density ACM' 'Molar fraction ACM'} {'Cell Balancing'} {'Density ACM' 'Weight fraction ACM'} {'Exchange current density' 'SOC'} {'Concentration conductiv salt'} {'Ionic conductivity'}};
units_secondary_parameter                   = {{'g/cm³' '-'} {'-'} {'g/cm³' '-'} {'mA/cm²' '-'} {'mol/l'} {'S/m'}};
formular_secondary_parameter                = {{'\rho^X_{ACM}' '\overline{M}^X_{ACM}'} {'-'} {'\rho^X_{ACM}' '\overline{m}^X_{ACM}'} {'j_0^X' 'SOC'} {'c_{Salt}^s'} {'\sigma_{ionic}^e'}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HERE PATH TO SECONDARY PARAMETER DEFINITION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parameter_path_secondary                    = {{'ElectrodeStack.XXX.Coating.ActiveMaterial.Density' 'ElectrodeStack.XXX.Coating.ActiveMaterial.MolarFractions'} {'ElectrodeStack.MolLithiumElectrodes'} {'ElectrodeStack.XXX.Coating.ActiveMaterial.Density' 'ElectrodeStack.XXX.Coating.WeightFractionActiveMaterial'} ...
                                                        {'ElectrodeStack.XXX.Coating.ActiveMaterial.ExchangeCurrentDensity' 'ElectrodeStack.Anode.Coating.ActiveMaterial.ArrheniusReactionRate.Type'} {'ElectrodeStack.Electrolyte.ConductiveSaltMolarity'} {'ElectrodeStack.Electrolyte.IonicConductivityMatrix'}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
secondary_parameter_identification          = arrayfun(@(x) arrayfun(@(y) arrayfun(@(z) strjoin([secondary_parameter{x}(z) primary_parameter_component{x}(y)],', '),(1:numel(secondary_parameter{x})),'UniformOutput',false),(1 : numel(primary_parameter_component{x}))',...
                                                'UniformOutput',false),(1 : numel(primary_parameter)),'UniformOutput',false);
secondary_parameter_identification          = cellfun(@(x) horzcat(x{:})',secondary_parameter_identification,'UniformOutput',false);
secondary_parameter_identification          = vertcat(secondary_parameter_identification{:});
temp                                        = arrayfun(@(x)arrayfun(@(y) repmat({strjoin([primary_parameter(x), primary_parameter_component{x}(y)],', ')},numel(secondary_parameter{x}),1),...
                                                (1:numel(primary_parameter_component{x}))','UniformOutput',false),(1:numel(primary_parameter)),'UniformOutput',false)';
temp                                        = cellfun(@(x) vertcat(x{:}),temp,'UniformOutput',false);
temp                                        = vertcat(temp{:});
primary_parameter_identification            = temp;
temp_units                                  = arrayfun(@(x) repmat(units_secondary_parameter{x},(1:numel(primary_parameter_component{x})))',(1:numel(primary_parameter)),'UniformOutput',false)';
temp_units                                  = vertcat(temp_units{:});
temp_formular                               = arrayfun(@(x) arrayfun(@(y) strrep(formular_secondary_parameter{x},'X',primary_parameter_component{x}(y))',(1:numel(primary_parameter_component{x})),'UniformOutput',false)',...
                                                (1:numel(primary_parameter)),'UniformOutput',false)';
temp_formular                               = cellfun(@(x) vertcat(x{:}),temp_formular,'UniformOutput',false);
temp_formular                               = vertcat(temp_formular{:});
temp_formular                               = cellfun(@(x) strrep(x,'Anode','-'),temp_formular,'UniformOutput',false);
temp_formular                               = cellfun(@(x) strrep(x,'Cathode','+'),temp_formular,'UniformOutput',false);
temp_path                                = arrayfun(@(x) arrayfun(@(y) strrep(parameter_path_secondary{x},'XXX',primary_parameter_component{x}(y))',(1:numel(primary_parameter_component{x})),'UniformOutput',false)',...
                                                (1:numel(primary_parameter)),'UniformOutput',false)';
temp_path                                   = cellfun(@(x) vertcat(x{:}),temp_path,'UniformOutput',false);
temp_path                                   = vertcat(temp_path{:});
app.SA_Secondary_parameter                  = table('Size', [numel(secondary_parameter_identification) 5],'VariableTypes', {'cellstr' 'cellstr' 'cellstr' 'cellstr' 'cellstr'}, 'VariableNames',{'Primary parameter' 'Secondary parameter' 'Unit' 'Formular symbol' 'Secondary parameter path'});
app.SA_Secondary_parameter.("Primary parameter")            = primary_parameter_identification;
app.SA_Secondary_parameter.("Secondary parameter")          = secondary_parameter_identification;
app.SA_Secondary_parameter.("Unit")                         = temp_units;
app.SA_Secondary_parameter.("Formular symbol")              = temp_formular;
app.SA_Secondary_parameter.("Secondary parameter path")     = temp_path;
%% make buttons enable and resize possible
pause(7);
app.CalcpropertiesButton.Enable             = true;
app.PlotCellButton.Enable                   = true;
app.SavecellButton.Enable                   = true;
app.LoadDatabaseButton.Enable               = true;
app.SaveFigureCellButton.Enable             = true;
app.ComparecellsButton.Enable               = true;
app.SaveFigureCompareButton.Enable          = true;
app.ShowvariationsButton.Enable             = true;
app.ExportcellasyamlButton.Enable           = true;
app.ISEAcellpackdatabaseUIFigure.Resize     = 'on';
drawnow;
pause(0.1);
%% change color busy lamp
app.BusyMainLamp.Color                      = [0 1 0];
end 