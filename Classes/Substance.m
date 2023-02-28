classdef Substance < Material

    properties
        Materials Material              % list of Materials (referring to MolarFractions)
        MolarFractions double           % list of molar fractions (referring to Materials)
        WeightFractions double          % list of weight fractions (referring to Materials)
        Elements Element                % list of Elements based on Materials and MolarFractions
        ElementsMolarFractions double   % list of molar fractions (referring to Materials)
        ElementsWeightFractions double  % list of weight fractions (referring to Materials)
    end
    %% Methods
    methods
        %constructor
        function obj = Substance(Name, Materials, MolarFractions, Density)
            obj.Name = Name;
            obj.Materials = Materials;
            obj.MolarFractions = MolarFractions;
            obj.Density = Density;

            obj.ChemFormula = DetermineChemFormula(Materials, MolarFractions);
            obj.MolarMass = CalcMolarMass(Materials, MolarFractions);
            obj = CalcWeightFractions(obj);
            obj = CalcElements(obj);
        end
    end
    %% Private Methods
    methods (Access = private)
        %calculation of the weight fractions
        function obj = CalcWeightFractions(obj)
            for index = 1:length(obj.Materials)
                obj.WeightFractions(index) = obj.Materials(index).MolarMass * obj.MolarFractions(index) / obj.MolarMass;
            end
        end
        %creation of the elements list
        function obj = CalcElements(obj)
            if isa(obj.Materials(1), 'Element')
                obj.Elements = obj.Materials;
                obj.ElementsMolarFractions = obj.MolarFractions;
                obj.ElementsWeightFractions = obj.WeightFractions;
            elseif isa(obj.Materials(1), 'Substance')
                obj.Elements = obj.Materials(1).Elements;
                obj.ElementsMolarFractions = obj.Materials(1).ElementsMolarFractions * obj.MolarFractions(1);
                for index = 2:length(obj.Materials)
                    obj.Elements = [obj.Elements, obj.Materials(index).Elements];
                    obj.ElementsMolarFractions = [obj.ElementsMolarFractions, obj.Materials(index).ElementsMolarFractions * obj.MolarFractions(index)];
                end
                for index = 1:length(obj.Elements)
                    obj.ElementsWeightFractions(index) = obj.Elements(index).MolarMass * obj.ElementsMolarFractions(index) / obj.MolarMass;
                end
            else
                warning('Incorrect data type!');
            end
        end
    end
end