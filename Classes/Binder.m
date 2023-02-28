classdef Binder < Material

    properties
        Elements Element        % list of Elements (referring to MolarFractions)
        MolarFractions double   % list of MolarFractions (referring to Elements)
    end
    %% public methods
    methods
        % constructor
        function obj = Binder(Name, Elements, MolarFractions)
            %Binder Construct an instance of this class
            %   Detailed explanation goes here
            obj.Name = Name;
            obj.Elements = Elements;
            obj.MolarFractions = MolarFractions;
            obj.MolarMass = CalcMolarMass(Elements, MolarFractions);
            obj.ChemFormula = DetermineChemFormula(Elements, MolarFractions);
        end
    end
end

