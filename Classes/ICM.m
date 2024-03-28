classdef ICM
    properties
        Name string
        TemperatureVector double            % lookup table for Ionic conductivity in °C
        ConductiveSaltMolarityVector double % lookup table for Ionic conductivity in mol/L
        IonicConductivityMatrix double      % lookup table for Ionic conductivity in S/m
        Confidential string                 % 'Yes' or 'No'
        MinIonicConductivity double         % in S/m
        MaxIonicConductivity double         % in S/m
        Source string                       % literature source, measurements, etc.
    end
    methods
        %constructor
        function obj = ICM(Name, TemperatureVector, ConductiveSaltMolarityVector, IonicConductivityMatrix)
            if nargin==0
                return
            end
            obj.Name = Name;
            obj.TemperatureVector=TemperatureVector;
            obj.ConductiveSaltMolarityVector=ConductiveSaltMolarityVector;
            obj.IonicConductivityMatrix=IonicConductivityMatrix;
            obj.MinIonicConductivity=min(min(IonicConductivityMatrix));
            obj.MaxIonicConductivity=max(max(IonicConductivityMatrix));
        end
    end
    methods (Access = public)
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Material return 0']);
                output = 0;
            end
        end
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Material']);
            end
        end
    end
end