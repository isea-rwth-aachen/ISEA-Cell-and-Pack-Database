classdef Solvent < Material

    properties
        Elements Element            % list of Elements (referring to MolarFractions)
        MolarFractions double       % list of molar fractions (referring to Elements)
        WeightFractions double      % list of weight fractions (referring to Elements)
        IonicConductivity double    % in S*m/m² = S/m
        Viscosity double            % in mPa*s = Milli pascal seconds = cP = Centipoise
        RelativePermittivity double % no unit
        TemperatureVector double    % referring to values in Viscosity and RelativePermittivity
    end
    %% Methods
    methods
        %constructor
        function obj = Solvent(Name, Elements, MolarFractions, Density)
            obj.Name = Name;
            obj.Elements = Elements;
            obj.MolarFractions = MolarFractions;
            obj.Density = Density;

            obj.ChemFormula = DetermineChemFormula(Elements, MolarFractions);
            obj.MolarMass = CalcMolarMass(Elements, MolarFractions);
            obj = CalcWeightFractions(obj);
        end
        %get method
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Solvent return 0']);
                output = 0;
            end
        end
        %set method
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Solvent']);
            end
        end
    end
    %% Private Methods
    methods (Access = private)
        %calculation of the weight fractions
        function obj = CalcWeightFractions(obj)
            obj.WeightFractions = zeros(size(obj.MolarFractions));
            for index = 1:length(obj.Elements)
                obj.WeightFractions(index) = obj.Elements(index).MolarMass * obj.MolarFractions(index) / obj.MolarMass;
            end
        end
    end
end

