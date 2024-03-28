classdef OCV

    properties
        Name string
        OpenCircuitPotential double             % lookup table for OCP (referring to OccupancyRate)
        OccupancyRate double                    % lookup table for OccupancyRate (referring to OpenCircuitPotential)

        OpenCircuitPotentialLith double         % lookup table for OCP for Lithiation (referring to OccupancyRate)

        MinOccupancyRate double                 % no unit
        MaxOccupancyRate double                 % no unit

        MinOpenCircuitPotential double          % in V during delithiation
        MaxOpenCircuitPotential double          % in V during delithiation
        NominalOpenCircuitPotential double      % in V during delithiation

        MinOpenCircuitPotentialLith double      % in V during lithiation
        MaxOpenCircuitPotentialLith double      % in V during lithiation
        NominalOpenCircuitPotentialLith double  % in V during lithiation

        Confidential string
    end
    %% Methods
    methods
        %constructor
        function obj = OCV(Name, OpenCircuitPotential, OccupancyRate, OpenCircuitPotentialLith, OccupancyRateLith)
            if nargin==0
                return
            end
            if nargin==3
                OpenCircuitPotentialLith = OpenCircuitPotential;
                OccupancyRateLith = OccupancyRate;
            end
			
			if size(OpenCircuitPotential,1) > size(OpenCircuitPotential,2)
                OpenCircuitPotential    = OpenCircuitPotential';
            end
            if size(OccupancyRate,1) > size(OccupancyRate,2)
                OccupancyRate           = OccupancyRate';
            end
            if size(OpenCircuitPotentialLith,1) > size(OpenCircuitPotentialLith,2)
                OpenCircuitPotentialLith= OpenCircuitPotentialLith';
            end
            if size(OccupancyRateLith,1) > size(OccupancyRateLith,2)
                OccupancyRateLith       = OccupancyRateLith';
            end

            [OccupancyRate, ind] = unique(OccupancyRate);
            OpenCircuitPotential = OpenCircuitPotential(ind);
            [OccupancyRateLith, ind] = unique(OccupancyRateLith);
            OpenCircuitPotentialLith = OpenCircuitPotentialLith(ind);

            diffs = [0, (diff (OpenCircuitPotential))>=0];
            while nnz(diffs)
                DelElements = find (diffs);
                OccupancyRate(DelElements) = [];
                OpenCircuitPotential(DelElements) = [];
                diffs = (diff (OpenCircuitPotential))>=0;
            end

            diffs = [0, (diff (OpenCircuitPotentialLith))>=0];
            while nnz(diffs)
                DelElements = find (diffs);
                OccupancyRateLith(DelElements) = [];
                OpenCircuitPotentialLith(DelElements) = [];
                diffs = (diff (OpenCircuitPotentialLith))>=0;
            end

            obj.Name = Name;

            minORdeLith = min(OccupancyRate);
            minORLith = min(OccupancyRateLith);
            obj.MinOccupancyRate=max([minORdeLith, minORLith]);

            maxORdeLith = max(OccupancyRate);
            maxORLith = max(OccupancyRateLith);
            obj.MaxOccupancyRate=min([maxORdeLith, maxORLith]);

            %normalization to uniform OR
            OccupancyRate = obj.MinOccupancyRate + (OccupancyRate - min(OccupancyRate))/...
                (max(OccupancyRate)-min(OccupancyRate))*(obj.MaxOccupancyRate-obj.MinOccupancyRate);
            OccupancyRateLith = obj.MinOccupancyRate + (OccupancyRateLith - min(OccupancyRateLith))/...
                (max(OccupancyRateLith)-min(OccupancyRateLith))*(obj.MaxOccupancyRate-obj.MinOccupancyRate);

            obj.MinOpenCircuitPotential=interp1(OccupancyRate, OpenCircuitPotential, obj.MinOccupancyRate);
            obj.MaxOpenCircuitPotential=interp1(OccupancyRate, OpenCircuitPotential, obj.MaxOccupancyRate);

            obj.MinOpenCircuitPotentialLith=interp1(OccupancyRateLith, OpenCircuitPotentialLith, obj.MinOccupancyRate);
            obj.MaxOpenCircuitPotentialLith=interp1(OccupancyRateLith, OpenCircuitPotentialLith, obj.MaxOccupancyRate);

            obj.OccupancyRate = linspace( obj.MinOccupancyRate, obj.MaxOccupancyRate, 1001)';

            obj.OpenCircuitPotential = interp1(OccupancyRate, OpenCircuitPotential, obj.OccupancyRate);
            obj.OpenCircuitPotentialLith = interp1(OccupancyRateLith, OpenCircuitPotentialLith, obj.OccupancyRate);

            obj.NominalOpenCircuitPotential=trapz(obj.OccupancyRate, obj.OpenCircuitPotential)/(obj.MaxOccupancyRate-obj.MinOccupancyRate);
            obj.NominalOpenCircuitPotentialLith=trapz(obj.OccupancyRate, obj.OpenCircuitPotentialLith)/(obj.MaxOccupancyRate-obj.MinOccupancyRate);
        end
		% overload compare operator
		function logical = eq(A,B) 
           name_A           = GetProperty(A,'Name');
           name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
           logical          = strcmp(name_A,name_B);
        end
    end
    %% Public Methods
    methods (Access = public)
        %method to plot the ocv
        function ReturnVal = PlotOCV(obj)
            plot (obj.OccupancyRate, obj.OpenCircuitPotential);
            hold on
            plot ([obj.MinOccupancyRate obj.MaxOccupancyRate], [obj.NominalOpenCircuitPotential, obj.NominalOpenCircuitPotential])
            ReturnVal=1;
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