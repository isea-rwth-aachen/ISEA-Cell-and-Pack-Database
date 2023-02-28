classdef ActiveMaterial < Material

    properties
        TransferMaterial Material                       % Material (doing the ion transport)
        Elements Element                                % list of Elements (referring to MolarFractions)
        MolarFractions double                           % array of molar fractions (referring to Elements)
        OpenCircuitPotential double                     % lookup table for OCP (referring to OccupancyRate)
        OpenCircuitPotentialLith double                 % lookup table for OCP for lithiation (referring to OccupancyRate)
        OccupancyRate double                            % lookup table for OccupancyRate (referring to OpenCircuitPotential)
        OcpReferenceMaterial Material                   % reference material for OCP curve (Li/Li+ for Li-Ion Batteries)
        CommonOccupancyRange double                     % occupancy range which has been used commonly [min, max]

        MinOpenCircuitPotential double                  % in V
        MaxOpenCircuitPotential double                  % in V
        NominalOpenCircuitPotential double              % in V
        MinOpenCircuitPotentialLith double              % in V
        MaxOpenCircuitPotentialLith double              % in V
        NominalOpenCircuitPotentialLith double          % in V

        OccupancyRateCommonOR double                    % occupancy rate as known

        OpenCircuitPotentialCommonOR double             % lookup table for OCP (referring to OccupancyRate, delithiation) in V
        MinOpenCircuitPotentialCommonOR double          % min OCP (referring to OccupancyRate, delithiation) in V
        MaxOpenCircuitPotentialCommonOR double          % max OCP (referring to OccupancyRate, delithiation) in V
        NominalOpenCircuitPotentialCommonOR double      % nominal OCP (referring to OccupancyRate, delithiation) in V
        OpenCircuitPotentialCommonORLith double         % lookup table for OCP for lithiation (referring to OccupancyRate) in V
        MinOpenCircuitPotentialCommonORLith double      % min OCP (referring to OccupancyRate, lithiation) in V
        MaxOpenCircuitPotentialCommonORLith double      % max OCP (referring to OccupancyRate, lithiation) in V
        NominalOpenCircuitPotentialCommonORLith double  % nominal OCP (referring to OccupancyRate, lithiation) in V

        WeightFractions double                          % array of weight fractions (referring to Elements)
        GravCapacity double                             % gravimetric capacity excluding transfer material in mAh/g
        GravCapacityMaxOR double                        % gravimetric capacity for the range of the given OR/OCP curve (utilized from first till last value rather than common OR) excluding transfer material in mAh/g
        TheoGravCapacity double                         % theoretical gravimetric capacity excluding transfer material in mAh/g
        MaxConcentration double                         % maximum concentration of transfer material in mol/m³
        MinMaxOccupancyRange double                     % maximum occupancy range which can be used [min, max]
        ExchangeCurrentDensity double                   % i0 from Butler Volmer equation in mA/cm²
        ChargeTransferKineticCoefficient double         % alpha from Butler Volmer equation
        RelVolumeIncreaseOnLith double                  % relative increase of volume per x Li
    end

    %% Methods
    methods
        %Constructor
        function obj = ActiveMaterial(Name, TransferMaterial, Elements, MolarFractions, OpenCircuitPotential, OccupancyRate, OcpReferenceMaterial, CommonOccupancyRange, Density)
            if nargin==0
                return
            end
            obj.Name = Name;
            obj.TransferMaterial = TransferMaterial;
            obj.Elements = Elements;
            obj.MolarFractions = MolarFractions;
            if isa(OpenCircuitPotential, 'OCV') %OCV Object as input
                obj.OpenCircuitPotential = OpenCircuitPotential.OpenCircuitPotential;
                obj.OpenCircuitPotentialLith = OpenCircuitPotential.OpenCircuitPotentialLith;
                obj.OccupancyRate = OpenCircuitPotential.OccupancyRate;
            else %Array as input
                SizeOCP = size(OpenCircuitPotential);
                if SizeOCP(1) > SizeOCP(2)
                    obj.OpenCircuitPotential = OpenCircuitPotential;
                else
                    obj.OpenCircuitPotential = OpenCircuitPotential';
                end
                obj.OpenCircuitPotentialLith = obj.OpenCircuitPotential;
                SizeOR = size(OccupancyRate);
                if SizeOR(1) > SizeOR(2)
                    obj.OccupancyRate = OccupancyRate;
                else
                    obj.OccupancyRate = OccupancyRate';
                end
            end
            obj.OcpReferenceMaterial = OcpReferenceMaterial;
            obj.CommonOccupancyRange = CommonOccupancyRange;
            obj.Density = Density;
            obj.RelVolumeIncreaseOnLith = 0; %no volume change by default
            obj.MinMaxOccupancyRange(1)=min(obj.OccupancyRate);
            obj.MinMaxOccupancyRange(2)=max(obj.OccupancyRate);
            obj.ChemFormula = DetermineChemFormula([TransferMaterial, Elements], [NaN, MolarFractions]);
            obj.MolarMass = CalcMolarMass(Elements, MolarFractions); % excluding TransferMaterial
            obj = CalcGravCapacity(obj);
            obj = CalcVoltages(obj);
        end
    end
    %% public methods
    methods (Access = public)
        % refreshes alll calculations on the active material level (use if
        % paramters are changed)
        function obj = RefreshCalc(obj)
            obj = CalcGravCapacity(obj);
            obj = CalcVoltages(obj);
        end
        % calculation of gravimetric capacity
        function obj = CalcGravCapacity(obj)
            F = 96485; % Faraday constant in As/mol
            z = min(abs(obj.TransferMaterial.OxidationStates));
            obj.TheoGravCapacity = z * F / obj.MolarMass * 1000 / 3600; % in mAh/g
            obj.GravCapacityMaxOR = obj.TheoGravCapacity * (obj.MinMaxOccupancyRange(2) - obj.MinMaxOccupancyRange(1)); % in mAh/g
            obj.GravCapacity = obj.TheoGravCapacity * (obj.CommonOccupancyRange(2) - obj.CommonOccupancyRange(1)); % in mAh/g
            obj.MaxConcentration = z * obj.Density / obj.MolarMass * 1e6; % in (g/cm³)/(g/mol)*1e6 cm³/m³ = mol/m³
        end
        % in case limitation of the voltage to any requirements from
        % certain applications is necessary
        function obj = SetVoltageLimits(obj, VoltageLimits)
            minV = VoltageLimits(1);
            maxV = VoltageLimits(2);
            if obj.MaxOpenCircuitPotential > maxV
                obj.CommonOccupancyRange(1)=interp1(obj.OpenCircuitPotential, obj.OccupancyRate, maxV);
            end
            if obj.MinOpenCircuitPotentialLith < minV
                obj.CommonOccupancyRange(2)=interp1(obj.OpenCircuitPotentialLith, obj.OccupancyRate, minV);
            end
            obj = RefreshCalc(obj);
        end
        % set use range limits for example for certain safety margins
        function obj = SetUseRange(obj, Range)
            % sets the occupancy range based on the maximum occupancy range
            maxOR = max(obj.OccupancyRate);
            minOR = min(obj.OccupancyRate);
            if (Range(2)>1) || (Range(1)<0)
                error('Limits for relative range of use have to be placed between 0 and 1')
            end
            obj.CommonOccupancyRange(1) = minOR + Range(1)*(maxOR - minOR);
            obj.CommonOccupancyRange(2) = minOR + Range(2)*(maxOR - minOR);
            obj = obj.RefreshCalc();
        end
    end
    %% private methods
    methods (Access = private)
        function obj = CalcVoltages(obj)
            obj.MinOpenCircuitPotential = min(obj.OpenCircuitPotential);
            obj.MaxOpenCircuitPotential = max(obj.OpenCircuitPotential);
            obj.NominalOpenCircuitPotential = trapz(obj.OccupancyRate, obj.OpenCircuitPotential)/(obj.MinMaxOccupancyRange(2)-obj.MinMaxOccupancyRange(1));
            obj.MinOpenCircuitPotentialLith = min(obj.OpenCircuitPotentialLith);
            obj.MaxOpenCircuitPotentialLith = max(obj.OpenCircuitPotentialLith);
            obj.NominalOpenCircuitPotentialLith = trapz(obj.OccupancyRate, obj.OpenCircuitPotentialLith)/(obj.MinMaxOccupancyRange(2)-obj.MinMaxOccupancyRange(1));
            obj.OccupancyRateCommonOR = linspace(obj.CommonOccupancyRange(1), obj.CommonOccupancyRange(2), 1000);
            obj.OpenCircuitPotentialCommonOR = interp1(obj.OccupancyRate, obj.OpenCircuitPotential, obj.OccupancyRateCommonOR, 'linear');
            obj.MinOpenCircuitPotentialCommonOR = min(obj.OpenCircuitPotentialCommonOR);
            obj.MaxOpenCircuitPotentialCommonOR = max(obj.OpenCircuitPotentialCommonOR);
            obj.NominalOpenCircuitPotentialCommonOR = trapz(obj.OccupancyRateCommonOR, obj.OpenCircuitPotentialCommonOR)/(max(obj.OccupancyRateCommonOR)-min(obj.OccupancyRateCommonOR));
            obj.OpenCircuitPotentialCommonORLith = interp1(obj.OccupancyRate, obj.OpenCircuitPotentialLith, obj.OccupancyRateCommonOR, 'linear');
            obj.MinOpenCircuitPotentialCommonORLith = min(obj.OpenCircuitPotentialCommonORLith);
            obj.MaxOpenCircuitPotentialCommonORLith = max(obj.OpenCircuitPotentialCommonORLith);
            obj.NominalOpenCircuitPotentialCommonORLith = trapz(obj.OccupancyRateCommonOR, obj.OpenCircuitPotentialCommonORLith)/(max(obj.OccupancyRateCommonOR)-min(obj.OccupancyRateCommonOR));
        end
    end
end