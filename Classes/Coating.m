classdef Coating

    properties
        Name string
        ActiveMaterial ActiveMaterial
        WeightFractionActiveMaterial double
        ConductiveAdditive ConductiveAdditive
        WeightFractionConductiveAdditive double
        Binder Binder
        WeightFractionBinder double

        VolumeFractionActiveMaterial double
        VolumeFractionConductiveAdditive double
        VolumeFractionBinder double
        VolumeFractions double                  % array of volume fractions
        MolarMass double                        % in g/mol
        Density double                          % in g/cm³
        GravCapacity double                     % in mAh/g
        ElectricalConductivity double           % in S*m/m² = S/m

		ThermalConductivity double  			% in W/(m*K) = W*m/(m²*K)                   
        ThermalCapacity double 					% in J/(kg*K)      

        AddInfo struct                          % any additional info that has to be added to coating
        Source string                           % literature source, measurements, etc.
        Confidential string                     % 'Yes' or 'No'
		
		ArrheniusConductivity Arrhenius
    end
    %% Methods
    methods
        % constructor
        function obj = Coating(Name, ActiveMaterial, WeightFractionActiveMaterial, ConductiveAdditive, WeightFractionConductiveAdditive, Binder, WeightFractionBinder,ArrheniusConductivity)
            %MATERIAL Construct an instance of this class
            %   Detailed explanation goes here
            obj.Name                                = Name;
            obj.ActiveMaterial                      = ActiveMaterial;
            obj.WeightFractionActiveMaterial        = WeightFractionActiveMaterial;
            obj.ConductiveAdditive                  = ConductiveAdditive;
            obj.WeightFractionConductiveAdditive    = WeightFractionConductiveAdditive;
            obj.Binder                              = Binder;
            obj.WeightFractionBinder                = WeightFractionBinder;            
            
            obj = CalcMolarMass(obj);
            obj = CalcDensity(obj);
            obj = CalcCapacity(obj);
            obj = CalcElectricalConductivity(obj);
            obj = CalcThermalConductivity(obj);
            obj = CalcThermalCapacity(obj);
                        
            if exist('ArrheniusConductivity', 'var') && ~isempty(ArrheniusConductivity) && isa(ArrheniusConductivity,'Arrhenius')
                obj.ArrheniusConductivity          = ArrheniusConductivity;
            elseif exist('ArrheniusConductivity', 'var') && isnumeric(ArrheniusConductivity)
                obj.ArrheniusConductivity          = Arrhenius(['Conductivity_ ' convertCharsToStrings(obj.Name)],ArrheniusConductivity,'Scalar');
            else
                obj.ArrheniusConductivity          = Arrhenius(['Conductivity_ ' convertCharsToStrings(obj.Name)],obj.ElectricalConductivity,'Scalar');
            end
        end
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
        % refresh calculation after changing a parameter
        function obj = RefreshCalc(obj)
            obj = CalcMolarMass(obj);
            obj = CalcDensity(obj);
            obj = CalcCapacity(obj);
            obj = CalcElectricalConductivity(obj);
            obj = CalcThermalConductivity(obj);
            obj = CalcThermalCapacity(obj);
        end
    end
    %% Private Methods
    methods (Access = private)
        % calculate molar mass of the Coating
        function obj = CalcMolarMass(obj)
            obj.MolarMass = 1/(1/obj.ActiveMaterial.MolarMass * obj.WeightFractionActiveMaterial ...
                + 1/obj.ConductiveAdditive.MolarMass * obj.WeightFractionConductiveAdditive ...
                + 1/obj.Binder.MolarMass * obj.WeightFractionBinder);
        end
        % calculate density of the Coating
        function obj = CalcDensity(obj)
            if (abs(obj.WeightFractionActiveMaterial + obj.WeightFractionConductiveAdditive + obj.WeightFractionBinder)-1) > 1e-6 % pratically sum equal 1, but allowing numerical errors
                error('Sum of mass fractions is unequal 1');
            end
            obj.Density = 1 / (obj.WeightFractionActiveMaterial / obj.ActiveMaterial.Density ...
                + obj.WeightFractionConductiveAdditive / obj.ConductiveAdditive.Density ...
                + obj.WeightFractionBinder / obj.Binder.Density);
        end
        % calculate capacity of the Coating
        function obj = CalcCapacity(obj)
            obj.GravCapacity = obj.ActiveMaterial.GravCapacity * obj.WeightFractionActiveMaterial;
        end
        % calculate electrical conductivity of the Coating
        function obj = CalcElectricalConductivity(obj)
            CoordinationNumber = 12;
            % calculation via recursive function including binder conductivity
            VolumeFractionTempSum = obj.WeightFractionActiveMaterial / obj.ActiveMaterial.Density...
                + obj.WeightFractionConductiveAdditive / obj.ConductiveAdditive.Density...
                + obj.WeightFractionBinder / obj.Binder.Density;
            obj.VolumeFractionActiveMaterial = obj.WeightFractionActiveMaterial / obj.ActiveMaterial.Density / VolumeFractionTempSum;
            obj.VolumeFractionConductiveAdditive = obj.WeightFractionConductiveAdditive / obj.ConductiveAdditive.Density / VolumeFractionTempSum;
            obj.VolumeFractionBinder = obj.WeightFractionBinder / obj.Binder.Density / VolumeFractionTempSum;
            obj.VolumeFractions = [obj.VolumeFractionActiveMaterial, obj.VolumeFractionConductiveAdditive, obj.VolumeFractionBinder];
            EffectiveProperties = [obj.ActiveMaterial.ElectricalConductivity, obj.ConductiveAdditive.ElectricalConductivity, obj.Binder.ElectricalConductivity];
            obj.ElectricalConductivity = FcnRecursiveEffectiveMediumTheory(EffectiveProperties, obj.VolumeFractions, CoordinationNumber);
        end
		% calculate thermal conductivity of the Coating
		function obj = CalcThermalConductivity(obj)
            CoordinationNumber = 12;
            % calculation via recursive function including binder conductivity
            EffectiveProperties = [obj.ActiveMaterial.ThermalConductivity, obj.ConductiveAdditive.ThermalConductivity, obj.Binder.ThermalConductivity];
            obj.ThermalConductivity = FcnRecursiveEffectiveMediumTheory(EffectiveProperties, obj.VolumeFractions, CoordinationNumber);
        end
		% calculate thermal capacity of the Coating
		function obj = CalcThermalCapacity(obj)
            obj.ThermalCapacity = obj.ActiveMaterial.ThermalCapacity * obj.WeightFractionActiveMaterial ...
                                    + obj.ConductiveAdditive.ThermalCapacity * obj.WeightFractionConductiveAdditive ...
                                    + obj.Binder.ThermalCapacity * obj.WeightFractionBinder;
        end
    end

    %% Public Methods
    methods (Access = public)
        % plot conductivity of the Coating
        function obj = PlotConductivity(obj)
            lw=1.8;
            fs=18;
            CoordinationNumber = 12;
            VolumeFractions_Vector = 0:0.01:1;
            VolumeFractions_Vector = VolumeFractions_Vector';
            VolumeFractions_Vector = [VolumeFractions_Vector, 1-VolumeFractions_Vector];
            Properties_AM_vs_CA = [obj.ActiveMaterial.ElectricalConductivity, obj.ConductiveAdditive.ElectricalConductivity];
            Properties_AM_vs_Binder = [obj.ActiveMaterial.ElectricalConductivity, obj.Binder.ElectricalConductivity];
            Properties_all = [obj.ActiveMaterial.ElectricalConductivity, obj.ConductiveAdditive.ElectricalConductivity, obj.Binder.ElectricalConductivity];
            EffectiveProperties_AM_vs_CA = FcnEffectiveMediumTheory(Properties_AM_vs_CA, VolumeFractions_Vector, CoordinationNumber);
            EffectiveProperties_AM_vs_Binder = FcnEffectiveMediumTheory(Properties_AM_vs_Binder, VolumeFractions_Vector, CoordinationNumber);
            % plot first figure
            figure; hold on; grid on;
            plot(VolumeFractions_Vector(:,1), EffectiveProperties_AM_vs_CA, 'LineWidth', lw)
            plot(VolumeFractions_Vector(:,1), EffectiveProperties_AM_vs_Binder, 'LineWidth', lw)
            MinMaxProperties = [min(Properties_all), max(Properties_all)];
            plot([obj.VolumeFractionActiveMaterial, obj.VolumeFractionActiveMaterial], MinMaxProperties, 'LineWidth', lw)
            plot(obj.VolumeFractionActiveMaterial, obj.ElectricalConductivity, 'kx', 'MarkerSize', 18, 'LineWidth', lw)
            set(gca, 'YScale', 'log', 'FontSize', fs, 'LineWidth', lw);
            xlabel('volume fraction AM')
            ylabel('conductivity in S/m')
            legend('AM vs CA', 'AM vs Binder', 'VolumeFractionAM')
            % end first figure
            CoordinationNumber = 12;
            VolumeFractionsListAM = 0:0.01:1;
            VolumeFractionsListCA = 0:0.01:1;
            VolumeFractionsListBin = 0:0.01:1;
            Properties_all = [obj.ActiveMaterial.ElectricalConductivity, obj.ConductiveAdditive.ElectricalConductivity, obj.Binder.ElectricalConductivity];
            EffectiveProperty = NaN([length(VolumeFractionsListAM), length(VolumeFractionsListCA)]);
            for indexAM=1:length(VolumeFractionsListAM)
                for indexCA=1:length(VolumeFractionsListCA)
                    for indexBin=1:length(VolumeFractionsListBin)
                        VolumeFractionAM = VolumeFractionsListAM(indexAM);
                        VolumeFractionCA = VolumeFractionsListCA(indexCA);
                        VolumeFractionBin = VolumeFractionsListBin(indexBin);
                        if (VolumeFractionAM+VolumeFractionCA+VolumeFractionBin)==1
                            EffectiveProperty(indexAM, indexCA) = FcnRecursiveEffectiveMediumTheory(Properties_all, [VolumeFractionAM, VolumeFractionCA, VolumeFractionBin], CoordinationNumber);
                            % debug artifact??
                            if isnan(EffectiveProperty(indexAM, indexCA))
                                a=1;
                            end
                            %
                        end
                    end
                end
            end
            EffectiveProperty=EffectiveProperty';
            % plot second figure
            figure; hold on; grid on;
            surf(VolumeFractionsListAM, VolumeFractionsListCA, EffectiveProperty, 'LineWidth', lw)
            MinMaxProperties = [min(Properties_all), max(Properties_all)];
            plot3([obj.VolumeFractionActiveMaterial, obj.VolumeFractionActiveMaterial], [obj.VolumeFractionConductiveAdditive, obj.VolumeFractionConductiveAdditive], MinMaxProperties, 'LineWidth', lw)
            plot3(obj.VolumeFractionActiveMaterial, obj.VolumeFractionConductiveAdditive, obj.ElectricalConductivity, 'kx', 'MarkerSize', 18, 'LineWidth', lw)
            set(gca, 'ZScale', 'log', 'FontSize', fs, 'LineWidth', lw);
            xlabel('volume fraction AM')
            ylabel('volume fraction CA')
            zlabel('conductivity in S/m')
            legend('AM vs CA', 'AM vs Binder', 'VolumeFractionAM')
            % end second figure
        end
		% overload compare operator
		function logical = eq(A,B) 
           name_A           = GetProperty(A,'Name');
           name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
           logical          = strcmp(name_A,name_B);
        end
    end
end