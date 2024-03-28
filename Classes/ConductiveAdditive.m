classdef ConductiveAdditive < Material

    properties
        Elements Element        % list of Elements (referring to MolarFractions)
        MolarFractions double   % list of MolarFractions (referring to Elements)
    end
    %% Methods
    methods
        % constructor
        function obj = ConductiveAdditive(Name, Elements, MolarFractions)
            obj.Name = Name;
            obj.Elements = Elements;
            obj.MolarFractions = MolarFractions;
            obj.MolarMass = CalcMolarMass(Elements, MolarFractions);
            obj.ChemFormula = DetermineChemFormula(Elements, MolarFractions);
        end
    end
end