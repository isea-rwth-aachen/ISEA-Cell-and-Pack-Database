classdef ElectrodeStack
    % class definition of the object electrode stack of a LIB. The electrode
    % stack combine the two electrodes, Anode and Cathode, the electrolyte and
    % the separator to the stack that will be placed into the housing to build
    % a LIB. The user can choose the number of anode, cathode and separator as
    % well as voltage limits of the electrode stack and the creation mode.
    properties
        Name string
        Anode Electrode
        NrOfAnodes double
        Cathode Electrode
        NrOfCathodes double
        Separator Separator
        NrOfSeparators double
        Electrolyte Electrolyte
        TabLocations string                         % 'SS' = same side; 'OS' = opposite side

        Volume double                               % Sum of Bulkvolume in cm³
        Weight double                               % in g
        ActiveSurface double                        % in cm²
        ActiveSurfaceDimensions double              % in mm
        Capacity double                             % in Ah
        SurfaceCapacity double                      % in mAh/cm²
        TheoCapacity double 						% in Ah
        VoltageLimits double 						% in V

        AnodeOccupancyRate double                   % array
        AnodeUsedOccupancyRange double              % 1x2 vector
        AnodeUsedOccupancyRate double				% array
        AnodeOpenCircuitPotential double            % array, in V
        AnodeOpenCircuitPotentialLith double        % array, in V
        AnodeCapacity double                        % in Ah
        AnodeCcResistance double                    % in mOhm
        AnodeCcTabResistance double                 % in mOhm
        AnodeElectricalResistance double            % in mOhm
        AnodeIonicResistance double                 % in mOhm
        AnodeWeight double                          % in g; weight of all the anodes
        AnodeSurfaceArea double                     % in cm²
        AnodeCoatingWeight double                   % in g
        AnodeCurrentCollectorSurfaceArea double     % in cm²

        CathodeOccupancyRate double                 % array
        CathodeUsedOccupancyRange double            % array
        CathodeUsedOccupancyRate double 			% 1x2 vector
        CathodeOpenCircuitPotential double          % array, in V
        CathodeOpenCircuitPotentialLith double      % array, in V
        CathodeCapacity double                      % in Ah
        CathodeCcResistance double                  % in mOhm
        CathodeCcTabResistance double               % in mOhm
        CathodeElectricalResistance double          % in mOhm
        CathodeIonicResistance double               % in mOhm
        CathodeWeight double                        % in g; weight of all the cathodes
        CathodeSurfaceArea double                   % in cm²
        CathodeCoatingWeight double                 % in g
        CathodeCurrentCollectorSurfaceArea double   % in cm²

        ElectrolyteVolume double                    % in cm³
        ElectrolyteWeight double                    % in g
        ElectrolyteRelativeSurplus = 0.15           % relative surplus of electrolyte volume, rough estimation based on Natalia P. Lebedeva: Amount of Free Liquid Electrolyte in Commercial Large Format Prismatic Li-Ion Battery Cells
        InitElectrolyteConcentration double = 1000 	% in mol/m³

        SeparatorIonicResistance double             % in mOhm
        SeparatorWeight double                      % in g; weight of all the separators
        SeparatorSurfaceArea double                 % in cm²

        ThroughPlainResistance double 				% in mOhm

        InitialOccupancyRanges double               % Vector for initial occupancy with transfer material for anode and cathode
        OpenCircuitVoltage double                   % in V; open circuit voltage vector (corresponding to StateOfCharge)
        OpenCircuitVoltageCha double                % in V; open circuit voltage vector for charging (corresponding to StateOfCharge)
        StateOfCharge double                        % in %; state of charge vector (corresponding to OpenCircuitVoltage)
        NominalVoltage double                       % in V; nominal open circuit voltage; average OCV
        MinOpenCircuitVoltage double                % in V; minimum open circuit voltage
        MaxOpenCircuitVoltage double                % in V; maximum open circuit voltage
        NominalVoltageCha double                    % in V; nominal open circuit voltage; average OCV
        MinOpenCircuitVoltageCha double             % in V; minimum open circuit voltage
        MaxOpenCircuitVoltageCha double             % in V; maximum open circuit voltage
        InternalResistance double                   % in mOhm

        MolLithiumElectrodes double 				% mol Lithium cycleable [cathode anode], theoretically cycleable lithium with respect to the minimum and maximum OR of the electrodes, in mol
        MaxUsedConcentrationAnode double 			% in mol/m³
        MaxUsedConcentrationCathode double 			% in mol/m³

        ActiveTransferMaterialWeight double         % in g
        OverhangElectrode string                    % 'Anode' or 'Cathode' depending on which one has the overhang
        NrOfWindingsOrLayers double                 % number of windings if cylindrical or prismatic design per Jelly Roll
        OrientationOfWindingAxis string             % orientation of the winding axis of the jelly roll if prismatic design; options: 'TD' - top down, 'LR'- left/right,
        ElectrodePairThickness double               % in mm Anode + Cathode + 2*Separator (including two sided coating, current collector etc)
        OverhangArea double                         % in cm²; this is considering the coating overhang rather than electrode overhang
        OverhangFactor double                       % relation of electrode surface areas, hence describing the amount of overhang; = OverhangArea/ActiveSurface; this is considering the coating overhang rather than electrode overhang
        OverhangElectrodeLength double              % in mm; in comparison to other electrode; this is considering the electrode overhang rather than coating overhang, hence this is neglecting the fact that the electrodes are coated on both sides
        OverhangElectrodeHeight double              % in mm; in comparison to other electrode; this is considering the electrode overhang rather than coating overhang, hence this is neglecting the fact that the electrodes are coated on both sides
        OverhangSeparatorLength double              % in mm; in comparison to overhang electrode; since there are twice as many separators or a twice as large separator than electrode the separator overhang is assumed to be folded in two covering both sides of the electrodes resulting in the specified overhang length and height
        OverhangSeparatorHeight double              % in mm; in comparison to overhang electrode; since there are twice as many separators or a twice as large separator than electrode the separator overhang is assumed to be folded in two covering both sides of the electrodes resulting in the specified overhang length and height
        NrOfJellyRolls double                       % number of jelly rolls
        PrismaticWindingStyle string;               % options: 'STD' - Standard, 'LO' - low overhang

        CreationType string 						% type of creation mode
        ThermalResistance double					% in W/K
        ThermalCapacity double 						% in J/K

        ListOfElements table
        ListOfSubstances table
        Verts double
        Faces double

        AddInfo struct                              % any additional info that has to be added to material
        Source string                               % literature source, measurements, etc.
        Confidential string                         % 'Yes' or 'No'
    end
    %% Methods
    methods
        % constructor
        function obj = ElectrodeStack(Name, Anode, NrOfAnodes, Cathode, NrOfCathodes, Separator, NrOfSeparators, Electrolyte...
                ,RelSurplusElectrolyte, CreationMode_value,VoltageLimits,CreationType,InitElectrolyteConcentration)
            obj.Name = Name;
            obj.Anode = Anode;
            obj.NrOfAnodes = NrOfAnodes;
            obj.Cathode = Cathode;
            obj.NrOfCathodes = NrOfCathodes;
            obj.Separator = Separator;
            obj.NrOfSeparators = NrOfSeparators;
            obj.Electrolyte = Electrolyte;
            %check for voltage limits
            if exist('VoltageLimits','var') && ~isempty(VoltageLimits) && isnumeric(VoltageLimits) && numel(VoltageLimits) == 2
                if max(VoltageLimits) <= 5 && min(VoltageLimits) >= 0 && VoltageLimits(1) < VoltageLimits(2)
                    obj.VoltageLimits   = VoltageLimits;
                elseif max(VoltageLimits) <= 5 && min(VoltageLimits) >= 0 && VoltageLimits(1) > VoltageLimits(2)
                    obj.VoltageLimits   = [VoltageLimits(2) VoltageLimits(1)];
                elseif all(VoltageLimits > 0) && all(VoltageLimits < 1)
                    obj.VoltageLimits   = [VoltageLimits(2) VoltageLimits(1)];
                else
                    warning('No consistent voltage limits specified');
                    obj.VoltageLimits   = [0 5];
                end
            else
                obj.VoltageLimits   = [0 5];
            end
            %check for creation type
            if ~exist('CreationType','var')
                obj.CreationType        = 'Standard';
            else
                obj.CreationType        = CreationType;
            end
