classdef ActiveMaterial < Material
    
    properties
        %% Properties
        % Properties of a object of the type active material. Some of them
        % are part of the input and some of them get calculated during the
        % creation of the object

        TransferMaterial Material                       % Material (doing the ion transport)
        Elements Element                                % list of Elements (referring to MolarFractions)
        MolarFractions double                           % array of molar fractions (referring to Elements)
        OpenCircuitPotential double                     % lookup table for OCP (referring to OccupancyRate)
        OpenCircuitPotentialLith double                 % lookup table for OCP for lithiation (referring to OccupancyRate)
        OccupancyRate double                            % lookup table for OccupancyRate (referring to OpenCircuitPotential)
        OcpReferenceMaterial Material                   % reference material for OCP curve (Li/Li+ for Li-Ion Batteries)
        CommonOccupancyRange double                     % occupancy range which has been used commonly [min, max]                                                                   
        
        MinOpenCircuitPotential double                  % in V
        MaxOpenCircuitPotential double                  % in V
        NominalOpenCircuitPotential double              % in V
        MinOpenCircuitPotentialLith double              % in V
        MaxOpenCircuitPotentialLith double              % in V
        NominalOpenCircuitPotentialLith double          % in V
        
        OccupancyRateCommonOR double                    % occupancy rate as known                                                                                                                    %Berechnet
        
        OpenCircuitPotentialCommonOR double             % lookup table for OCP (referring to OccupancyRate, delithiation) in V
        MinOpenCircuitPotentialCommonOR double          % min OCP (referring to OccupancyRate, delithiation) in V
        MaxOpenCircuitPotentialCommonOR double          % max OCP (referring to OccupancyRate, delithiation) in V
        NominalOpenCircuitPotentialCommonOR double      % nominal OCP (referring to OccupancyRate, delithiation) in V
        OpenCircuitPotentialCommonORLith double         % lookup table for OCP for lithiation (referring to OccupancyRate) in V
        MinOpenCircuitPotentialCommonORLith double      % min OCP (referring to OccupancyRate, lithiation) in V
        MaxOpenCircuitPotentialCommonORLith double      % max OCP (referring to OccupancyRate, lithiation) in V
        NominalOpenCircuitPotentialCommonORLith double  % nominal OCP (referring to OccupancyRate, lithiation) in V                                                                                                                  %Berechnet
        
        MaxLithiumConcentration double                  % max. lithium concentration in mol/m³                                                                                           %Berechnet
        
        WeightFractions double                          % array of weight fractions (referring to Elements)
        GravCapacity double                             % gravimetric capacity excluding transfer material in mAh/g
        GravCapacityMaxOR double                        % gravimetric capacity for the range of the given OR/OCP curve (utilized from first till last value rather than common OR) excluding transfer material in mAh/g
        TheoGravCapacity double                         % theoretical gravimetric capacity excluding transfer material in mAh/g
        MaxConcentration double                         % maximum concentration of transfer material in mol/m³
        MinMaxOccupancyRange double                     % maximum occupancy range which can be used [min, max]
        ExchangeCurrentDensity double                   % i0 from Butler Volmer equation in mA/cm²
        ChargeTransferKineticCoefficient double         % alpha from Butler Volmer equation
        RelVolumeIncreaseOnLith double                  % relative increase of volume per x Li                                                                                          %????
        
        ReactionRate double                             % reaction rate connected to the butler volmer equation             
        DoubleLayerCapacitanceDensity double            % in F/m^2 
        SEIResistance double = 0;                       % in Ohm/m                                                                                                                             %Eingelesen
        ParticleRadius double                           % in µm
        NominalDiffusionCoefficent                      % in m²/s                                                                                                                            %Berechnet
        
        ArrheniusConductivity Arrhenius                 % Arrhenius object for conductivity
        ArrheniusReactionRate Arrhenius                 % Arrhenius object for reaction rate                                                                                                                %Berechnet
        ArrheniusDiffusion Arrhenius                    % Arrhenius object for diffusion                                                                                                                %Eingelesen
        ArrheniusOCV Arrhenius                          % Arrhenius object for OCV
                                                                                                                                %Assigned
    end
    %% Methods
    methods
        %Constructor
        function obj = ActiveMaterial(Name, TransferMaterial, Elements, MolarFractions, OpenCircuitPotential, OccupancyRate, OcpReferenceMaterial, CommonOccupancyRange, Density,...
                            ExchangeCurrentDensity,ParticleRadius,ArrheniusDiffusion,ActivationEnergyI0,DoubleLayerCapacity,Conductivity,SEI_resistance)
            if nargin==0
                return
            end
            obj.Name                            = Name;
            obj.TransferMaterial                = TransferMaterial;
            obj.Elements                        = Elements;
            obj.MolarFractions                  = MolarFractions;
            obj.MolarMass                       = CalcMolarMass(Elements, MolarFractions); % excluding TransferMaterial
            
            if exist('ExchangeCurrentDensity','var')&& ~isempty(ExchangeCurrentDensity)
                obj.ExchangeCurrentDensity      = ExchangeCurrentDensity;
            else
                obj.ExchangeCurrentDensity      = 0;
            end
            
            if exist('ParticleRadius','var')&& ~isempty(ParticleRadius)
                obj.ParticleRadius              = ParticleRadius;
            else
                obj.ParticleRadius              = 2.5;%value Mark Juncker
            end
            
            
            if exist('ArrheniusDiffusion', 'var') && ~isempty(ArrheniusDiffusion) && isa(ArrheniusDiffusion,'Arrhenius')
                obj.ArrheniusDiffusion          = ArrheniusDiffusion;
            elseif exist('ArrheniusDiffusion', 'var') && isnumeric(ArrheniusDiffusion)
                obj.ArrheniusDiffusion          = Arrhenius(['Diffusion_ ' convertCharsToStrings(obj.Name)],ArrheniusDiffusion,'Scalar');
            else
                obj.ArrheniusDiffusion          = Arrhenius(['Diffusion_ ' convertCharsToStrings(obj.Name)],1E-10,'Scalar'); %value Mark Juncker
            end
            
            if ~exist('ActivationEnergyI0','var')
                ActivationEnergyI0              = 0;
            end
            
            if ~exist('DoubleLayerCapacity','var')
                DoubleLayerCapacity             = 0;
            end
            
            if exist('Conductivity','var')
                obj.ElectricalConductivity              = Conductivity;
                obj.AddInfo.MeasurementElConductivity   = true;
                obj.ArrheniusConductivity               = Arrhenius(['Conductivity_' convertCharsToStrings(obj.Name)],Conductivity,'Scalar');
            else
                obj                                 = CalcElectricConductivity(obj);
                obj.ArrheniusConductivity           = Arrhenius(['Conductivity_' convertCharsToStrings(obj.Name)],obj.ElectricalConductivity,'Scalar');
            end
            
            if exist('SEI_resistance','var')
                obj.SEIResistance           = SEI_resistance;
            else
                obj.SEIResistance           = 0;
            end
            
            if isa(OpenCircuitPotential, 'OCV') %OCV Object as input
                
                obj.OpenCircuitPotential = OpenCircuitPotential.OpenCircuitPotential;
                obj.OpenCircuitPotentialLith = OpenCircuitPotential.OpenCircuitPotentialLith;
                obj.OccupancyRate = OpenCircuitPotential.OccupancyRate;
                
            else %Array as input                 
                SizeOCP = size(OpenCircuitPotential);
                if SizeOCP(1) > SizeOCP(2)
                    obj.OpenCircuitPotential = OpenCircuitPotential;
                else
                    obj.OpenCircuitPotential = OpenCircuitPotential';
                end
                obj.OpenCircuitPotentialLith = obj.OpenCircuitPotential;
                SizeOR = size(OccupancyRate);
                if SizeOR(1) > SizeOR(2)
                    obj.OccupancyRate = OccupancyRate;
                else
                    obj.OccupancyRate = OccupancyRate';
                end
            end
            
            obj.OcpReferenceMaterial = OcpReferenceMaterial;
            obj.CommonOccupancyRange = CommonOccupancyRange;
            obj.Density = Density;
            obj.RelVolumeIncreaseOnLith = 0; %no volume change by default
            obj.DoubleLayerCapacitanceDensity   = DoubleLayerCapacity;
            
            obj.MinMaxOccupancyRange(1)         = min(obj.OccupancyRate);
            obj.MinMaxOccupancyRange(2)         = max(obj.OccupancyRate);
            obj.ChemFormula                     = DetermineChemFormula([TransferMaterial, Elements], [NaN, MolarFractions]);
            obj.MaxLithiumConcentration         = obj.MinMaxOccupancyRange(2) / obj.MolarMass * obj.Density *1E6; 
            obj                                 = CalcGravCapacity(obj);
            obj                                 = CalcVoltages(obj);
            
            obj.ArrheniusReactionRate           = Arrhenius([],[],'',[]);
