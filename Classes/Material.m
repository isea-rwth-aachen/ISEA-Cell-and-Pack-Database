classdef Material

    properties
        Name string                     % specific name (for saving in Database)
        Abbreviation string             % used in plots etc.
        ChemFormula string				% written chemical formula
        MolarMass double                % in g/mol
        Density double                  % in g/cm³
        ElectricalConductivity double   % in S*m/m² = S/m
        ThermalConductivity double      % in W/(m*K) = W*m/(m*K)
        ThermalCapacity double          % in J/(kg*K)
        MeltingPoint double             % in °C
        BoilingPoint double             % in °C
        AddInfo struct                  % any additional info that has to be added to material
        Source string                   % literature source, measurements, etc.
        Confidential string             % 'Yes' or 'No'
    end

    %% Methods
    methods
        % constructor
        function obj = Material()
            if nargin==0
                return
            end
        end
        % get method
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Material return 0']);
                output = 0;
            end
        end
        % set method
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Material']);
            end
        end
        % calculate molar mass of the active material
        function TotalMolarMass = CalcMolarMass(ListOfElements, ListOfMolarFractions)
            if length(ListOfElements)~=length(ListOfMolarFractions)
                error('Vectors must be the same length (ListOfElements and ListOfMolarFractions)');
            end
            TotalMolarMass = 0;
            for index = 1:length(ListOfElements)
                TotalMolarMass = TotalMolarMass + ListOfMolarFractions(index) * ListOfElements(index).MolarMass;
            end
        end
        % determination of complete chemical formula from molar fraction
        % and Elements
        function TotalChemFormula = DetermineChemFormula(ListOfElements, ListOfMolarFractions)
            if length(ListOfElements)~=length(ListOfMolarFractions)
                error('Vectors must be the same length (ListOfElements and ListOfMolarFractions)');
            end
            TotalChemFormula = '';
            for index = 1:length(ListOfElements)
                if isnan(ListOfMolarFractions(index))
                    Fraction = 'x';
                else
                    Fraction = num2str(ListOfMolarFractions(index));
                end
                TotalChemFormula = [TotalChemFormula, ListOfElements(index).ChemFormula{1}, '', Fraction, ' '];
            end
        end
    end
end

