classdef Blend < ActiveMaterial

    properties
        ActiveMaterials ActiveMaterial                  % list of Active Materials
        AMsWeightFractions double                       % array of Active Materials' weight fractions

        AMsMolarFractions double                        % array of Active Materials' molar fractions
        AMsVolumeFractions double                       % array of Active Materials' volume fractions
        AMsOccupancyRateAtMinOCP double                 % array of Active Materials' occupancy rates at min OCP
        AMsOccupancyRateAtMaxOCP double                 % array of Active Materials' occupancy rates at max OCP
        AMsGravCapacityRescale double                   % mAh/g relative to weight of Blend; scaled on equidistand voltage steps
        OCPScale double                                 % ?
        GravCapacityScale double                        % ?
        AMsUtilizationOverOR double                     % no unit

        AMsGravCapacity double                          % array of Active Materials' gravimetric capacity
        AMsGravCapacityInclWeightFraction double        % array of Active Materials' grav. capacity incl. their weight fraction
        AMsOccupancyRate double                         % array of Active Materials' occupancy rates
        AMsOCP double                                   % array of Active Materials' OCPs
        AMsGravCapacityScale double                     % mAh/g relative to weight of AM itself
        AMsGravCapacityInclWeightFractionScale double   % mAh/g relative to weight of Blend
    end
    %% public methods
    methods
        % constructor
        function obj = Blend(Name, ActiveMaterials, AMsWeightFractions)
            obj.Name = Name;
            obj.ActiveMaterials = ActiveMaterials;
            obj.AMsWeightFractions = AMsWeightFractions;
            obj = CalcBasicBlendData(obj);
            obj = OpenCircuitPotential(obj);
            obj = CalcGravCapacity(obj);
            obj = CalcConductivity(obj);
        end
    end
    %% private methods
    methods (Access = private)
        % Calculation of basic Blend Properties
        function obj = CalcBasicBlendData(obj)
            obj.TransferMaterial = obj.ActiveMaterials(1).TransferMaterial;
            obj.OcpReferenceMaterial = obj.ActiveMaterials(1).OcpReferenceMaterial;
            % calculate molar mass
            TempSum = 0;
            for index = 1:length(obj.ActiveMaterials)
                TempSum = TempSum + obj.AMsWeightFractions(index) / obj.ActiveMaterials(index).MolarMass;
            end
            obj.MolarMass = 1/TempSum;
            % calculate molar fractions
            for index = 1:length(obj.ActiveMaterials)
                obj.AMsMolarFractions(index) = obj.AMsWeightFractions(index) / obj.ActiveMaterials(index).MolarMass * obj.MolarMass;
            end
            % summarize Elements and calculate molar fractions
            obj.Elements = obj.ActiveMaterials(1).Elements;
            obj.MolarFractions = obj.AMsMolarFractions(1) * obj.ActiveMaterials(1).MolarFractions;
            for index = 2:length(obj.ActiveMaterials)
                obj.Elements = [obj.Elements, obj.ActiveMaterials(index).Elements];
                obj.MolarFractions = [obj.MolarFractions, obj.AMsMolarFractions(index) * obj.ActiveMaterials(index).MolarFractions];
            end
            % merge chemical formula
            obj.ChemFormula = '';
            for index = 1:length(obj.ActiveMaterials)
                obj.ChemFormula = strcat(obj.ChemFormula, num2str(obj.AMsMolarFractions(index)), ' ', obj.ActiveMaterials(index).ChemFormula, ' ');
            end
            % calculate density
            TempSum = 0;
            for index = 1:length(obj.ActiveMaterials)
                TempSum = TempSum + obj.AMsWeightFractions(index) / obj.ActiveMaterials(index).Density;
            end
            obj.Density = 1/TempSum;
        end
        % calculate blend OCV
        function obj = OpenCircuitPotential(obj, setCommonOR)
            % find minimum and maximum voltage values
            minOCP = min(obj.ActiveMaterials(1).OpenCircuitPotential);
            maxOCP = max(obj.ActiveMaterials(1).OpenCircuitPotential);
            minOCPLith = min(obj.ActiveMaterials(1).OpenCircuitPotentialLith);
            maxOCPLith = max(obj.ActiveMaterials(1).OpenCircuitPotentialLith);
            for index = 2:length(obj.ActiveMaterials)
                minOCP = max(minOCP, min(obj.ActiveMaterials(index).OpenCircuitPotential));
                maxOCP = min(maxOCP, max(obj.ActiveMaterials(index).OpenCircuitPotential));
                minOCPLith = max(minOCPLith, min(obj.ActiveMaterials(index).OpenCircuitPotentialLith));
                maxOCPLith = min(maxOCPLith, max(obj.ActiveMaterials(index).OpenCircuitPotentialLith));
            end
            % calculate weighted OR
            for index = 1:length(obj.ActiveMaterials)
                AMsOccupancyRateWeighted(:,index) = obj.AMsMolarFractions(index) * obj.ActiveMaterials(index).OccupancyRate;
            end
            % rescale OCP axis
            OCP_eval_Points=linspace(minOCP, maxOCP, 1000)';
            OCP_eval_Points_Lith=linspace(minOCPLith, maxOCPLith, 1000)';
            % adjust weighted OR axis to rescaled OCP axis
            for index = 1:length(obj.ActiveMaterials)
                AMsOccupancyRateRescale(:,index) = interp1(obj.ActiveMaterials(index).OpenCircuitPotential, AMsOccupancyRateWeighted(:,index), OCP_eval_Points, 'linear', 'extrap');
                AMsOccupancyRateRescaleLith(:,index) = interp1(obj.ActiveMaterials(index).OpenCircuitPotentialLith, AMsOccupancyRateWeighted(:,index), OCP_eval_Points_Lith, 'linear', 'extrap');
            end
            % calculate cummulated OR
            OR_cum = sum(AMsOccupancyRateRescale, 2);
            OR_cum_Lith = sum(AMsOccupancyRateRescaleLith, 2);
            % calculate total OR for DeLith and Lith
            obj.MinMaxOccupancyRange(1) = max(min(OR_cum), min(OR_cum_Lith));
            obj.MinMaxOccupancyRange(2) = min(max(OR_cum), max(OR_cum_Lith));
            obj.OccupancyRate = linspace(obj.MinMaxOccupancyRange(1), obj.MinMaxOccupancyRange(2), 1000)';
            % calculate OCP for Delith and Lith
            obj.OpenCircuitPotential= interp1(OR_cum, OCP_eval_Points, obj.OccupancyRate);
            obj.OpenCircuitPotentialLith= interp1(OR_cum_Lith, OCP_eval_Points_Lith, obj.OccupancyRate);
            obj.MinOpenCircuitPotential=min(obj.OpenCircuitPotential);
            obj.MaxOpenCircuitPotential=max(obj.OpenCircuitPotential);
            obj.MinOpenCircuitPotentialLith=min(obj.OpenCircuitPotentialLith);
            obj.MaxOpenCircuitPotentialLith=max(obj.OpenCircuitPotentialLith);
            % calculate common occupancy rate
            if ~exist( 'setCommonOR', 'var' )
                MinOCPAtCommonOR = obj.MinOpenCircuitPotentialLith; % min OR is defined by lithiation OCP
                MaxOCPAtCommonOR = obj.MaxOpenCircuitPotential; % max OR is defined by delithiation OCP
                for index=1:length(obj.ActiveMaterials)
                    MinOCPAtCommonOR = max(MinOCPAtCommonOR, obj.ActiveMaterials(index).MinOpenCircuitPotentialCommonORLith);
                    MaxOCPAtCommonOR = min(MaxOCPAtCommonOR, obj.ActiveMaterials(index).MaxOpenCircuitPotentialCommonOR);
                end
                TempOR(1) = interp1(obj.OpenCircuitPotentialLith, obj.OccupancyRate, MinOCPAtCommonOR);
                TempOR(2) = interp1(obj.OpenCircuitPotential, obj.OccupancyRate, MaxOCPAtCommonOR);
                obj.CommonOccupancyRange = [min(TempOR), max(TempOR)];
            else
                obj.CommonOccupancyRange = [setCommonOR(1), setCommonOR(2)];
            end
            obj.OccupancyRateCommonOR = linspace(obj.CommonOccupancyRange(1), obj.CommonOccupancyRange(2), 1000);
            obj.OpenCircuitPotentialCommonOR = interp1(obj.OccupancyRate, obj.OpenCircuitPotential, obj.OccupancyRateCommonOR, 'linear', 'extrap');
            obj.MinOpenCircuitPotentialCommonOR = min(obj.OpenCircuitPotentialCommonOR);
            obj.MaxOpenCircuitPotentialCommonOR = max(obj.OpenCircuitPotentialCommonOR);
            obj.NominalOpenCircuitPotentialCommonOR = trapz(obj.OccupancyRateCommonOR, obj.OpenCircuitPotentialCommonOR)/(max(obj.OccupancyRateCommonOR)-min(obj.OccupancyRateCommonOR));
            obj.OpenCircuitPotentialCommonORLith = interp1(obj.OccupancyRate, obj.OpenCircuitPotentialLith, obj.OccupancyRateCommonOR, 'linear', 'extrap');
            obj.MinOpenCircuitPotentialCommonORLith = min(obj.OpenCircuitPotentialCommonORLith);
            obj.MaxOpenCircuitPotentialCommonORLith = max(obj.OpenCircuitPotentialCommonORLith);
            obj.NominalOpenCircuitPotentialCommonORLith = trapz(obj.OccupancyRateCommonOR, obj.OpenCircuitPotentialCommonORLith)/(max(obj.OccupancyRateCommonOR)-min(obj.OccupancyRateCommonOR));
            % calculate active material utilization over occupancy rate
            for index = 1:length(obj.ActiveMaterials)
                AMsUtilOverOR(:,index) = interp1(obj.ActiveMaterials(index).OpenCircuitPotential, obj.ActiveMaterials(index).OccupancyRate, obj.OpenCircuitPotential);
                AMsUtilOverOR(:,index) = AMsUtilOverOR(:,index) - min(AMsUtilOverOR(:,index)) + max(AMsUtilOverOR(:,index));
                obj.AMsUtilizationOverOR(:,index) = AMsUtilOverOR(:,index) / max(AMsUtilOverOR(:,index));
            end
            %% old stuff, might fall out
            % determine Occupancy Rate at the new min and max voltagelimits
            for index = 1:length(obj.ActiveMaterials)
                obj.AMsOccupancyRateAtMinOCP(index) = interp1(obj.ActiveMaterials(index).OpenCircuitPotential, obj.ActiveMaterials(index).OccupancyRate, obj.MinOpenCircuitPotential);
                obj.AMsOccupancyRateAtMaxOCP(index) = interp1(obj.ActiveMaterials(index).OpenCircuitPotential, obj.ActiveMaterials(index).OccupancyRate, obj.MaxOpenCircuitPotential);
            end
            % rescale OCP axis
            obj.OCPScale = linspace(obj.MinOpenCircuitPotential, obj.MaxOpenCircuitPotential, 1000);
            % calculate grav capacity axis
            for index = 1:length(obj.ActiveMaterials)
                obj.AMsGravCapacity(index) = obj.ActiveMaterials(index).TheoGravCapacity * abs(obj.AMsOccupancyRateAtMaxOCP(index) - obj.AMsOccupancyRateAtMinOCP(index));
                obj.AMsGravCapacityInclWeightFraction(index) =  obj.AMsGravCapacity(index) * obj.AMsWeightFractions(index);
                obj.AMsOccupancyRate(:,index) = linspace(obj.AMsOccupancyRateAtMinOCP(index), obj.AMsOccupancyRateAtMaxOCP(index), 1000);
                obj.AMsOCP(:,index) = flipud(interp1(obj.ActiveMaterials(index).OccupancyRate, obj.ActiveMaterials(index).OpenCircuitPotential, obj.AMsOccupancyRate(:,index)));
                obj.AMsGravCapacityScale(:,index) = linspace(0, obj.AMsGravCapacity(index), 1000);
                obj.AMsGravCapacityInclWeightFractionScale(:,index) = obj.AMsGravCapacityScale(:,index) * obj.AMsWeightFractions(index);
            end
            % rescale OCP axis
            obj.OCPScale = linspace(obj.MinOpenCircuitPotential, obj.MaxOpenCircuitPotential, 1000);
            % adjust grav capacity axis to rescaled OCP axis
            for index = 1:length(obj.ActiveMaterials)
                obj.AMsGravCapacityRescale(:,index) = interp1(obj.AMsOCP(:,index), obj.AMsGravCapacityInclWeightFractionScale(:,index), obj.OCPScale, 'linear', 'extrap');
            end
            % merge active material ocp over grav capacity characteristics
            obj.GravCapacityScale = 0;
            for index_OCP = 2:length(obj.OCPScale)
                DeltaGravCapacity = 0;
                for index_AMs = 1:length(obj.ActiveMaterials)
                    DeltaGravCapacity = DeltaGravCapacity + (obj.AMsGravCapacityRescale(index_OCP, index_AMs) - obj.AMsGravCapacityRescale(index_OCP-1, index_AMs));
                end
                obj.GravCapacityScale(index_OCP) = obj.GravCapacityScale(index_OCP-1) + DeltaGravCapacity;
            end
            TempScale = linspace(min(obj.GravCapacityScale), max(obj.GravCapacityScale), 1000);
            obj.OpenCircuitPotential = interp1(obj.GravCapacityScale, obj.OCPScale, TempScale)';
        end
        % calculate electrical conductivity
        function obj = CalcConductivity(obj)
            CoordinationNumber = 12;
            %% calculation via recursive function including binder conductivity
            VolumeFractionTempSum = 0;
            for index=1:length(obj.ActiveMaterials)
                VolumeFractionTempSum = VolumeFractionTempSum + obj.AMsWeightFractions(index) / obj.ActiveMaterials(index).Density;
            end
            for index=1:length(obj.ActiveMaterials)
                obj.AMsVolumeFractions(index) = obj.AMsWeightFractions(index) / obj.ActiveMaterials(index).Density / VolumeFractionTempSum;
            end
            % calculate expansion
            TempSum = 0;
            for index = 1:length(obj.ActiveMaterials)
                TempSum = TempSum + obj.AMsVolumeFractions(index)*obj.ActiveMaterials(index).RelVolumeIncreaseOnLith;
            end
            obj.RelVolumeIncreaseOnLith = TempSum;
            EffectiveProperties = [];
            for index=1:length(obj.ActiveMaterials)
                EffectiveProperties(index) = obj.ActiveMaterials(index).ElectricalConductivity;
            end
            VolumeFractions = obj.AMsVolumeFractions;
            obj.ElectricalConductivity = FcnRecursiveEffectiveMediumTheory(EffectiveProperties, VolumeFractions, CoordinationNumber);
        end
    end
end