classdef ElectrodeStack

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

        AnodeOccupancyRate double                   % array
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

        SeparatorIonicResistance double             % in mOhm
        SeparatorWeight double                      % in g; weight of all the separators
        SeparatorSurfaceArea double                 % in cm²

        ThroughPlainResistance_Parallel double      % in mOhm
        ThroughPlainResistance_Serial_20 double     % in mOhm
        ThroughPlainResistance_Serial_50 double     % in mOhm
        ThroughPlainResistance_Serial_80 double     % in mOhm

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
        InternalResistance_Parallel double          % in mOhm
        InternalResistance_Serial_20 double         % in mOhm
        InternalResistance_Serial_50 double         % in mOhm
        InternalResistance_Serial_80 double         % in mOhm
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
                , InitialOccupancyRanges)
            obj.Name = Name;
            obj.Anode = Anode;
            obj.NrOfAnodes = NrOfAnodes;
            obj.Cathode = Cathode;
            obj.NrOfCathodes = NrOfCathodes;
            obj.Separator = Separator;
            obj.NrOfSeparators = NrOfSeparators;
            obj.Electrolyte = Electrolyte;
            obj.TabLocations = "SS";
            obj.OrientationOfWindingAxis='TD';
            if~exist('InitialOccupancyRanges', 'var') %Matching of electrodes to same surface capacity in defined common occupancy range
                disp('No initial degrees of lithiation given. Surface thicknesses will be adapted so the used ranges of both electrodes match.')
                if obj.Anode.SurfaceCapacity > obj.Cathode.SurfaceCapacity
                    obj.Anode=obj.Anode.AdaptThicknessToSurfaceCapacity(obj.Cathode.SurfaceCapacity);
                elseif obj.Cathode.SurfaceCapacity > obj.Anode.SurfaceCapacity
                    obj.Cathode=obj.Cathode.AdaptThicknessToSurfaceCapacity(obj.Anode.SurfaceCapacity);
                end
            else
                TFCathodeToAnode = 1/(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)-obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1))...
                    *obj.Cathode.SurfaceCapacity/obj.Anode.SurfaceCapacity*...
                    (obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)-obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1));
                AnodeTheoreticMaxOR = InitialOccupancyRanges(1)+(InitialOccupancyRanges(2)-obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1))...
                    *TFCathodeToAnode;
                CathodeTheoreticMaxOR = InitialOccupancyRanges(2)+(InitialOccupancyRanges(1)-obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1))...
                    /TFCathodeToAnode;
                AnodeTheoreticMinOR = InitialOccupancyRanges(1)-(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)-InitialOccupancyRanges(2))...
                    *TFCathodeToAnode;
                CathodeTheoreticMinOR = InitialOccupancyRanges(2)-(obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)-InitialOccupancyRanges(1))...
                    /TFCathodeToAnode;
                if AnodeTheoreticMaxOR<obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)
                    obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)=AnodeTheoreticMaxOR;
                    %Cathode min OR can be reached thus not changed
                else
                    %Anode max OR can be reached thus not changed
                    obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1)=CathodeTheoreticMinOR;
                end
                if CathodeTheoreticMaxOR<obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)
                    obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)=CathodeTheoreticMaxOR;
                    %Anode min OR can be reached thus not changed
                else
                    %Cathode max OR can be reached thus not changed
                    obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1)=AnodeTheoreticMinOR;
                end
                obj.Anode.Coating.ActiveMaterial=obj.Anode.Coating.ActiveMaterial.RefreshCalc();
                obj.Cathode.Coating.ActiveMaterial=obj.Cathode.Coating.ActiveMaterial.RefreshCalc();
                obj.Anode.Coating=obj.Anode.Coating.RefreshCalc();
                obj.Cathode.Coating=obj.Cathode.Coating.RefreshCalc();
                obj.Anode = obj.Anode.RefreshCalc();
                obj.Cathode = obj.Cathode.RefreshCalc();
            end
            obj.ElectrodePairThickness = obj.Anode.TotalThickness + obj.Cathode.TotalThickness + 2*obj.Separator.Dimensions(3);
            obj.NrOfJellyRolls=1;
            obj.PrismaticWindingStyle='';
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcSurfaceArea(obj);
            obj = CalcCapacity(obj);
            obj = CalcOpenCircuitVoltage(obj);
            obj = CalcInternalResistance(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
            %             obj = CalcVerticesFaces(obj);
            obj = obj.SetVoltageRange([0, 5], true); %zulässiger Standard-Spannungsbereich einer Zelle: 0-5V
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
        function obj = RefreshCalc(obj)
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcSurfaceArea(obj);
            obj = CalcCapacity(obj);
            obj = CalcOpenCircuitVoltage(obj);
            obj = CalcInternalResistance(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
        end
        % function du set specific voltage ranges
        function obj = SetVoltageRange (obj, VoltageLimits, KeepCapacity)
            minV = VoltageLimits(1);
            maxV = VoltageLimits(2);
            doRefresh=false;
            if obj.MaxOpenCircuitVoltageCha > maxV
                SOCmax=interp1(obj.OpenCircuitVoltageCha, obj.StateOfCharge, maxV);
                obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2)=interp1(obj.StateOfCharge, obj.AnodeOccupancyRate, SOCmax);
                obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1)=interp1(obj.StateOfCharge, flip(obj.CathodeOccupancyRate), SOCmax);
                doRefresh = true;
            end
            if obj.MinOpenCircuitVoltage < minV
                SOCmin=interp1(obj.OpenCircuitVoltage, obj.StateOfCharge, minV);
                obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1)=interp1(obj.StateOfCharge, obj.AnodeOccupancyRate, SOCmin);
                obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2)=interp1(obj.StateOfCharge, flip(obj.CathodeOccupancyRate), SOCmin);
                doRefresh = true;
            end
            % recursive refreshing of all parameter calculations
            if doRefresh
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
            end

        end
        % calculate the stack with the best capacity
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

    methods
        % calculation of the volume
        function obj = CalcVolume(obj)
            obj.ElectrolyteVolume = (1 + obj.ElectrolyteRelativeSurplus) * (obj.NrOfAnodes * obj.Anode.ElectrolyteAvailableVolume + obj.NrOfSeparators * obj.Separator.ElectrolyteAvailableVolume + obj.NrOfCathodes * obj.Cathode.ElectrolyteAvailableVolume);
            obj.Volume = obj.NrOfAnodes * obj.Anode.Volume + obj.NrOfSeparators * obj.Separator.Volume + obj.NrOfCathodes * obj.Cathode.Volume; % Sum of Bulkvolume in cm³
        end
        % calculation of the weight
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
        % calculation of the surface area
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
        % calculation of the capacity
        function obj = CalcCapacity(obj)
            obj.AnodeCapacity = obj.Anode.SurfaceCapacity * obj.ActiveSurface / 1000; % in mAh/cm² * cm² /1000 = Ah
            obj.CathodeCapacity = obj.Cathode.SurfaceCapacity * obj.ActiveSurface / 1000; % in mAh/cm² * cm² /1000 = Ah
            obj.Capacity = min(obj.AnodeCapacity, obj.CathodeCapacity); % in Ah
            obj.SurfaceCapacity = obj.Capacity/obj.ActiveSurface *1000;
        end
        % calculation of the ocv
        function obj = CalcOpenCircuitVoltage(obj)
            obj.StateOfCharge = 0:0.001:1;
            obj.AnodeOccupancyRate = linspace(obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1), obj.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2), length(obj.StateOfCharge));
            obj.CathodeOccupancyRate = linspace(obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1), obj.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2), length(obj.StateOfCharge));
            obj.AnodeOpenCircuitPotential = interp1(obj.Anode.Coating.ActiveMaterial.OccupancyRate, obj.Anode.Coating.ActiveMaterial.OpenCircuitPotential, obj.AnodeOccupancyRate, 'linear', 'extrap');
            obj.AnodeOpenCircuitPotentialLith = interp1(obj.Anode.Coating.ActiveMaterial.OccupancyRate, obj.Anode.Coating.ActiveMaterial.OpenCircuitPotentialLith, obj.AnodeOccupancyRate, 'linear', 'extrap');
            obj.CathodeOpenCircuitPotential = interp1(obj.Cathode.Coating.ActiveMaterial.OccupancyRate, obj.Cathode.Coating.ActiveMaterial.OpenCircuitPotential, obj.CathodeOccupancyRate, 'linear', 'extrap');
            obj.CathodeOpenCircuitPotentialLith = interp1(obj.Cathode.Coating.ActiveMaterial.OccupancyRate, obj.Cathode.Coating.ActiveMaterial.OpenCircuitPotentialLith, obj.CathodeOccupancyRate, 'linear', 'extrap');
            obj.OpenCircuitVoltage = fliplr(obj.CathodeOpenCircuitPotentialLith) - obj.AnodeOpenCircuitPotential;
            obj.NominalVoltage = sum(obj.OpenCircuitVoltage) / length(obj.OpenCircuitVoltage);
            obj.MinOpenCircuitVoltage = min(obj.OpenCircuitVoltage);
            obj.MaxOpenCircuitVoltage = max(obj.OpenCircuitVoltage);
            obj.OpenCircuitVoltageCha = fliplr(obj.CathodeOpenCircuitPotential) - obj.AnodeOpenCircuitPotentialLith;
            obj.NominalVoltageCha = sum(obj.OpenCircuitVoltageCha) / length(obj.OpenCircuitVoltageCha);
            obj.MinOpenCircuitVoltageCha = min(obj.OpenCircuitVoltageCha);
            obj.MaxOpenCircuitVoltageCha = max(obj.OpenCircuitVoltageCha);
        end
        % calculation of the internal resistance
        function obj = CalcInternalResistance(obj)
            % parallel
            obj.AnodeCcTabResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.TabDimensions(2) / (obj.Anode.CurrentCollector.TabDimensions(1) * obj.Anode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeCcResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.Dimensions(2) / (obj.Anode.CurrentCollector.Dimensions(1) * obj.Anode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeElectricalResistance = 1 / obj.Anode.Coating.ElectricalConductivity * obj.Anode.CoatingTortuosity / (1 - obj.Anode.Porosity) * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.AnodeIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Anode.ElectrolyteTortuosity / obj.Anode.Porosity * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeCcTabResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.TabDimensions(2) / (obj.Cathode.CurrentCollector.TabDimensions(1) * obj.Cathode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeCcResistance = 1 / obj.NrOfCathodes *  1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.Dimensions(2) / (obj.Cathode.CurrentCollector.Dimensions(1) * obj.Cathode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeElectricalResistance = 1 / obj.Cathode.Coating.ElectricalConductivity * obj.Cathode.CoatingTortuosity / (1 - obj.Cathode.Porosity) * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Cathode.ElectrolyteTortuosity / obj.Cathode.Porosity * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.SeparatorIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Separator.Tortuosity / obj.Separator.Porosity * obj.Separator.Dimensions(3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.ThroughPlainResistance_Parallel = (obj.AnodeElectricalResistance * obj.AnodeIonicResistance / (obj.AnodeElectricalResistance + obj.AnodeIonicResistance) ...
                + obj.SeparatorIonicResistance ...
                + obj.CathodeElectricalResistance * obj.CathodeIonicResistance / (obj.CathodeElectricalResistance + obj.CathodeIonicResistance));
            % serial
            AnodeReactionSight = 0.2; % relative distance from CC where the charge transder takes place 0.5 = "half way through the thickness of the electrode"
            CathodeReactionSight = 0.2; % relative distance from CC where the charge transder takes place 0.5 = "half way through the thickness of the electrode"
            obj.AnodeCcTabResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.TabDimensions(2) / (obj.Anode.CurrentCollector.TabDimensions(1) * obj.Anode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeCcResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.Dimensions(2) / (obj.Anode.CurrentCollector.Dimensions(1) * obj.Anode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeElectricalResistance = AnodeReactionSight / obj.Anode.Coating.ElectricalConductivity * obj.Anode.CoatingTortuosity / (1 - obj.Anode.Porosity) * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.AnodeIonicResistance = (1 - AnodeReactionSight) / obj.Electrolyte.IonicConductivityNominal * obj.Anode.ElectrolyteTortuosity / obj.Anode.Porosity * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeCcTabResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.TabDimensions(2) / (obj.Cathode.CurrentCollector.TabDimensions(1) * obj.Cathode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeCcResistance = 1 / obj.NrOfCathodes *  1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.Dimensions(2) / (obj.Cathode.CurrentCollector.Dimensions(1) * obj.Cathode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeElectricalResistance = CathodeReactionSight / obj.Cathode.Coating.ElectricalConductivity * obj.Cathode.CoatingTortuosity / (1 - obj.Cathode.Porosity) * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeIonicResistance = (1 - CathodeReactionSight) / obj.Electrolyte.IonicConductivityNominal * obj.Cathode.ElectrolyteTortuosity / obj.Cathode.Porosity * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.SeparatorIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Separator.Tortuosity / obj.Separator.Porosity * obj.Separator.Dimensions(3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.ThroughPlainResistance_Serial_20 = obj.AnodeElectricalResistance + obj.AnodeIonicResistance ...
                + obj.SeparatorIonicResistance ...
                + obj.CathodeElectricalResistance + obj.CathodeIonicResistance;
            % serial
            AnodeReactionSight = 0.5; % relative distance from CC where the charge transder takes place 0.5 = "half way through the thickness of the electrode"
            CathodeReactionSight = 0.5; % relative distance from CC where the charge transder takes place 0.5 = "half way through the thickness of the electrode"
            obj.AnodeCcTabResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.TabDimensions(2) / (obj.Anode.CurrentCollector.TabDimensions(1) * obj.Anode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeCcResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.Dimensions(2) / (obj.Anode.CurrentCollector.Dimensions(1) * obj.Anode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeElectricalResistance = AnodeReactionSight / obj.Anode.Coating.ElectricalConductivity * obj.Anode.CoatingTortuosity / (1 - obj.Anode.Porosity) * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.AnodeIonicResistance = (1 - AnodeReactionSight) / obj.Electrolyte.IonicConductivityNominal * obj.Anode.ElectrolyteTortuosity / obj.Anode.Porosity * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeCcTabResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.TabDimensions(2) / (obj.Cathode.CurrentCollector.TabDimensions(1) * obj.Cathode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeCcResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.Dimensions(2) / (obj.Cathode.CurrentCollector.Dimensions(1) * obj.Cathode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeElectricalResistance = CathodeReactionSight / obj.Cathode.Coating.ElectricalConductivity * obj.Cathode.CoatingTortuosity / (1 - obj.Cathode.Porosity) * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeIonicResistance = (1 - CathodeReactionSight) / obj.Electrolyte.IonicConductivityNominal * obj.Cathode.ElectrolyteTortuosity / obj.Cathode.Porosity * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.SeparatorIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Separator.Tortuosity / obj.Separator.Porosity * obj.Separator.Dimensions(3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.ThroughPlainResistance_Serial_50 = obj.AnodeElectricalResistance + obj.AnodeIonicResistance ...
                + obj.SeparatorIonicResistance ...
                + obj.CathodeElectricalResistance + obj.CathodeIonicResistance;
            % serial
            AnodeReactionSight = 0.8; % relative distance from CC where the charge transder takes place 0.5 = "half way through the thickness of the electrode"
            CathodeReactionSight = 0.8; % relative distance from CC where the charge transder takes place 0.5 = "half way through the thickness of the electrode"
            obj.AnodeCcTabResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.TabDimensions(2) / (obj.Anode.CurrentCollector.TabDimensions(1) * obj.Anode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeCcResistance = 1 / obj.NrOfAnodes * 1 / obj.Anode.CurrentCollector.Material.ElectricalConductivity * obj.Anode.CurrentCollector.Dimensions(2) / (obj.Anode.CurrentCollector.Dimensions(1) * obj.Anode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.AnodeElectricalResistance = AnodeReactionSight / obj.Anode.Coating.ElectricalConductivity * obj.Anode.CoatingTortuosity / (1 - obj.Anode.Porosity) * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.AnodeIonicResistance = (1 - AnodeReactionSight) / obj.Electrolyte.IonicConductivityNominal * obj.Anode.ElectrolyteTortuosity / obj.Anode.Porosity * obj.Anode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeCcTabResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.TabDimensions(2) / (obj.Cathode.CurrentCollector.TabDimensions(1) * obj.Cathode.CurrentCollector.TabDimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeCcResistance = 1 / obj.NrOfCathodes * 1 / obj.Cathode.CurrentCollector.Material.ElectricalConductivity * obj.Cathode.CurrentCollector.Dimensions(2) / (obj.Cathode.CurrentCollector.Dimensions(1) * obj.Cathode.CurrentCollector.Dimensions(3)) * 1e3 * 1e3; % 1 / (S/m) * mm / mm² * 1e3 * 1e3 = mohm
            obj.CathodeElectricalResistance = CathodeReactionSight / obj.Cathode.Coating.ElectricalConductivity * obj.Cathode.CoatingTortuosity / (1 - obj.Cathode.Porosity) * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.CathodeIonicResistance = (1 - CathodeReactionSight) / obj.Electrolyte.IonicConductivityNominal * obj.Cathode.ElectrolyteTortuosity / obj.Cathode.Porosity * obj.Cathode.CoatingDimensions(1, 3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.SeparatorIonicResistance = 1 / obj.Electrolyte.IonicConductivityNominal * obj.Separator.Tortuosity / obj.Separator.Porosity * obj.Separator.Dimensions(3) / obj.ActiveSurface * 1e1 * 1e3; % 1 / (S/m) * mm / cm² * 1e1 * 1e3 = mohm
            obj.ThroughPlainResistance_Serial_80 = obj.AnodeElectricalResistance + obj.AnodeIonicResistance ...
                + obj.SeparatorIonicResistance ...
                + obj.CathodeElectricalResistance + obj.CathodeIonicResistance;
            switch obj.TabLocations
                case 'SS'
                    obj.InternalResistance_Parallel = CalcResistanceNetworkSameSide(obj.AnodeCcResistance, obj.ThroughPlainResistance_Parallel, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                    obj.InternalResistance_Serial_20 = CalcResistanceNetworkSameSide(obj.AnodeCcResistance, obj.ThroughPlainResistance_Serial_20, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                    obj.InternalResistance_Serial_50 = CalcResistanceNetworkSameSide(obj.AnodeCcResistance, obj.ThroughPlainResistance_Serial_50, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                    obj.InternalResistance_Serial_80 = CalcResistanceNetworkSameSide(obj.AnodeCcResistance, obj.ThroughPlainResistance_Serial_80, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                case 'OS'
                    obj.InternalResistance_Parallel = CalcResistanceNetworkOppositeSides(obj.AnodeCcResistance, obj.ThroughPlainResistance_Parallel, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                    obj.InternalResistance_Serial_20 = CalcResistanceNetworkOppositeSides(obj.AnodeCcResistance, obj.ThroughPlainResistance_Serial_20, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                    obj.InternalResistance_Serial_50 = CalcResistanceNetworkOppositeSides(obj.AnodeCcResistance, obj.ThroughPlainResistance_Serial_50, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                    obj.InternalResistance_Serial_80 = CalcResistanceNetworkOppositeSides(obj.AnodeCcResistance, obj.ThroughPlainResistance_Serial_80, obj.CathodeCcResistance) + obj.AnodeCcTabResistance + obj.CathodeCcTabResistance;
                otherwise
                    error('Incorrect TabLocations. Needs to be SS or OS');
            end
            obj.InternalResistance = obj.InternalResistance_Serial_50;
        end
        % create the List of Elements
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
        % creation of list of substances
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