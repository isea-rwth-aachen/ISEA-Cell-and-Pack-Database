classdef Simulationsoption < matlab.mixin.Copyable
    %An object simulationoption contains all possible options for a
    %simulation of an cell or an cell component with the physico-chemical
    %model (PCM)

    properties
        Name char;
        ambienttemperature double % in °C
        celltemperature double % in °C
        StateOfCharge double % in %
        ParticleType char
        ParticleDivision double
        Division double
        BaseCell char
    end

    methods
        function obj = Simulationsoption(Name,ambienttemperature,celltemperature,StateOfCharge,...
                ParticleType,ParticleDivision,Division)
            if isempty(Name)
                Name = 'temp';
            elseif iscell(Name)
                Name = cell2mat(Name);
            end
            if isempty(ambienttemperature)
                ambienttemperature = 25;
            end
            if isempty(celltemperature)
                celltemperature = 25;
            end
            if isempty(StateOfCharge)
                StateOfCharge = 0;
            end
            if isempty(ParticleDivision)
                ParticleDivision = 1;
            end
            if isempty(Division)
                Division = 1;
            end
            obj.Name                                = Name;
            obj.ambienttemperature                  = ambienttemperature;
            obj.celltemperature                     = celltemperature;
            obj.StateOfCharge                       = StateOfCharge;
            obj.ParticleType                        = ParticleType;
            obj.ParticleDivision                    = ParticleDivision;
            obj.Division                            = Division;
        end
        %get method
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Material return 0']);
                output = 0;
            end
        end
        %set method
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Material']);
            end
        end
    end
end