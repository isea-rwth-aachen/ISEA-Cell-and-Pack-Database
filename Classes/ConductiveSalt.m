classdef ConductiveSalt < Material

    properties
        TransferMaterial Material
        Elements Element            % list of Elements (referring to MolarFractions)
        MolarFractions double       % list of molar fractions (referring to Elements)
        WeightFractions double      % list of weight fractions (referring to Elements)
        IonicConductivity double    % in S*m/m² = S/m
    end
    %% Methods
    methods
        % constructor
        function obj = ConductiveSalt(Name, TransferMaterial, Elements, MolarFractions, Density)
            obj.Name = Name;
            obj.TransferMaterial = TransferMaterial;
            obj.Elements = Elements;
            obj.MolarFractions = MolarFractions;
            obj.Density = Density;
            obj.ChemFormula = DetermineChemFormula([TransferMaterial, Elements], [NaN, MolarFractions]);
            obj.MolarMass = CalcMolarMass(Elements, MolarFractions); % excluding TransferMaterial
            obj = CalcWeightFractions(obj);
        end
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class ConductiveSalt return 0']);
                output = 0;
            end
        end
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class ConductiveSalt']);
            end
        end
    end
    %% Private Methods
    methods (Access = private)
        % calculate weigth fraction of all ingredients
        function obj = CalcWeightFractions(obj)
            obj.WeightFractions = zeros(size(obj.MolarFractions));
            for index = 1:length(obj.Elements)
                obj.WeightFractions(index) = obj.Elements(index).MolarMass * obj.MolarFractions(index) / obj.MolarMass;
            end
        end
    end
end