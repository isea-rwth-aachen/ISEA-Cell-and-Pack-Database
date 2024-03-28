classdef Electrolyte

    properties
        Name string
        ConductiveSalt ConductiveSalt
        ConductiveSaltMolarity double       % equilibrium Molarity / Molar concentration in mol/l eg 1M LiPF6 equals 1 mol per liter of solvent mixture
        ConductiveSaltWeightFraction double % no unit (or wt%/100%)
        Solvents Solvent
        SolventVolumeFractions double       % no unit (or vol%/100%)
        SolventWeightFractions double       % no unit (or wt%/100%)
        TemperatureVector double            % in °C; referring to colums of IonicConductivity matrix
        ConductiveSaltMolarityVector double % in mol/l; referring to rows of IonicConductivity matrix
        IonicConductivityMatrix double      % in S*m/m² = S/m
        IonicConductivityNominal double     % in S*m/m² = S/m
        Density double                      % in g/cm³
        DensitySolventMixture double        % in g/cm³

        ThermalConductivity double  		% in W/(m*K) = W*m/(m²*K)
        ThermalCapacity double 				% in J/(kg*K)
        DiffusionCoefficient 				% in m²/s

        TransferenceNumber
        ConductivityArrhenius
        DiffusionArrhenius

        AddInfo struct                      % any additional info that has to be added to material
        Source string                       % literature source, measurements, etc.
        Confidential string                 % 'Yes' or 'No'
    end
    %% Methods
    methods
        %constructor
        function obj = Electrolyte(Name, ConductiveSalt, ConductiveSaltMolarity, Solvents, SolventVolumeFractions, ICM)
            obj.Name = Name;
            obj.ConductiveSalt = ConductiveSalt;
            obj.ConductiveSaltMolarity = ConductiveSaltMolarity;
            obj.Solvents = Solvents;
            obj.SolventVolumeFractions = SolventVolumeFractions;
            obj.TemperatureVector = ICM.TemperatureVector;
            obj.ConductiveSaltMolarityVector = ICM.ConductiveSaltMolarityVector;
            obj.IonicConductivityMatrix = ICM.IonicConductivityMatrix;
            obj = CalcDensity(obj);
            obj = CalcWeightFractions(obj);
            obj = CalcIonicConductivityNominal(obj);
            obj = GetArrheniusConductivity(obj);
            obj = CalcThermalConductivity(obj);
            obj = CalcThermalCapacity(obj);
            obj = CalcDiffusionCoefficient(obj);
            if exist('TransferenceNumber','var')
                obj.TransferenceNumber          = TransferenceNumber;
            end
        end
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Electrolyte return 0']);
                output = 0;
            end
        end
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Electrolyte']);
            end
        end
        % overload compare operator
        function logical = eq(A,B)
            name_A           = GetProperty(A,'Name');
            name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
            logical          = strcmp(name_A,name_B);
        end
    end
    %% Public Methods
    methods (Access = public)
        % update calculations after changing parameters
        function obj = RefreshCalc(obj)
            obj = CalcDensity(obj);
            obj = CalcWeightFractions(obj);
            obj = CalcIonicConductivityNominal(obj);
            obj = GetArrheniusConductivity(obj);
            obj = CalcCosts(obj);
            obj = CalcDiffusionCoefficient(obj);
        end
    end
    %% Private Methods
    methods (Access = private)
        % calculation of the density
        function obj = CalcDensity(obj)
            obj.DensitySolventMixture = 0;
            for index = 1:length(obj.Solvents)
                obj.DensitySolventMixture = obj.DensitySolventMixture + obj.Solvents(index).Density * obj.SolventVolumeFractions(index);
            end
            obj.Density = (obj.DensitySolventMixture + obj.ConductiveSalt.MolarMass*obj.ConductiveSaltMolarity/1000) / (1 + obj.ConductiveSalt.MolarMass*obj.ConductiveSaltMolarity/1000/obj.ConductiveSalt.Density); % in g/cm³ therefore molarity (in mol/l) needs to be converted into mol/cm³
        end
        % calculation of the weight fractions
        function obj = CalcWeightFractions(obj)
            obj.SolventWeightFractions = zeros(size(obj.SolventVolumeFractions));
            for index = 1:length(obj.Solvents)
                obj.SolventWeightFractions(index) = obj.Solvents(index).Density / obj.Density * obj.SolventVolumeFractions(index);
            end
            obj.ConductiveSaltWeightFraction = 1-sum(obj.SolventWeightFractions);
        end
        % calculation of the ionic conductivity
        function obj = CalcIonicConductivityNominal(obj)
            TargetTemperature = 20;
            obj.IonicConductivityNominal = interp2(obj.TemperatureVector, obj.ConductiveSaltMolarityVector, obj.IonicConductivityMatrix, TargetTemperature, obj.ConductiveSaltMolarity);
        end
        % calculation of the thermal conductivity
        function obj = CalcThermalConductivity(obj)
            CoordinationNumber = 12;
            VolumeFractionTempSum = 0;
            for index = 1:numel(obj.Materials)
                VolumeFractionTempSum = VolumeFractionTempSum + obj.WeightFractions(index) / obj.Materials(index).Density;
            end
            for index = 1:numel(obj.Materials)
                obj.VolumeFractions(index) = obj.WeightFractions(index) / obj.Materials(index).Density / VolumeFractionTempSum;
                ThermalConductivities(index) = obj.Materials(index).ThermalConductivity;
            end
            obj.ThermalConductivity = FcnRecursiveEffectiveMediumTheory(ThermalConductivities, obj.VolumeFractions, CoordinationNumber);
        end
        % calculation of the ionic capacity
        function obj = CalcThermalCapacity(obj)
            obj.ThermalCapacity = 0;
            for index = 1:numel(obj.Materials)
                obj.ThermalCapacity = obj.ThermalCapacity + obj.WeightFractions(index) * obj.Materials(index).ThermalCapacity;
            end
        end
        % calculation of the diffusion coefficient
        function obj = CalcDiffusionCoefficient(obj)
            if isprop(obj,'IonicConductivityNominal')
                charge_ion                  = 1.602176634E-19; % C
                boltzman_const              = 1.380649E-23; % J/K
                conductivity                = obj.IonicConductivityNominal; % S/m
                temperature                 = 25 + 273.15; % 25°C in Kelvin
                avogadro_constant           = 6.02214076E23; %1/mol
                concentration_lith_el       = obj.ConductiveSaltMolarity; %mol/l
                diffusion_coef              = (conductivity * boltzman_const * temperature) / (power(charge_ion,2) * avogadro_constant * concentration_lith_el * 1E3); % in m²/s
                obj.DiffusionCoefficient    = diffusion_coef;
                Arrhenius_Diffusion         = Arrhenius([convertStringsToChars(obj.Name) '_Diffusion'],diffusion_coef,'Scalar',obj.ConductivityArrhenius.ActivationEnergy);
                obj.DiffusionArrhenius      = Arrhenius_Diffusion;
            else
                warning(['No nominal ionic conductivity for the electrolyte ' convertStringsToChars(obj.Name) ' available, check ICM of the electrolyte']);
                obj.DiffusionCoefficient    = [];
            end
        end
        % function to get Arrhenius conductivity
        function obj = GetArrheniusConductivity(obj)
            ActivationEnergy                = fcn_calc_ArrheniusEquation_ActivationEnergy(obj.TemperatureVector,obj.IonicConductivityMatrix,obj.ConductiveSaltMolarityVector);
            target_temp                     = 25; %°C
            target_molarity                 = (0.25 : .125 : 1.75) .* 1000; %in mol/m³
            idx_rows                        = arrayfun(@(x) all(isnan(obj.IonicConductivityMatrix(x,:))), (1 : size(obj.IonicConductivityMatrix,1)));
            temp_ICM                        = obj.IonicConductivityMatrix(~idx_rows,:);
            idx_colums                      = arrayfun(@(x) any(isnan(temp_ICM(:,x))), (1 : size(temp_ICM,2)));
            temp_ICM                        = temp_ICM(:,~idx_colums);
            temperature                     = obj.TemperatureVector(~idx_colums);
            salt_molarity                   = obj.ConductiveSaltMolarityVector(~idx_rows);
            conductivity                    = interp2(temperature, salt_molarity .* 1000,temp_ICM, target_temp, target_molarity,'spline'); %in mol/m³
            fit_exponents                   = [1,2,3,4];
            fit_icm                         = easyfit(target_molarity,conductivity,fit_exponents);
            Expression.function             = strjoin(arrayfun(@(x) [num2str(fit_icm(x)) '*x^' num2str(numel(fit_exponents)-x)],(1:numel(fit_icm)), 'UniformOutput',false),'+');
            Expression.exponents            = fit_exponents;
            Expression.create_function      = @(x,y,z) easyfit(y,x,z);
            Expression.y                    = target_molarity;
            Expression.x                    = conductivity;
            Arrhenius_Conductivity          = Arrhenius([convertStringsToChars(obj.Name) '_Conductivity'],Expression,'Function',ActivationEnergy);
            obj.ConductivityArrhenius       = Arrhenius_Conductivity;
        end
    end
end