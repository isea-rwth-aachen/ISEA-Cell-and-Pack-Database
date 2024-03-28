classdef Separator
    
    properties
        Name string
        Materials Material                  % list of consisting materials
        WeightFractions double              % no unit, in sum 1
        VolumeFractions double              % no unit, in sum 1
        Dimensions double                   % width, height, thickness in mm
        Porosity double                     % no unit
        Tortuosity double                   % no unit
        Density double                      % in g/cm³
        Volume double                       % in cm³
        Weight double                       % in g
        ElectrolyteAvailableVolume double   % in cm³
        SurfaceArea double                  % in cm²
        
		ThermalConductivity double  		% in W/(m*K) = W*m/(m²*K)
        ThermalCapacity double 				% in J/(kg*K)
		
        AddInfo struct                      % any additional info that has to be added to material
        Source string                       % literature source, measurements, etc.
        Confidential string                 % 'Yes' or 'No'
    end
    %% Methods
    methods
        %constructor
        function obj = Separator(Name, Materials, WeightFractions, Dimensions, Porosity)
            obj.Name = Name;
            obj.Materials = Materials;
            obj.WeightFractions = WeightFractions;
            obj.Dimensions = Dimensions;
            obj.Porosity = Porosity;
            
            obj = CalcDensity(obj);
            obj = CalcSurface(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcTortuosity(obj);
			obj = CalcThermalConductivity(obj);
			obj = CalcThermalCapacity(obj);
        end
        %get method
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Separator return 0']);
                output = 0;
            end
        end
        %set method
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Separator']);
            end
        end
        % refresh calculation if paramters changed
        function obj = RefreshCalc(obj)
            obj = CalcDensity(obj);
            obj = CalcSurface(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcTortuosity(obj);
			obj = CalcThermalConductivity(obj);
            obj = CalcThermalCapacity(obj);
        end
		% overload compare operator
		function logical = eq(A,B) 
           name_A           = GetProperty(A,'Name');
           name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
           logical          = strcmp(name_A,name_B);
        end
    end
    %% Private Methods
    methods (Access = private)
        % calculation of the density
        function obj = CalcDensity(obj)
            TempSum = 0;
            for index = 1:length(obj.Materials)
                TempSum = TempSum + obj.WeightFractions(index) / obj.Materials(index).Density;
            end
            obj.Density = 1/TempSum;
        end
        % calculation of the surface
        function obj = CalcSurface(obj)
            obj.SurfaceArea = obj.Dimensions(1) * obj.Dimensions (2) * 1e-2; % in cm²
        end
        % calculation of the volume
        function obj = CalcVolume(obj)
            obj.Volume = prod(obj.Dimensions) * 1e-3; % in cm³
            obj.ElectrolyteAvailableVolume = obj.Porosity * obj.Volume; % in cm³
        end
        % calculation of the weight
        function obj = CalcWeight(obj)
            obj.Weight = obj.Volume * (1 - obj.Porosity) * obj.Density; % in cm³ * g/cm³ = g
        end
        % calculation of the tortuosity
        function obj = CalcTortuosity(obj)
            obj.Tortuosity = 1 / power(obj.Porosity, 0.5); % Bruggemann relation
        end
		% calculation of thermal conductivity
		function obj = CalcThermalConductivity(obj)
            CoordinationNumber = 12;
            VolumeFractionTempSum = 0;
            for index = 1:numel(obj.Materials)
                VolumeFractionTempSum = VolumeFractionTempSum + obj.WeightFractions(index) / obj.Materials(index).Density;
            end
            for index = 1:numel(obj.Materials)
                obj.VolumeFractions(index) = obj.WeightFractions(index) / obj.Materials(index).Density / VolumeFractionTempSum;
                try
                    ThermalConductivities(index) = obj.Materials(index).ThermalConductivity;
                catch
                   exception        = MException('ClassSeparator:ErrorCalcThermalConductivit',join(['The substance ', GetProperty(obj.Materials(index), 'Name'), ' has no specified thermal conductivity. Please select a substance with',...
                                        'specified thermal conductivity or specify the thermal conductivity in the raw data.'])); 
                   throw(exception);
                end
            end
            obj.ThermalConductivity = FcnRecursiveEffectiveMediumTheory(ThermalConductivities, obj.VolumeFractions, CoordinationNumber);
        end
		% calculation of thermal capacity
        function obj = CalcThermalCapacity(obj)
            obj.ThermalCapacity = 0;
            for index = 1:numel(obj.Materials)
                obj.ThermalCapacity = obj.ThermalCapacity + obj.WeightFractions(index) * obj.Materials(index).ThermalCapacity;
            end
        end
    end
end