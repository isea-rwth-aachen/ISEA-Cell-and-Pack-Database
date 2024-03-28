classdef CurrentCollector
    %     dimensions in mm [length,width,height]
    %     for active_material [length,width,height,length,width,height]
    %     due to two sides if only one side is coated [length,width,height,0,0,0]
    properties
        Name string
        Material Material
        Dimensions double       % width, height, thickness in mm
        TabDimensions double    % width, height, thickness in mm
        TabNumber double        % number of tabs
        Volume double           % in cm³
        Weight double           % in g
        SurfaceArea double      % in cm²

        AddInfo struct          % any additional info that has to be added to coating
        Source string           % literature source, measurements, etc.
        Confidential string     % 'Yes' or 'No'
    end
    %% Methods
    methods
        % constructor
        function obj = CurrentCollector(Name, Material, Dimensions, TabDimensions)
            obj.Name = Name;
            obj.Material = Material;
            obj.Dimensions = Dimensions;
            obj.TabDimensions = TabDimensions;
            obj.TabNumber = 1;
            obj = CalcSurfaceArea(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
        end
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Electrode return 0']);
                output = 0;
            end
        end
        %set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Electrode']);
            end
        end
        % refresh calculation after changing a paramter
        function obj = RefreshCalc(obj)
            obj = CalcSurfaceArea(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
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
        % calculation of the surface area of the CurrentCollector
        function obj = CalcSurfaceArea(obj)
            obj.SurfaceArea = (obj.Dimensions(1) * obj.Dimensions(2) + obj.TabNumber * obj.TabDimensions(1) * obj.TabDimensions(2)) * 1e-2; % in cm²
        end
        % calculation of the volume of the CurrentCollector
        function obj = CalcVolume(obj)
            if isempty(obj.TabNumber)
                obj.TabNumber = 1;
                warning(['Tab number of the current collector ' convertStringsToChars(obj.Name) ' was not defined and therefore set to 1.']);
            end
            obj.Volume = (prod(obj.Dimensions) + obj.TabNumber * prod(obj.TabDimensions)) * 1e-3; % in cm³
        end
        % calculation of the weight of the CurrentCollector
        function obj = CalcWeight(obj)
            obj.Weight = obj.Volume * obj.Material.Density; % in cm³ * g/cm³ = g
        end
    end
end