%% Creation modes
%create electrode stack depending on the choosen creationg mode
%standard:              no regulations for the electrode stack --> first the
%                       calculation of the occupancy rate of the electrodes
%                       depending on the amount of cycleable lithium and
%                       based on this the calculation of the OCV of the
%                       stack
%Voltage limits:        the regulation voltage limits apply. So first
%                       the same steps as in the standard mode and afterwards the adjustment of the stochiometric factors to not
%                       violate voltage limits
%Target Capacity:       Creation mode to fit the electrode stack to a target capacity. Not implemented yet!
%Fit surface capacity:  The surface capacities of the electrodes should be the same. Adjust the thickness of the coating of the electrode with the
%                       higher surface capacity so that they are equal
%Init occupancy rate:   Initial occupancy rates for the electrodes are given, e.g. of freshly produced cells. Adjust the stochiometric window of the electrodes with this information
%Init used rates:       Creation mode with already set max and min occupancy rates of the anode and cathode
            switch obj.CreationType
                case 'Standard'
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                case 'Voltage limits'
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                    obj = SetVoltageRange(obj);
                case 'Target Capacity'
                    error('Not implemented yet!');
                case 'Fit surface capacity'
                    if obj.Anode.SurfaceCapacity > obj.Cathode.SurfaceCapacity
                        obj.Anode=obj.Anode.AdaptThicknessToSurfaceCapacity(obj.Cathode.SurfaceCapacity);
                    elseif obj.Cathode.SurfaceCapacity > obj.Anode.SurfaceCapacity
                        obj.Cathode=obj.Cathode.AdaptThicknessToSurfaceCapacity(obj.Anode.SurfaceCapacity);
                    end
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                    obj = SetVoltageRange(obj);
                case 'Init occupancy rate'
                    if exist('CreationMode_value', 'var') && ~isempty(CreationMode_value) && ~numel(CreationMode_value) ~= 2 && all(CreationMode_value <= 1)
                        obj                                 = CalcUsedOccupancyRate_WithInitRate(obj,CreationMode_value);
                        obj.InitialOccupancyRanges          = CreationMode_value;
                    else %use standard mode
                        obj = CalcUsedOccupancyRate_Standard(obj);
                    end
                    obj = CalcOpenCircuitVoltage(obj);

                    if ~isempty(obj.VoltageLimits)
                        obj = SetVoltageRange(obj);
                    end
                case 'Init used rates'
                    if exist('CreationMode_value', 'var') && iscell(CreationMode_value) && numel(CreationMode_value) == 2 && all(cellfun(@numel,CreationMode_value)==2)
                        obj.AnodeUsedOccupancyRange             = CreationMode_value{1};
                        obj.CathodeUsedOccupancyRange           = CreationMode_value{2};
                    else %use standard mode
                        obj = CalcUsedOccupancyRate_Standard(obj);
                    end
                    obj = CalcOpenCircuitVoltage(obj);

                    if ~isempty(obj.VoltageLimits)
                        obj = SetVoltageRange(obj);
                    end
                otherwise
                    error('Unknown creation type');
            end
            if ~exist('RelSurplusElectrolyte', 'var')
                obj.ElectrolyteRelativeSurplus  = 0.15; %rough estimation based on Natalia P. Lebedeva: Amount of Free Liquid Electrolyte in Commercial Large Format Prismatic Li-Ion Battery Cells
            else
                obj.ElectrolyteRelativeSurplus  = RelSurplusElectrolyte;
            end
            if exist('InitElectrolyteConcentration','var')
                obj.InitElectrolyteConcentration = InitElectrolyteConcentration;
            end
            obj.ElectrodePairThickness = obj.Anode.TotalThickness + obj.Cathode.TotalThickness + 2*obj.Separator.Dimensions(3);
            obj.NrOfJellyRolls=1;
            obj.PrismaticWindingStyle='';
            obj = CalcConcentrations(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcSurfaceArea(obj);
            obj = CalcCapacity(obj);
            obj = CalcInternalResistance(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
            obj = CalcThermalResistance(obj);
            obj = CalcThermalCapacity(obj);
        end
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class ElectrodeStack return 0']);
                output = 0;
            end
        end
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class ElectrodeStack']);
            end
        end
        % refresh after parameter change
        function obj = RefreshCalc(obj,CreationMode_value)
            if ~isprop(obj, 'VoltageLimits')
                obj.VoltageLimits = [0 5];
            elseif isprop(obj, 'VoltageLimits') && isempty(obj.VoltageLimits)
                obj.VoltageLimits = [0 5];
            end
            % check if creation mode was set (downward compatible)
            if isempty(obj.CreationType) && min(obj.VoltageLimits) > 0 || max(obj.VoltageLimits) < 5
                obj.CreationType  = 'Voltage limits';
            elseif isempty(obj.CreationType) && ~isempty(obj.InitialOccupancyRanges)
                obj.CreationType  = 'Init occupancy rate';
            elseif isempty(obj.CreationType)
                obj.CreationType                = 'Init used rates'; % use the init used rates for lithiation due to not change the data of older datasets
                obj.CathodeOccupancyRate        = [min(obj.CathodeOccupancyRate) max(obj.CathodeOccupancyRate)];
                obj.AnodeOccupancyRate          = [min(obj.AnodeOccupancyRate) max(obj.AnodeOccupancyRate)];
            end
            switch obj.CreationType
                case {'Standard' 'standard'}
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                case 'Voltage limits'
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                    obj = SetVoltageRange(obj);
                case 'Target Capacity'
                    error('Not implemented yet!');
                case 'Fit Coating dimensions'
                    if obj.Anode.SurfaceCapacity > obj.Cathode.SurfaceCapacity
                        obj.Anode       =   obj.Anode.AdaptThicknessToSurfaceCapacity(obj.Cathode.SurfaceCapacity);
                    elseif obj.Cathode.SurfaceCapacity > obj.Anode.SurfaceCapacity
                        obj.Cathode     = obj.Cathode.AdaptThicknessToSurfaceCapacity(obj.Anode.SurfaceCapacity);
                    end
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                    obj = SetVoltageRange(obj);
                case 'Init occupancy rate'
                    if (exist('CreationMode_value', 'var') && ~isempty(obj.InitialOccupancyRanges) && ~numel(obj.InitialOccupancyRanges) ~= 2 && all(obj.InitialOccupancyRanges <= 1)) || ~isempty(obj.InitialOccupancyRanges)
                        if ~isempty(obj.InitialOccupancyRanges) && all(obj.InitialOccupancyRanges >= 0) && all(obj.InitialOccupancyRanges <= 1) && numel(obj.InitialOccupancyRanges) == 2
                            obj                                 = CalcUsedOccupancyRate_WithInitRate(obj,obj.InitialOccupancyRanges);
                        else
                            obj                                 = CalcUsedOccupancyRate_WithInitRate(obj,CreationMode_value);
                        end
                    else %use standard mode
                        obj = CalcUsedOccupancyRate_Standard(obj);
                    end
                    obj = CalcOpenCircuitVoltage(obj);

                    if ~isempty(obj.VoltageLimits)
                        obj = SetVoltageRange(obj);
                    end
                case 'Init used rates'
                    if (exist('CreationMode_value', 'var') && iscell(CreationMode_value) && numel(CreationMode_value) == 2 && all(cellfun(@numel,CreationMode_value)==2))
                        obj.AnodeUsedOccupancyRange             = CreationMode_value{1};
                        obj.CathodeUsedOccupancyRange           = CreationMode_value{2};
                    elseif ~(~isempty(obj.AnodeUsedOccupancyRange) && ~isempty(obj.CathodeUsedOccupancyRange)) %use standard mode
                        obj = CalcUsedOccupancyRate_Standard(obj);
                    end

                    obj = CalcOpenCircuitVoltage(obj);

                    if ~isempty(obj.VoltageLimits)
                        obj = SetVoltageRange(obj);
                    end
                case 'Fit surface capacity'
                    if obj.Anode.SurfaceCapacity > obj.Cathode.SurfaceCapacity
                        obj.Anode=obj.Anode.AdaptThicknessToSurfaceCapacity(obj.Cathode.SurfaceCapacity);
                    elseif obj.Cathode.SurfaceCapacity > obj.Anode.SurfaceCapacity
                        obj.Cathode=obj.Cathode.AdaptThicknessToSurfaceCapacity(obj.Anode.SurfaceCapacity);
                    end
                    obj = CalcUsedOccupancyRate_Standard(obj);
                    obj = CalcOpenCircuitVoltage(obj);
                    if ~isempty(obj.VoltageLimits)
                        obj = SetVoltageRange(obj);
                    end
                otherwise
                    error('Unknown creation type');
            end
            obj = CalcConcentrations(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcSurfaceArea(obj);
            obj = CalcCapacity(obj);
            obj = CalcInternalResistance(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
            obj = CalcThermalResistance(obj);
            obj = CalcThermalCapacity(obj);
        end
        % function to set specific voltage ranges
        function obj = SetVoltageRange(obj)
            minV        = obj.VoltageLimits(1);
            maxV        = obj.VoltageLimits(2);
            doRefresh   = false;
            if minV < 1 && maxV < 1
                minV                 = obj.MinOpenCircuitVoltage +  minV * obj.MinOpenCircuitVoltage;
                maxV                 = obj.MaxOpenCircuitVoltageCha - (1 -maxV) * obj.MaxOpenCircuitVoltageCha;
                obj.VoltageLimits    = [minV maxV];
            end
            if obj.MaxOpenCircuitVoltageCha > maxV || obj.MinOpenCircuitVoltage < minV || (obj.MaxOpenCircuitVoltageCha > maxV &&  obj.MinOpenCircuitVoltage > minV) || (obj.MaxOpenCircuitVoltageCha < maxV &&  obj.MinOpenCircuitVoltage < minV)
                obj    = DetermineGoodOPRange(obj);
            end
            if obj.MaxOpenCircuitVoltageCha > maxV
                SOCmax                              = interp1(obj.OpenCircuitVoltageCha, obj.StateOfCharge, maxV);
                obj.AnodeUsedOccupancyRange(2)      = interp1(obj.StateOfCharge, obj.AnodeUsedOccupancyRate, SOCmax);
                obj.CathodeUsedOccupancyRange(1)    = interp1(obj.StateOfCharge, flip(obj.CathodeUsedOccupancyRate), SOCmax);
                doRefresh = true;
            end
            if obj.MinOpenCircuitVoltage < minV
                SOCmin                              = interp1(obj.OpenCircuitVoltage, obj.StateOfCharge, minV);
                obj.AnodeUsedOccupancyRange(1)      = interp1(obj.StateOfCharge, obj.AnodeUsedOccupancyRate, SOCmin);
                obj.CathodeUsedOccupancyRange(2)    = interp1(obj.StateOfCharge, flip(obj.CathodeUsedOccupancyRate), SOCmin);
                doRefresh = true;
            end
            if doRefresh
                obj = CalcOpenCircuitVoltage(obj);
            end
        end
        % function to determine a good occupancy range
        function obj    = DetermineGoodOPRange(obj)
            minV                    = obj.VoltageLimits(1);
            maxV                    = obj.VoltageLimits(2);
            range_cathode           = diff(obj.CathodeUsedOccupancyRange);
            range_anode             = diff(obj.AnodeUsedOccupancyRange);
            obj                     = CalcOpenCircuitVoltage(obj);
            if range_cathode == diff(obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange)
                [ocp_anode_delith,~,OPR_anode]                  = SweepOCP(obj.Anode.Coating.ActiveMaterial,range_anode);
                obj.CathodeOccupancyRate                        = linspace(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1), obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2), length(obj.StateOfCharge));
                obj.CathodeUsedOccupancyRate                    = linspace(obj.CathodeUsedOccupancyRange(1),obj.CathodeUsedOccupancyRange(2),length(obj.StateOfCharge));
                obj.CathodeOpenCircuitPotentialLith             = interp1(obj.Cathode.Coating.ActiveMaterial.OccupancyRate, obj.Cathode.Coating.ActiveMaterial.OpenCircuitPotentialLith, obj.CathodeUsedOccupancyRate, 'spline');
                %discharge
                sweeped_ocvs                                    = cellfun(@(x) fliplr(obj.CathodeOpenCircuitPotentialLith) - x,ocp_anode_delith,'UniformOutput',false);
                absolute_diff_sweeped_ocvs                      = cellfun(@(x) abs(minV-min(x)) + abs(max(x) - maxV),sweeped_ocvs);
                [~,id_min_diff]                                 = min(absolute_diff_sweeped_ocvs);
                x_anode_min                                     = min(OPR_anode{id_min_diff});
                x_anode_max                                     = max(OPR_anode{id_min_diff});
                obj.AnodeUsedOccupancyRange                     = [x_anode_min x_anode_max];
                obj                                             = CalcOpenCircuitVoltage(obj);
            end
            if range_anode == diff(obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange)
                [~,ocp_cathode_lith,OPR_cathode]                    = SweepOCP(obj.Cathode.Coating.ActiveMaterial,range_cathode);
                obj.AnodeOccupancyRate                              = linspace(obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1), obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2), length(obj.StateOfCharge));
                obj.AnodeUsedOccupancyRate                          = linspace(obj.AnodeUsedOccupancyRange(1),obj.AnodeUsedOccupancyRange(2),length(obj.StateOfCharge));
                obj.AnodeOpenCircuitPotential                       = interp1(obj.Anode.Coating.ActiveMaterial.OccupancyRate, obj.Anode.Coating.ActiveMaterial.OpenCircuitPotential, obj.CathodeUsedOccupancyRate, 'spline');
                %discharge
                sweeped_ocvs                                        = cellfun(@(x) fliplr(x) - obj.AnodeOpenCircuitPotential,ocp_cathode_lith,'UniformOutput',false);
                absolute_diff_sweeped_ocvs                          = cellfun(@(x) abs(minV-min(x)) + abs(max(x) - maxV),sweeped_ocvs);
                [~,id_min_diff]                                     = min(absolute_diff_sweeped_ocvs);
                x_cathode_min                                       = min(OPR_cathode{id_min_diff});
                x_cathode_max                                       = max(OPR_cathode{id_min_diff});
                obj.CathodeUsedOccupancyRange                       = [x_cathode_min x_cathode_max];
                obj                                                 = CalcOpenCircuitVoltage(obj);
            end
            if (obj.MaxOpenCircuitVoltageCha > maxV &&  obj.MinOpenCircuitVoltage > minV) || (obj.MaxOpenCircuitVoltageCha < maxV &&  obj.MinOpenCircuitVoltage < minV)
                [ocp_anode_delith,~,OPR_anode]                      = SweepOCP(obj.Anode.Coating.ActiveMaterial,range_anode);
                [~,ocp_cathode_lith,OPR_cathode]                    = SweepOCP(obj.Cathode.Coating.ActiveMaterial,range_cathode);
                %discharge
                sweeped_ocvs                                        = cellfun(@(x) cellfun(@(y) fliplr(y) - x,ocp_cathode_lith,'UniformOutput',false)',ocp_anode_delith,'UniformOutput',false)';
                sweeped_ocvs                                        = vertcat(sweeped_ocvs{:});
                OPR_combined                                        = cellfun(@(x) cellfun(@(y) [min(y) min(x); max(y) max(x)],OPR_cathode,'UniformOutput',false)',OPR_anode,'UniformOutput',false)';
                OPR_combined                                        = vertcat(OPR_combined{:});
                absolute_diff_sweeped_ocvs                          = cellfun(@(x) abs(minV-min(x)) + abs(max(x) - maxV),sweeped_ocvs);
                clear sweeped_ocvs;
                [~,id_min_diff]                                     = min(absolute_diff_sweeped_ocvs);
                x_cathode_min                                       = min(OPR_combined{id_min_diff}(1,1));
                x_cathode_max                                       = max(OPR_combined{id_min_diff}(2,1));
                x_anode_min                                         = min(OPR_combined{id_min_diff}(1,2));
                x_anode_max                                         = max(OPR_combined{id_min_diff}(2,2));
                clear OPR_combined;
                obj.AnodeUsedOccupancyRange                         = [x_anode_min x_anode_max];
                obj.CathodeUsedOccupancyRange                       = [x_cathode_min x_cathode_max];
                obj                                                 = CalcOpenCircuitVoltage(obj);
            end
        end
        % calculate electrode stack properties to optimise the capacity
        function obj = FitStackBestCap (obj, CathodeVoltageLimit, StackVoltageLimits, AnodeUseAreaRestrictions, CathodeUseAreaRestrictions, KeepCapacity)
            Restrictions = [];
            Restrictions.CathodeVoltageLimit=CathodeVoltageLimit;
            Restrictions.StackVoltageLimits=StackVoltageLimits;
            x0 =[AnodeUseAreaRestrictions(1), AnodeUseAreaRestrictions(2), CathodeUseAreaRestrictions(1), CathodeUseAreaRestrictions(2)];
            LB =[AnodeUseAreaRestrictions(1), AnodeUseAreaRestrictions(1), CathodeUseAreaRestrictions(1), CathodeUseAreaRestrictions(1)];
            UB =[AnodeUseAreaRestrictions(2), AnodeUseAreaRestrictions(2), CathodeUseAreaRestrictions(2), CathodeUseAreaRestrictions(2)];
            FitnessFcn = @(x) fcn_FitStackBestCap(x, Restrictions, obj.Anode.Coating, obj.Cathode.Coating);
            problem = createOptimProblem('fmincon','objective',FitnessFcn,'x0',x0,'lb',LB,'ub',UB);
            gs = GlobalSearch('NumStageOnePoints',1000,'NumTrialPoints', 5000, 'MaxTime', 120);
            [x,fval_gs,flg_gs,o_gs] = run(gs,problem);
            if fval_gs<0
                minOR_A=obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(1)+x(1)*(...
                    obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2)-...
                    obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(1));
                maxOR_A=obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(1)+x(2)*(...
                    obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2)-...
                    obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(1));
                minOR_C=obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(1)+x(3)*(...
                    obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2)-...
                    obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(1));
                maxOR_C=obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(1)+x(4)*(...
                    obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2)-...
                    obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(1));
                obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange=[minOR_A, maxOR_A];
                obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange=[minOR_C, maxOR_C];
                obj.Anode.Coating.ActiveMaterial=obj.Anode.Coating.ActiveMaterial.RefreshCalc();
                obj.Cathode.Coating.ActiveMaterial=obj.Cathode.Coating.ActiveMaterial.RefreshCalc();
                obj.Anode.Coating=obj.Anode.Coating.RefreshCalc();
                obj.Cathode.Coating=obj.Cathode.Coating.RefreshCalc();
                SurfaceCapacity = obj.Anode.SurfaceCapacity;
                obj.Anode=obj.Anode.RefreshCalc();
                obj.Cathode=obj.Cathode.RefreshCalc();
                if exist('KeepCapacity', 'var')
                    if KeepCapacity
                        obj.Anode=obj.Anode.AdaptThicknessToSurfaceCapacity(SurfaceCapacity);
                        obj.Cathode=obj.Cathode.AdaptThicknessToSurfaceCapacity(SurfaceCapacity);
                    end
                end
                obj=obj.RefreshCalc();
            else
                disp('no optimized balancing matches the given criteria');
            end
        end
    end
    %% Methods
    methods
        % calculate cycleable lithium and ajust stoichiometric limits trivial
        function obj = CalcUsedOccupancyRate_Standard(obj)
            total_mol_Li_anode          = obj.Anode.Coating.WeightFractionActiveMaterial * obj.Anode.CoatingWeight / obj.Anode.Coating.ActiveMaterial.MolarMass;
            total_mol_Li_cathode        = obj.Cathode.Coating.WeightFractionActiveMaterial * obj.Cathode.CoatingWeight / obj.Cathode.Coating.ActiveMaterial.MolarMass;
            Li_range_anode              = total_mol_Li_anode * obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange;
            Li_range_cathode            = total_mol_Li_cathode * obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange;
            Li_amount_cycle_anode       = Li_range_anode(2) - Li_range_anode(1);
            Li_amount_cycle_cathode     = Li_range_cathode(2) - Li_range_cathode(1);
            obj.MolLithiumElectrodes    = [Li_amount_cycle_cathode Li_amount_cycle_anode];
            Li_cycleable                = min(obj.MolLithiumElectrodes);
            if Li_amount_cycle_anode < Li_amount_cycle_cathode
                diff_range_cathode              = (1 - Li_cycleable / Li_amount_cycle_cathode) * diff(obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange); %calculate which share of the theoretically lithium is cycleable due to the smaller anode and use the min max OR to get the correction OR
                obj.CathodeUsedOccupancyRange   = [obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(1) + diff_range_cathode/2 obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2) - diff_range_cathode/2];

                obj.AnodeUsedOccupancyRange     = obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange;
            elseif Li_amount_cycle_anode > Li_amount_cycle_cathode
                diff_range_anode                = (1 - Li_cycleable / Li_amount_cycle_anode) * diff(obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange);
                obj.AnodeUsedOccupancyRange     = [obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(1) + diff_range_anode/2 obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2) - diff_range_anode/2];

                obj.CathodeUsedOccupancyRange   = obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange;
            else
                obj.AnodeUsedOccupancyRange     = obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange;
                obj.CathodeUsedOccupancyRange   = obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange;
            end

        end
        % calculation of used occupancy rate with initial rate
        function obj = CalcUsedOccupancyRate_WithInitRate(obj,InitialOccupancyRanges)
            TFCathodeToAnode = 1/(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)-obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1))*obj.Cathode.SurfaceCapacity/obj.Anode.SurfaceCapacity*...
                (obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)-obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1));

            AnodeTheoreticMaxOR             = InitialOccupancyRanges(1)+(InitialOccupancyRanges(2)-obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1))*TFCathodeToAnode;
            CathodeTheoreticMaxOR           = InitialOccupancyRanges(2)+(InitialOccupancyRanges(1)-obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1))/TFCathodeToAnode;
            AnodeTheoreticMinOR             = InitialOccupancyRanges(1)-(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)-InitialOccupancyRanges(2))*TFCathodeToAnode;
            CathodeTheoreticMinOR           = InitialOccupancyRanges(2)-(obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)-InitialOccupancyRanges(1)) /TFCathodeToAnode;
            if AnodeTheoreticMaxOR<obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)
                obj.AnodeUsedOccupancyRange(2)          = AnodeTheoreticMaxOR;
                %Cathode min OR can be reached thus not changed
            else
                %Anode max OR can be reached thus not changed
                obj.CathodeUsedOccupancyRange(1)        = CathodeTheoreticMinOR;
            end
            if CathodeTheoreticMaxOR<obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)
                obj.CathodeUsedOccupancyRange(2)        = CathodeTheoreticMaxOR;
                %Anode min OR can be reached thus not changed
            else
                %Cathode max OR can be reached thus not changed
                obj.AnodeUsedOccupancyRange(1)          = AnodeTheoreticMinOR;
            end
        end
        % calculation of volume
        function obj = CalcVolume(obj)
            obj.ElectrolyteVolume = (1 + obj.ElectrolyteRelativeSurplus) * (obj.NrOfAnodes * obj.Anode.ElectrolyteAvailableVolume + obj.NrOfSeparators * obj.Separator.ElectrolyteAvailableVolume + obj.NrOfCathodes * obj.Cathode.ElectrolyteAvailableVolume);
            obj.Volume = obj.NrOfAnodes * obj.Anode.Volume + obj.NrOfSeparators * obj.Separator.Volume + obj.NrOfCathodes * obj.Cathode.Volume; % Sum of Bulkvolume in cm³
        end
        % calculation of weight
        function obj = CalcWeight(obj)
            obj.AnodeCoatingWeight = obj.NrOfAnodes * obj.Anode.CoatingWeight;
            obj.CathodeCoatingWeight = obj.NrOfCathodes * obj.Cathode.CoatingWeight;
            obj.ElectrolyteWeight = obj.ElectrolyteVolume * obj.Electrolyte.Density; % in cm³ * g/cm³ = g
            obj.AnodeWeight = obj.NrOfAnodes * obj.Anode.Weight;
            obj.CathodeWeight = obj.NrOfCathodes * obj.Cathode.Weight;
            obj.SeparatorWeight = obj.NrOfSeparators * obj.Separator.Weight;
            obj.ActiveTransferMaterialWeight=min([obj.NrOfAnodes*obj.Anode.ActiveTransferMaterialWeight, obj.NrOfCathodes*obj.Cathode.ActiveTransferMaterialWeight]);
            obj.Weight = obj.AnodeWeight + obj.CathodeWeight + obj.SeparatorWeight + obj.ActiveTransferMaterialWeight + obj.ElectrolyteWeight; % in g
        end
        % calculation of surface area
        function obj = CalcSurfaceArea(obj)
            obj.AnodeSurfaceArea = obj.NrOfAnodes * obj.Anode.ActiveSurface;
            obj.AnodeCurrentCollectorSurfaceArea = obj.NrOfAnodes * obj.Anode.CurrentCollector.SurfaceArea;
            obj.CathodeSurfaceArea = obj.NrOfCathodes * obj.Cathode.ActiveSurface;
            obj.CathodeCurrentCollectorSurfaceArea = obj.NrOfCathodes * obj.Cathode.CurrentCollector.SurfaceArea;
            obj.SeparatorSurfaceArea = obj.NrOfSeparators * obj.Separator.SurfaceArea;
            if obj.AnodeSurfaceArea > obj.CathodeSurfaceArea
                obj.ActiveSurface = obj.CathodeSurfaceArea;
                obj.OverhangElectrode = 'Anode';
                obj.OverhangArea = obj.AnodeSurfaceArea - obj.CathodeSurfaceArea;
                obj.OverhangFactor = obj.OverhangArea/obj.ActiveSurface;
            else
                obj.ActiveSurface = obj.AnodeSurfaceArea;
                obj.OverhangElectrode = 'Cathode';
                obj.OverhangArea = obj.CathodeSurfaceArea - obj.AnodeSurfaceArea;
                obj.OverhangFactor = obj.OverhangArea/obj.ActiveSurface;
            end
        end
        % calculation of capacity
        function obj = CalcCapacity(obj)
            obj.AnodeCapacity       = obj.Anode.SurfaceCapacity * obj.Anode.ActiveSurface / 1000 * obj.NrOfAnodes; % in mAh/cm² * cm² /1000 = Ah
            obj.CathodeCapacity     = obj.Cathode.SurfaceCapacity * obj.Cathode.ActiveSurface / 1000 * obj.NrOfCathodes; % in mAh/cm² * cm² /1000 = Ah
            obj.TheoCapacity        = min(obj.AnodeCapacity, obj.CathodeCapacity); % in Ah
            chem_capacity_cathode   = 96485.33212 * 1/obj.Cathode.Coating.ActiveMaterial.MolarMass * 1 * obj.Cathode.CoatingWeight * obj.Cathode.Coating.WeightFractionActiveMaterial * 1/3600;
            chem_capacity_anode     = 96485.33212 * 1/obj.Anode.Coating.ActiveMaterial.MolarMass * 1 * obj.Anode.CoatingWeight * obj.Anode.Coating.WeightFractionActiveMaterial * 1/3600;
            cycle_capacity_cathode  = chem_capacity_cathode * diff(obj.CathodeUsedOccupancyRange);
            cycle_capacity_anode    = chem_capacity_anode * diff(obj.AnodeUsedOccupancyRange);
            obj.Capacity            = min(cycle_capacity_cathode * obj.NrOfCathodes, cycle_capacity_anode * obj.NrOfAnodes);
        end
        % calculation of OCV
        function obj = CalcOpenCircuitVoltage(obj)
            obj.StateOfCharge = 0:0.001:1;
            obj.AnodeOccupancyRate              = linspace(obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1), obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2), length(obj.StateOfCharge));
            obj.CathodeOccupancyRate            = linspace(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1), obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2), length(obj.StateOfCharge));
            obj.CathodeUsedOccupancyRate        = linspace(obj.CathodeUsedOccupancyRange(1),obj.CathodeUsedOccupancyRange(2),length(obj.StateOfCharge));
            obj.AnodeUsedOccupancyRate          = linspace(obj.AnodeUsedOccupancyRange(1),obj.AnodeUsedOccupancyRange(2),length(obj.StateOfCharge));
            obj.AnodeOpenCircuitPotential       = interp1(obj.Anode.Coating.ActiveMaterial.OccupancyRate, obj.Anode.Coating.ActiveMaterial.OpenCircuitPotential, obj.AnodeUsedOccupancyRate, 'spline');
            obj.AnodeOpenCircuitPotentialLith   = interp1(obj.Anode.Coating.ActiveMaterial.OccupancyRate, obj.Anode.Coating.ActiveMaterial.OpenCircuitPotentialLith, obj.AnodeUsedOccupancyRate, 'spline');
            obj.CathodeOpenCircuitPotential     = interp1(obj.Cathode.Coating.ActiveMaterial.OccupancyRate, obj.Cathode.Coating.ActiveMaterial.OpenCircuitPotential, obj.CathodeUsedOccupancyRate, 'spline');
            obj.CathodeOpenCircuitPotentialLith = interp1(obj.Cathode.Coating.ActiveMaterial.OccupancyRate, obj.Cathode.Coating.ActiveMaterial.OpenCircuitPotentialLith, obj.CathodeUsedOccupancyRate, 'spline');
            %discharge
            obj.OpenCircuitVoltage              = fliplr(obj.CathodeOpenCircuitPotentialLith) - obj.AnodeOpenCircuitPotential;
            obj.NominalVoltage                  = sum(obj.OpenCircuitVoltage) / length(obj.OpenCircuitVoltage);
            obj.MinOpenCircuitVoltage           = min(obj.OpenCircuitVoltage);
            obj.MaxOpenCircuitVoltage           = max(obj.OpenCircuitVoltage);
            %charge
            obj.OpenCircuitVoltageCha           = fliplr(obj.CathodeOpenCircuitPotential) - obj.AnodeOpenCircuitPotentialLith;
            obj.NominalVoltageCha               = sum(obj.OpenCircuitVoltageCha) / length(obj.OpenCircuitVoltageCha);
            obj.MinOpenCircuitVoltageCha        = min(obj.OpenCircuitVoltageCha);
            obj.MaxOpenCircuitVoltageCha        = max(obj.OpenCircuitVoltageCha);
        end
        % calculation fo internal resistance
        function obj = CalcInternalResistance(obj)
            if isempty(obj.NrOfAnodes) || isempty(obj.NrOfCathodes) || isempty(obj.NrOfSeparators)
                error_exception     = MException('ElctrodeStack:CalcInternalResistance','The calculation of the internal resistance is not possible because no number of anodes, cathodes and/or separators has been defined.');
                throw(error_exception);
            end
            obj.AnodeCcTabResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.TabDimensions(2) / (obj.Anode.CurrentCollector.TabDimensions(1) * obj.Anode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeCcResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.Dimensions(2) / (obj.Anode.CurrentCollector.Dimensions(1) * obj.Anode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeElectricalResistance = 1 / obj.Anode.Coating.ElectricalConductivity * obj.Anode.CoatingTortuosity / (1 - obj.Anode.Porosity) * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Anode.ElectrolyteTortuosity / obj.Anode.Porosity * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeCcTabResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.TabDimensions(2) / (obj.Cathode.CurrentCollector.TabDimensions(1) * obj.Cathode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeCcResistance = 1 / obj.NrOfCathodes *  1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.Dimensions(2) / (obj.Cathode.CurrentCollector.Dimensions(1) * obj.Cathode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeElectricalResistance = 1 / obj.Cathode.Coating.ElectricalConductivity * obj.Cathode.CoatingTortuosity / (1 - obj.Cathode.Porosity) * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Cathode.ElectrolyteTortuosity / obj.Cathode.Porosity * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.SeparatorIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Separator.Tortuosity / obj.Separator.Porosity * obj.Separator.Dimensions(3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.ThroughPlainResistance = (obj.AnodeElectricalResistance * obj.AnodeIonicResistance / (obj.AnodeElectricalResistance + obj.AnodeIonicResistance) ...
                + obj.SeparatorIonicResistance ...
                + obj.CathodeElectricalResistance * obj.CathodeIonicResistance / (obj.CathodeElectricalResistance + obj.CathodeIonicResistance));
            obj.InternalResistance = CalcResistanceNetworkSameSide(obj.AnodeCcResistance, obj.ThroughPlainResistance, obj.CathodeCcResistance);
        end

        function obj = CalcThermalResistance(obj)
            %todo
        end

        function obj = CalcThermalCapacity(obj)
            ThermalCapacityAnode = obj.NrOfAnodes * obj.Anode.CoatingWeight / 1000 * obj.Anode.Coating.ThermalCapacity ...
                + obj.NrOfAnodes * obj.Anode.CurrentCollector.Weight / 1000 * obj.Anode.CurrentCollector.Material.ThermalCapacity ...
                + obj.NrOfAnodes * (obj.Anode.ElectrolyteAvailableVolume + obj.ElectrolyteRelativeSurplus)  * obj.Electrolyte.Density / 1000 * obj.Electrolyte.ThermalCapacity;
            ThermalCapacityCathode = obj.NrOfCathodes * obj.Cathode.CoatingWeight / 1000 * obj.Cathode.Coating.ThermalCapacity ...
                + obj.NrOfCathodes * obj.Cathode.CurrentCollector.Weight / 1000 * obj.Cathode.CurrentCollector.Material.ThermalCapacity ...
                + obj.NrOfCathodes * (obj.Cathode.ElectrolyteAvailableVolume + obj.ElectrolyteRelativeSurplus) * obj.Electrolyte.Density / 1000 * obj.Electrolyte.ThermalCapacity;
            ThermalCapacitySeparator = obj.NrOfSeparators * obj.Separator.Weight / 1000 * obj.Separator.ThermalCapacity ...
                + obj.NrOfSeparators * obj.Separator.ElectrolyteAvailableVolume * obj.Electrolyte.Density / 1000 * obj.Electrolyte.ThermalCapacity;
            obj.ThermalCapacity = ThermalCapacityAnode + ThermalCapacityCathode + ThermalCapacitySeparator;
        end

        function obj = CalcListOfElements(obj)
            % add anode
            Anode_ListOfElements = obj.Anode.ListOfElements;
            Anode_ListOfElements.Weight = obj.NrOfAnodes * Anode_ListOfElements.Weight;
            obj.ListOfElements = Anode_ListOfElements;
            % add cathode
            Cathode_ListOfElements = obj.Cathode.ListOfElements;
            Cathode_ListOfElements.Weight = obj.NrOfCathodes * Cathode_ListOfElements.Weight;
            obj.ListOfElements = [obj.ListOfElements; Cathode_ListOfElements];
            % add active transfer material
            NewListEntry = {obj.Anode.Coating.ActiveMaterial.TransferMaterial.Name, obj.ActiveTransferMaterialWeight};
            obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            % add separator
            for index = 1:length(obj.Separator.Materials)
                if isa(obj.Separator.Materials(index), 'Element')
                    Element_temp = obj.Separator.Materials(index);
                    Weight_temp = obj.NrOfSeparators * obj.Separator.Weight * obj.Separator.WeightFractions(index);
                    NewListEntry = {Element_temp.Name, Weight_temp};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                elseif isa(obj.Separator.Materials(index), 'Substance')
                    for index2 = 1:length(obj.Separator.Materials(index).Elements)
                        Element_temp = obj.Separator.Materials(index).Elements(index2);
                        Weight_temp = obj.NrOfSeparators * obj.Separator.Weight * obj.Separator.WeightFractions(index) * obj.Separator.Materials(index).ElementsWeightFractions(index2);

                        NewListEntry = {Element_temp.Name, Weight_temp};
                        obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                    end
                else
                    error('Incorrect data type!')
                end
            end
            % add electrolyte solvent
            for index = 1:length(obj.Electrolyte.Solvents)
                for index2 = 1:length(obj.Electrolyte.Solvents(index).Elements)
                    Element_temp = obj.Electrolyte.Solvents(index).Elements(index2);
                    Weight_temp = obj.ElectrolyteWeight * obj.Electrolyte.SolventWeightFractions(index) * obj.Electrolyte.Solvents(index).WeightFractions(index2);

                    NewListEntry = {Element_temp.Name, Weight_temp};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                end
            end
            % add electrolyte conductive salt
            for index = 1:length(obj.Electrolyte.ConductiveSalt.Elements)
                Element_temp = obj.Electrolyte.ConductiveSalt.Elements(index);
                Weight_temp = obj.ElectrolyteWeight * obj.Electrolyte.ConductiveSaltWeightFraction * obj.Electrolyte.ConductiveSalt.WeightFractions(index);

                NewListEntry = {Element_temp.Name, Weight_temp};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            end
            % merge doublets
            ListOfElements_temp = obj.ListOfElements;
            ListOfElements_temp(:,:)=[];
            for index = 1:length(obj.ListOfElements.Element)
                Name_Element = obj.ListOfElements.Element(index);
                bool_found = 0;
                for index2 = 1:length(ListOfElements_temp.Element)
                    if strcmp(Name_Element, ListOfElements_temp.Element(index2))
                        bool_found = 1;
                    end
                end
                if ~bool_found
                    Weight_temp = 0;
                    for index3 = 1:length(obj.ListOfElements.Element)
                        if strcmp(Name_Element, obj.ListOfElements.Element(index3))
                            Weight_temp = Weight_temp + obj.ListOfElements.Weight(index3);
                        end
                    end
                    NewListEntry = {Name_Element, Weight_temp};
                    ListOfElements_temp = [ListOfElements_temp; NewListEntry];
                end
            end
            obj.ListOfElements = ListOfElements_temp;
        end
        % calculation of list of used substances
        function obj = CalcListOfSubstances(obj)
            % add anode
            Anode_ListOfSubstances = obj.Anode.ListOfSubstances;
            Anode_ListOfSubstances.Weight = obj.NrOfAnodes * Anode_ListOfSubstances.Weight;
            obj.ListOfSubstances = Anode_ListOfSubstances;
            % add cathode
            Cathode_ListOfSubstances = obj.Cathode.ListOfSubstances;
            Cathode_ListOfSubstances.Weight = obj.NrOfCathodes * Cathode_ListOfSubstances.Weight;
            obj.ListOfSubstances = [obj.ListOfSubstances; Cathode_ListOfSubstances];
            % add active transfer material
            NewListEntry = {obj.Anode.Coating.ActiveMaterial.TransferMaterial.Abbreviation, obj.ActiveTransferMaterialWeight};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % add separator
            for index = 1:length(obj.Separator.Materials)
                NewListEntry = {obj.Separator.Materials(index).Abbreviation, obj.NrOfSeparators * obj.Separator.Weight * obj.Separator.WeightFractions(index)};
                obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            end
            % add electrolyte solvent
            for index = 1:length(obj.Electrolyte.Solvents)
                NewListEntry = {obj.Electrolyte.Solvents(index).Abbreviation, obj.ElectrolyteWeight * obj.Electrolyte.SolventWeightFractions(index)};
                obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            end
            % add electrolyte conductive salt
            NewListEntry = {obj.Electrolyte.ConductiveSalt.Abbreviation, obj.ElectrolyteWeight * obj.Electrolyte.ConductiveSaltWeightFraction};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % merge doublets
            ListOfSubstances_temp = obj.ListOfSubstances;
            ListOfSubstances_temp(:,:)=[];
            for index = 1:length(obj.ListOfSubstances.Substance)
                Name_Substance = obj.ListOfSubstances.Substance(index);
                bool_found = 0;
                for index2 = 1:length(ListOfSubstances_temp.Substance)
                    if strcmp(Name_Substance, ListOfSubstances_temp.Substance(index2))
                        bool_found = 1;
                    end
                end
                if ~bool_found
                    Weight_temp = 0;
                    for index3 = 1:length(obj.ListOfSubstances.Substance)
                        if strcmp(Name_Substance, obj.ListOfSubstances.Substance(index3))
                            Weight_temp = Weight_temp + obj.ListOfSubstances.Weight(index3);
                        end
                    end
                    NewListEntry = {Name_Substance, Weight_temp};
                    ListOfSubstances_temp = [ListOfSubstances_temp; NewListEntry];
                end
            end
            obj.ListOfSubstances = ListOfSubstances_temp;
        end
        % calculation of electrode's concentrations
        function obj = CalcConcentrations(obj)
            obj.MaxUsedConcentrationAnode       = obj.AnodeUsedOccupancyRange(2)/obj.Anode.Coating.ActiveMaterial.MinMaxOccupancyRange(2) * obj.Anode.Coating.ActiveMaterial.MaxLithiumConcentration;
            obj.MaxUsedConcentrationCathode     = obj.CathodeUsedOccupancyRange(2)/obj.Cathode.Coating.ActiveMaterial.MinMaxOccupancyRange(2) * obj.Cathode.Coating.ActiveMaterial.MaxLithiumConcentration;
        end
        % overload compare operator
        function logical = eq(A,B)
            name_A           = GetProperty(A,'Name');
            name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
            logical          = strcmp(name_A,name_B);
        end
        % calculation of vertices and faces for patch plot
        function obj = CalcVerticesFaces(obj)
            obj.Verts = [];
            obj.Faces = [];
            temp_thickness = 0;
            % add cathode
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces(obj.Cathode.CoatingDimensions(1,:));
            Verts_shift = [0, 0, temp_thickness];
            Verts_temp = Verts_temp + Verts_shift;
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            temp_thickness = temp_thickness+obj.Cathode.CoatingDimensions(1,3);
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces(obj.Cathode.CurrentCollector.Dimensions);
            Verts_shift = [0, 0, temp_thickness];
            Verts_temp = Verts_temp + Verts_shift;
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            temp_thickness = temp_thickness+obj.Cathode.CurrentCollector.Dimensions(3);
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces(obj.Cathode.CoatingDimensions(1,:));
            Verts_shift = [0, 0, temp_thickness];
            Verts_temp = Verts_temp + Verts_shift;
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            temp_thickness = temp_thickness+obj.Cathode.CoatingDimensions(1,3);
        end
    end
end