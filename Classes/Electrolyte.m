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
    end
end