%            obj.ArrheniusDiffusion              = Arrhenius([],[],'',[]);
            obj.ArrheniusOCV                    = Arrhenius([],[],'',[]);
            
            obj                                 = CalcReactionRate(obj,ActivationEnergyI0);
        end
    end
    %% public methods
    methods (Access = public)
        % refreshes all calculations on the active material level (use if
        % paramters are changed)
        function obj = RefreshCalc(obj)
            if isempty(obj.RelVolumeIncreaseOnLith)
                obj.RelVolumeIncreaseOnLith = 0;
                warning(['Changed value of the propertie relative volumne increase on lithium of the active material ' char(obj.Name) ' to the default value 0.']);
            end
            obj.MinMaxOccupancyRange(1)         = min(obj.OccupancyRate);
            obj.MinMaxOccupancyRange(2)         = max(obj.OccupancyRate);
            obj.ChemFormula                     = DetermineChemFormula([obj.TransferMaterial, obj.Elements], [NaN, obj.MolarFractions]);
            obj.MolarMass                       = CalcMolarMass(obj.Elements, obj.MolarFractions); % excluding TransferMaterial
            obj = CalcGravCapacity(obj);
            obj = CalcVoltages(obj);
            obj = CalcCosts(obj);
            obj.MaxLithiumConcentration         = obj.MinMaxOccupancyRange(2) / obj.MolarMass * obj.Density *1E6;
            if ~isfield(obj.ArrheniusReactionRate,'ActivationEnergy')
                obj = CalcReactionRate(obj,0);
            else
                obj = CalcReactionRate(obj,obj.ArrheniusReactionRate.ActivationEnergy);
            end
            if isfield(obj,'AddInfo') && isfield(obj.AddInfo,'MeasurementElConductivity') && obj.AddInfo.MeasurementElConductivity
                return;
            else
                obj = CalcElectricConductivity(obj);
            end
        end
        % calculation of gravimetric capacity
        function obj = CalcGravCapacity(obj)
            F = 96485; % Faraday constant in As/mol
            z = min(abs(obj.TransferMaterial.OxidationStates));
            obj.TheoGravCapacity = z * F / obj.MolarMass * 1000 / 3600; % in mAh/g
            obj.GravCapacityMaxOR = obj.TheoGravCapacity * (obj.MinMaxOccupancyRange(2) - obj.MinMaxOccupancyRange(1)); % in mAh/g
            obj.GravCapacity = obj.TheoGravCapacity * (obj.CommonOccupancyRange(2) - obj.CommonOccupancyRange(1)); % in mAh/g
            obj.MaxConcentration = z * obj.Density / obj.MolarMass * 1e6; % in (g/cm³)/(g/mol)*1e6 cm³/m³ = mol/m³
        end
        % in case limitation of the voltage to any requirements from
        % certain applications is necessary
        function obj = SetVoltageLimits(obj, VoltageLimits)
            minV = VoltageLimits(1);
            maxV = VoltageLimits(2);
            if obj.MaxOpenCircuitPotential > maxV
                obj.CommonOccupancyRange(1)=interp1(obj.OpenCircuitPotential, obj.OccupancyRate, maxV);
            end
            if obj.MinOpenCircuitPotentialLith < minV
                obj.CommonOccupancyRange(2)=interp1(obj.OpenCircuitPotentialLith, obj.OccupancyRate, minV);
            end
            obj = RefreshCalc(obj);
        end
        % set use range limits for example for certain safety margins
        function obj = SetUseRange(obj, Range)
            %sets the occupancy range based on the maximum occupancy range
            maxOR = max(obj.OccupancyRate);
            minOR = min(obj.OccupancyRate);
            if (Range(2)>1) || (Range(1)<0)
                error('Limits for relative range of use have to be placed between 0 and 1')
            end
            obj.CommonOccupancyRange(1) = minOR + Range(1)*(maxOR - minOR);
            obj.CommonOccupancyRange(2) = minOR + Range(2)*(maxOR - minOR);
            obj = obj.RefreshCalc();
        end
        % sweeping over the OCP
        function [ocp_array_delith,ocp_array_lith,x_sweeping] = SweepOCP(obj,range)
            x_min           = min(obj.MinMaxOccupancyRange);
            x_max           = max(obj.MinMaxOccupancyRange);
            diff_range_max  = x_max - range - x_min;
            x_diff_sweep    = (0:0.001:diff_range_max);
            soc_step        = 0:0.001:1;
            x_sweeping      = arrayfun(@(x) linspace(x_min + x, x_max + x - diff_range_max,numel(soc_step)),x_diff_sweep,'UniformOutput',false);
            ocp_array_delith    = cellfun(@(x) interp1(obj.OccupancyRate,obj.OpenCircuitPotential,x,'spline'),x_sweeping,'UniformOutput',false); 
            ocp_array_lith      = cellfun(@(x) interp1(obj.OccupancyRate,obj.OpenCircuitPotentialLith,x,'spline'),x_sweeping,'UniformOutput',false);
        end
        % calculation of the reaction rate
        function obj = CalcReactionRate(obj,activation_energy,temperature,init_concentration_electrolyte)
            if isprop(obj,'ExchangeCurrentDensity') && ~isempty(obj.ExchangeCurrentDensity) && obj.ExchangeCurrentDensity ~= 0 && ~isempty(obj.MaxLithiumConcentration)
                max_lith                    = obj.MaxLithiumConcentration;
                exchange_current            = obj.ExchangeCurrentDensity;
                if exist('init_concentration_electrolyte','var')
                    lith_electrolyte            = init_concentration_electrolyte;
                else
                    lith_electrolyte            = 1000; %mol/m³
                end
                lith_ACMaterial             = 0.5 * max_lith; % 50% SOC as steady state
                farrady_const               = 9.64853321233100184E4; %As/mol
                reaction_rate               = exchange_current * 10 / (farrady_const * sqrt(lith_ACMaterial * (max_lith - lith_ACMaterial) * lith_electrolyte));
                obj.ReactionRate            = reaction_rate;
                if exist('temperature','var')
                    obj.ArrheniusReactionRate   = Arrhenius([convertStringsToChars(obj.Name) 'ArrheniusReactionRate'],reaction_rate,'Scalar',activation_energy,temperature);
                else
                    obj.ArrheniusReactionRate   = Arrhenius([convertStringsToChars(obj.Name) 'ArrheniusReactionRate'],reaction_rate,'Scalar',activation_energy);
                end
            else
               warning(['No reaction rate of the active material ' convertStringsToChars(obj.Name) ' could be calculated.']);
               obj.ReactionRate     = [];
            end
        end
    end
    %% private methods
    methods (Access = private)
        function obj = CalcVoltages(obj)
            obj.MinOpenCircuitPotential = min(obj.OpenCircuitPotential);
            obj.MaxOpenCircuitPotential = max(obj.OpenCircuitPotential);
            obj.NominalOpenCircuitPotential = trapz(obj.OccupancyRate, obj.OpenCircuitPotential)/(obj.MinMaxOccupancyRange(2)-obj.MinMaxOccupancyRange(1));
            obj.MinOpenCircuitPotentialLith = min(obj.OpenCircuitPotentialLith);
            obj.MaxOpenCircuitPotentialLith = max(obj.OpenCircuitPotentialLith);
            obj.NominalOpenCircuitPotentialLith = trapz(obj.OccupancyRate, obj.OpenCircuitPotentialLith)/(obj.MinMaxOccupancyRange(2)-obj.MinMaxOccupancyRange(1));
            obj.OccupancyRateCommonOR = linspace(obj.CommonOccupancyRange(1), obj.CommonOccupancyRange(2), 1000);
            obj.OpenCircuitPotentialCommonOR = interp1(obj.OccupancyRate, obj.OpenCircuitPotential, obj.OccupancyRateCommonOR, 'linear');
            obj.MinOpenCircuitPotentialCommonOR = min(obj.OpenCircuitPotentialCommonOR);
            obj.MaxOpenCircuitPotentialCommonOR = max(obj.OpenCircuitPotentialCommonOR);
            obj.NominalOpenCircuitPotentialCommonOR = trapz(obj.OccupancyRateCommonOR, obj.OpenCircuitPotentialCommonOR)/(max(obj.OccupancyRateCommonOR)-min(obj.OccupancyRateCommonOR));
            obj.OpenCircuitPotentialCommonORLith = interp1(obj.OccupancyRate, obj.OpenCircuitPotentialLith, obj.OccupancyRateCommonOR, 'linear');
            obj.MinOpenCircuitPotentialCommonORLith = min(obj.OpenCircuitPotentialCommonORLith);
            obj.MaxOpenCircuitPotentialCommonORLith = max(obj.OpenCircuitPotentialCommonORLith);
            obj.NominalOpenCircuitPotentialCommonORLith = trapz(obj.OccupancyRateCommonOR, obj.OpenCircuitPotentialCommonORLith)/(max(obj.OccupancyRateCommonOR)-min(obj.OccupancyRateCommonOR));
        end
        % calculation of the electrical conductivity by recursive
        % effectrive medium theory
        function obj = CalcElectricConductivity(obj)
            CoordinationNumber = 12;
            EffectiveProperties                                 = arrayfun(@(x) GetProperty(obj.Elements(x),'ElectricalConductivity'),(1 : numel(obj.Elements)));
            EffectiveProperties(isnan(EffectiveProperties))     = 0;
            obj.ElectricalConductivity = FcnRecursiveEffectiveMediumTheory(EffectiveProperties, obj.VolumeFractions, CoordinationNumber);
        end
    end
end