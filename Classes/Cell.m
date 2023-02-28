classdef Cell

    properties
        Name string
        ElectrodeStack ElectrodeStack
        Housing Housing

        Volume double                               % in cm³
        Weight double                               % in g
        Capacity double                             % in Ah
        OpenCircuitVoltage double                   % in V; open circuit voltage vector (corresponding to StateOfCharge)
        OpenCircuitVoltageCha double                % in V; open circuit voltage vector (corresponding to StateOfCharge)
        StateOfCharge double                        % in %; state of charge vector (corresponding to OpenCircuitVoltage)
        NominalVoltage double                       % in V; nominal open circuit voltage; average OCV
        NominalVoltageCha double                    % in V; nominal open circuit voltage; average OCV
        MinOpenCircuitVoltage double                % in V; minimum open circuit voltage
        MaxOpenCircuitVoltage double                % in V; maximum open circuit voltage
        MinOpenCircuitVoltageCha double             % in V; minimum open circuit voltage
        MaxOpenCircuitVoltageCha double             % in V; maximum open circuit voltage
        Energy double                               % in Wh
        EnergyCha double                            % in Wh
        GravEnergyDensity double                    % in Wh/kg
        VolEnergyDensity double                     % in Wh/l
        InternalResistance double                   % in mOhm
        InternalResistanceNormalizedCapacity double % in mOhm*Ah
        Power double                                % in W; the exact definition can be adjusted in function CalcPowerDensity
        GravPowerDensity double                     % in W/kg; the exact definition can be adjusted in function CalcPowerDensity
        VolPowerDensity double                      % in W/l; the exact definition can be adjusted in function CalcPowerDensity
        GravPowerDensityConstHeatGen double         % in W/kg
        VolPowerDensityConstHeatGen double          % in W/l
        GravPowerDensityIdealLoadResistance double  % in W/kg
        VolPowerDensityIdealLoadResistance double   % in W/l
        Type string                                 % options: 'pouch', 'cylindrical', 'prismatic'

        EstimatedElectrodeStackDimensions double                % in mm
        DiscrepancyDimensionsElectrodeStackAndHousing double    % in mm

        Verts double
        Faces double
        GraphicalObjects_Vec GraphicalObject

        ListOfElements table
        ListOfSubstances table
        ListOfComponents table

        AddInfo struct                              % any additional info that has to be added to material
        Source string                               % literature source, measurements, etc.
        Confidential string                         % 'Yes' or 'No'
    end
    %% Methods
    methods
        %constructor
        function obj = Cell(Name, ElectrodeStack, Housing, CreationMode, TargetCapacity)
            obj.Name = Name;
            obj.ElectrodeStack = ElectrodeStack;
            obj.Housing = Housing;
            obj.Volume = obj.Housing.Volume;
            obj.Type = obj.Housing.Type;
            obj.Verts = obj.Housing.Verts;
            obj.Faces = obj.Housing.Faces;

            if ~exist('CreationMode', 'var') %adapt stack dimensions to fit into Housing
                CreationMode = "std";
            end

            if CreationMode == "std"
                obj.CalcNrOfWindingsOrLayers;
            elseif CreationMode == "FitStackToHousing"
                obj = FitStackToHousing(obj);
            elseif CreationMode == "FitCellToCapacity"
                obj = FitStackToHousing(obj);
                obj = FitCellToCapacity(obj, TargetCapacity);
            else
                error('Unknown creation mode')
            end

            obj.Capacity = obj.ElectrodeStack.Capacity;
            obj.OpenCircuitVoltage = obj.ElectrodeStack.OpenCircuitVoltage;
            obj.OpenCircuitVoltageCha = obj.ElectrodeStack.OpenCircuitVoltageCha;
            obj.StateOfCharge = obj.ElectrodeStack.StateOfCharge;
            obj.NominalVoltage = obj.ElectrodeStack.NominalVoltage;
            obj.MinOpenCircuitVoltage = obj.ElectrodeStack.MinOpenCircuitVoltage;
            obj.MaxOpenCircuitVoltage = obj.ElectrodeStack.MaxOpenCircuitVoltage;
            obj.NominalVoltageCha = obj.ElectrodeStack.NominalVoltageCha;
            obj.MinOpenCircuitVoltageCha = obj.ElectrodeStack.MinOpenCircuitVoltageCha;
            obj.MaxOpenCircuitVoltageCha = obj.ElectrodeStack.MaxOpenCircuitVoltageCha;
            obj.InternalResistance = obj.ElectrodeStack.InternalResistance;

            obj.Verts = obj.Housing.Verts;
            obj.Faces = obj.Housing.Faces;
            obj.GraphicalObjects_Vec = obj.Housing.GraphicalObjects_Vec;

            obj = CalcWeight(obj);
            obj = CalcEnergyDensity(obj);
            obj = CalcInternalResistanceNormalizedCapacity(obj);
            obj = CalcPowerDensity(obj);
            obj = CompareElectrodeStackAndHousingDimensions(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
            obj = CalcListOfComponents(obj);
        end
        % get method
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Cell return 0']);
                output = 0;
            end
        end
        % set method
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Cell']);
            end
        end
        %refresh calculation if parameters were changed
        function obj = RefreshCalc(obj)
            obj.Volume = obj.Housing.Volume;
            obj.Type = obj.Housing.Type;
            obj.Verts = obj.Housing.Verts;
            obj.Faces = obj.Housing.Faces;

            obj.Capacity = obj.ElectrodeStack.Capacity;
            obj.OpenCircuitVoltage = obj.ElectrodeStack.OpenCircuitVoltage;
            obj.OpenCircuitVoltageCha = obj.ElectrodeStack.OpenCircuitVoltageCha;
            obj.StateOfCharge = obj.ElectrodeStack.StateOfCharge;
            obj.NominalVoltage = obj.ElectrodeStack.NominalVoltage;
            obj.MinOpenCircuitVoltage = obj.ElectrodeStack.MinOpenCircuitVoltage;
            obj.MaxOpenCircuitVoltage = obj.ElectrodeStack.MaxOpenCircuitVoltage;
            obj.NominalVoltageCha = obj.ElectrodeStack.NominalVoltageCha;
            obj.MinOpenCircuitVoltageCha = obj.ElectrodeStack.MinOpenCircuitVoltageCha;
            obj.MaxOpenCircuitVoltageCha = obj.ElectrodeStack.MaxOpenCircuitVoltageCha;
            obj.InternalResistance = obj.ElectrodeStack.InternalResistance;

            obj = CalcWeight(obj);
            obj = CalcEnergyDensity(obj);
            obj = CalcPowerDensity(obj);
            obj = CompareElectrodeStackAndHousingDimensions(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
            obj = CalcListOfComponents(obj);
        end
        %calculation of the weight
        function obj = CalcWeight(obj)
            obj.Weight = obj.ElectrodeStack.Weight + obj.Housing.Weight; % in g
        end
        % fit the stack dimensions to the housing
        function obj = FitStackToHousing(obj)
            AnodeMaxThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            AnodeMinThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1));
            CathodeMaxThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            CathodeMinThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1));

            if (AnodeMaxThickness+CathodeMinThickness)>(CathodeMaxThickness+AnodeMinThickness)
                AnodeThickness = AnodeMaxThickness;
                CathodeThickness = CathodeMinThickness;
            else
                AnodeThickness = AnodeMinThickness;
                CathodeThickness = CathodeMaxThickness;
            end

            if strcmp(obj.Housing.Type, 'pouch')
                ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(1);
                ElectrodeStackHeight = obj.Housing.AvailableStackDimensions(2);
                ElectrodeStackThickness = obj.Housing.AvailableStackDimensions(3);
                NumberOfLayers = (ElectrodeStackThickness-AnodeThickness-2*obj.ElectrodeStack.Separator.Dimensions(3))...
                    /(AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3));
                NumberOfLayers=floor(NumberOfLayers);

                obj.ElectrodeStack.Anode.CoatingDimensions(:,1)=ElectrodeStackWidth;
                obj.ElectrodeStack.Anode.CoatingDimensions(:,2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)=ElectrodeStackWidth;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1)=ElectrodeStackWidth;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)=ElectrodeStackWidth;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Separator.Dimensions(1)=ElectrodeStackWidth;
                obj.ElectrodeStack.Separator.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.NrOfAnodes = NumberOfLayers+1;
                obj.ElectrodeStack.NrOfCathodes = NumberOfLayers;
                obj.ElectrodeStack.NrOfSeparators = 2*NumberOfLayers+2;
                obj.ElectrodeStack.NrOfWindingsOrLayers = NumberOfLayers;

            elseif strcmp(obj.Housing.Type, 'cylindrical')
                NumberOfLayers = (obj.Housing.AvailableStackDimensions(1) - obj.Housing.AvailableStackDimensions(2)...
                    -AnodeThickness - 2*obj.ElectrodeStack.Separator.Dimensions(3))...
                    /(AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3));
                NumberOfLayers=floor(NumberOfLayers);
                ElectrodeStackHeight = obj.Housing.AvailableStackDimensions(3);
                ElectrodePairThickness=AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3);

                AnodeLength = (NumberOfLayers+1)*2*pi*(obj.Housing.AvailableStackDimensions(2)+obj.ElectrodeStack.Separator.Dimensions(3)...
                    +0.5*AnodeThickness+0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                CathodeLength = NumberOfLayers*2*pi*(obj.Housing.AvailableStackDimensions(2)+obj.ElectrodeStack.Separator.Dimensions(3)...
                    +AnodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                    +0.5*CathodeThickness+0.5*((NumberOfLayers)*ElectrodePairThickness));
                SepLength1 = (NumberOfLayers+1)*2*pi*(obj.Housing.AvailableStackDimensions(2)+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                    +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                SepLength2 = (NumberOfLayers+1)*2*pi*(obj.Housing.AvailableStackDimensions(2)+obj.ElectrodeStack.Separator.Dimensions(3)...
                    +AnodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                    +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                SepLength=SepLength1+SepLength2;

                obj.ElectrodeStack.Anode.CoatingDimensions(:, 1)=AnodeLength;
                obj.ElectrodeStack.Anode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)=AnodeLength;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1)=CathodeLength;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)=CathodeLength;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Separator.Dimensions(1)=SepLength;
                obj.ElectrodeStack.Separator.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.NrOfAnodes = 1;
                obj.ElectrodeStack.NrOfCathodes = 1;
                obj.ElectrodeStack.NrOfSeparators = 1;
                obj.ElectrodeStack.NrOfWindingsOrLayers = NumberOfLayers;

            elseif strcmp(obj.Housing.Type, 'prismatic')

                if strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'TD')
                    ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(1);
                    ElectrodeStackHeight = obj.Housing.AvailableStackDimensions(2);
                elseif strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'LR')
                    ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(2);
                    ElectrodeStackHeight = obj.Housing.AvailableStackDimensions(1);
                end

                NumJellyRolls = 5*obj.Housing.AvailableStackDimensions(3)/ElectrodeStackWidth;
                NumJellyRolls = ceil(NumJellyRolls);
                obj.ElectrodeStack.NrOfJellyRolls = NumJellyRolls;
                % Stack height has to be lower than a 5th of its width

                ElectrodeStackThickness = obj.Housing.AvailableStackDimensions(3)/obj.ElectrodeStack.NrOfJellyRolls;
                ElectrodePairThickness=AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3);
                if strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'STD')
                    NumberOfLayers = (ElectrodeStackThickness-2*AnodeThickness-4*obj.ElectrodeStack.Separator.Dimensions(3))...
                        /(2*(AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3)));
                    NumberOfLayers=floor(NumberOfLayers);
                    StackThicknesNew = AnodeThickness*(2*NumberOfLayers+2)+CathodeThickness*2*NumberOfLayers...
                        +obj.ElectrodeStack.Separator.Dimensions(3)*(4*NumberOfLayers+4);

                    AnodeLengthRound = (NumberOfLayers+1)*2*pi*(obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*AnodeThickness+0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    CathodeLengthRound = NumberOfLayers*2*pi*(obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*CathodeThickness+0.5*((NumberOfLayers)*ElectrodePairThickness));
                    SepLength1Round = (NumberOfLayers+1)*2*pi*(0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLength2Round = (NumberOfLayers+1)*2*pi*(obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLengthRound=SepLength1Round+SepLength2Round;
                elseif strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'LO')
                    NumberOfLayers = (ElectrodeStackThickness-2*AnodeThickness-4*obj.ElectrodeStack.Separator.Dimensions(3)-AnodeThickness)...
                        /(2*(AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3)));
                    NumberOfLayers=floor(NumberOfLayers);
                    StackThicknesNew = AnodeThickness*(2*NumberOfLayers+2)+CathodeThickness*(2*NumberOfLayers+1)...
                        +obj.ElectrodeStack.Separator.Dimensions(3)*(4*NumberOfLayers+4);

                    AnodeLengthRound = (NumberOfLayers+1)*2*pi*(0.5*CathodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*AnodeThickness+0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    CathodeLengthRound = NumberOfLayers*2*pi*(0.5*CathodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*CathodeThickness+0.5*((NumberOfLayers)*ElectrodePairThickness));
                    SepLength1Round = (NumberOfLayers+1)*2*pi*(0.5*CathodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLength2Round = (NumberOfLayers+1)*2*pi*(0.5*CathodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLengthRound=SepLength1Round+SepLength2Round;
                else
                    error('Incorrect winding style!')
                end

                if strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'STD')
                    AnodeLength=AnodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers+2);
                    CathodeLength=CathodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers);
                    SepLength=SepLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(4*NumberOfLayers+4);
                elseif strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'LO')
                    AnodeLength=AnodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers+2);
                    CathodeLength=CathodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers+1);
                    SepLength=SepLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(4*NumberOfLayers+4);
                else
                    error('Incorrect winding style!')
                end

                obj.ElectrodeStack.Anode.CoatingDimensions(:, 1)=AnodeLength;
                obj.ElectrodeStack.Anode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)=AnodeLength;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1)=CathodeLength;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)=CathodeLength;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Separator.Dimensions(1)=SepLength;
                obj.ElectrodeStack.Separator.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.NrOfAnodes = obj.ElectrodeStack.NrOfJellyRolls;
                obj.ElectrodeStack.NrOfCathodes = obj.ElectrodeStack.NrOfJellyRolls;
                obj.ElectrodeStack.NrOfSeparators = obj.ElectrodeStack.NrOfJellyRolls;
                obj.ElectrodeStack.NrOfWindingsOrLayers = NumberOfLayers;
                obj.ElectrodeStack.Anode.CurrentCollector.TabNumber=NumberOfLayers+1;
                obj.ElectrodeStack.Cathode.CurrentCollector.TabNumber=NumberOfLayers;
            end

            if NumberOfLayers<=0
                obj.ElectrodeStack.Anode.CoatingDimensions(:, 1)=0;
                obj.ElectrodeStack.Anode.CoatingDimensions(:, 2)=0;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)=0;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(2)=0;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1)=0;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 2)=0;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)=0;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(2)=0;
                obj.ElectrodeStack.Separator.Dimensions(1)=0;
                obj.ElectrodeStack.Separator.Dimensions(2)=0;
                obj.ElectrodeStack.NrOfAnodes = 0;
                obj.ElectrodeStack.NrOfCathodes = 0;
                obj.ElectrodeStack.NrOfSeparators = 0;
                obj.ElectrodeStack.NrOfWindingsOrLayers = 0;
                obj.ElectrodeStack.Anode.CurrentCollector.TabNumber=0;
                obj.ElectrodeStack.Cathode.CurrentCollector.TabNumber=0;
            end

            obj.ElectrodeStack.Anode.CurrentCollector=obj.ElectrodeStack.Anode.CurrentCollector.RefreshCalc();
            obj.ElectrodeStack.Cathode.CurrentCollector=obj.ElectrodeStack.Cathode.CurrentCollector.RefreshCalc();
            obj.ElectrodeStack.Anode=obj.ElectrodeStack.Anode.RefreshCalc();
            obj.ElectrodeStack.Cathode=obj.ElectrodeStack.Cathode.RefreshCalc();
            obj.ElectrodeStack.Separator=obj.ElectrodeStack.Separator.RefreshCalc();
            obj.ElectrodeStack=obj.ElectrodeStack.RefreshCalc();
        end
        %calculate dimensions to fit the cell to a target capacity
        function obj = FitCellToCapacity(obj, TargetCapacity)
            AnodeMaxThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            AnodeMinThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1));
            CathodeMaxThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            CathodeMinThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1));

            if (AnodeMaxThickness+CathodeMinThickness)>(CathodeMaxThickness+AnodeMinThickness)
                AnodeThickness = AnodeMaxThickness;
                CathodeThickness = CathodeMinThickness;
            else
                AnodeThickness = AnodeMinThickness;
                CathodeThickness = CathodeMaxThickness;
            end

            if strcmp(obj.Housing.Type, 'pouch')
                NumberOfLayers = obj.ElectrodeStack.NrOfCathodes*TargetCapacity/obj.ElectrodeStack.Capacity;
                NumberOfLayers = ceil(NumberOfLayers);
                ElectrodeStackThickness = CathodeThickness * NumberOfLayers + ...
                    AnodeThickness * (NumberOfLayers+1) + ...
                    obj.ElectrodeStack.Separator.Dimensions(3) * (2*NumberOfLayers+2);

                obj.Housing.Dimensions(3)=ElectrodeStackThickness+2*obj.Housing.WallThickness...
                    +obj.Housing.RestrictionsOfInnerDimensions(5)+obj.Housing.RestrictionsOfInnerDimensions(6);

                obj.ElectrodeStack.NrOfAnodes = NumberOfLayers+1;
                obj.ElectrodeStack.NrOfCathodes = NumberOfLayers;
                obj.ElectrodeStack.NrOfSeparators = 2*NumberOfLayers+2;
                obj.ElectrodeStack.NrOfWindingsOrLayers = NumberOfLayers;

                obj.ElectrodeStack=obj.ElectrodeStack.RefreshCalc();
                obj.Housing=obj.Housing.RefreshCalc;

            elseif strcmp(obj.Housing.Type, 'cylindrical')
                error('due to standardized formats, cylindrical Housings do not support the possibility of fitting the housing to the electrode stack')

            elseif strcmp(obj.Housing.Type, 'prismatic')
                if strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'TD')
                    ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(1);
                    ElectrodeStackHeight = obj.Housing.AvailableStackDimensions(2);
                elseif strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'LR')
                    ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(2);
                    ElectrodeStackHeight = obj.Housing.AvailableStackDimensions(1);
                end
                ElectrodePairThickness=AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3);

                EquivalentPouchThickness = TargetCapacity/(ElectrodeStackWidth*ElectrodeStackHeight*...
                    2*obj.ElectrodeStack.Cathode.SurfaceCapacity/100/1000)*ElectrodePairThickness /0.9;
                % Thickness of an equivalent cell in pouch setup assuming
                % an infill of 90% compensating for void space in
                % prismatic cells

                NumJellyRollsOld = obj.ElectrodeStack.NrOfJellyRolls;
                NumJellyRolls = 5*EquivalentPouchThickness/ElectrodeStackWidth;
                NumJellyRolls = ceil(NumJellyRolls);
                obj.ElectrodeStack.NrOfJellyRolls = NumJellyRolls;
                % Stack height has to be lower than a 5th of its width

                CathodeLengthOldTotal = min(obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1)) * NumJellyRollsOld;
                CathodeLengthNew = CathodeLengthOldTotal * TargetCapacity / obj.ElectrodeStack.Capacity / NumJellyRolls;

                if strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'STD')

                    S=obj.ElectrodeStack.Separator.Dimensions(3);
                    A=AnodeThickness;
                    K=CathodeThickness;
                    P=ElectrodePairThickness;
                    W=ElectrodeStackWidth;
                    L=CathodeLengthNew;

                    p=(-(4*pi-8)*S-(2*pi-4)*A-pi*K-2*W)/((4-pi)*P);
                    q=L/((4-pi)*P);
                    NumberOfLayers = -p/2-sqrt((-p/2)^2-q); %Solution of quadratic equation above

                    NumberOfLayers=ceil(NumberOfLayers);

                    StackThicknesNew = AnodeThickness*(2*NumberOfLayers+2)+CathodeThickness*2*NumberOfLayers...
                        +obj.ElectrodeStack.Separator.Dimensions(3)*(4*NumberOfLayers+4);

                    AnodeLengthRound = (NumberOfLayers+1)*2*pi*(obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*AnodeThickness+0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    CathodeLengthRound = NumberOfLayers*2*pi*(obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*CathodeThickness+0.5*((NumberOfLayers)*ElectrodePairThickness));
                    SepLength1Round = (NumberOfLayers+1)*2*pi*(0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLength2Round = (NumberOfLayers+1)*2*pi*(obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLengthRound=SepLength1Round+SepLength2Round;
                elseif strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'LO')

                    S=obj.ElectrodeStack.Separator.Dimensions(3);
                    A=AnodeThickness;
                    K=CathodeThickness;
                    P=ElectrodePairThickness;
                    W=ElectrodeStackWidth;
                    L=CathodeLengthNew;

                    p=(-(4*pi-8)*S-(2*pi-4)*A-(2*pi-2)*K-2*W+2*P)/((4-pi)*P);
                    q=(L-(W-2*A-K-4*S))/((4-pi)*P);
                    NumberOfLayers = -p/2-sqrt((-p/2)^2-q); %Solution of quadratic equation above

                    NumberOfLayers=ceil(NumberOfLayers);

                    StackThicknesNew = AnodeThickness*(2*NumberOfLayers+2)+CathodeThickness*(2*NumberOfLayers+1)...
                        +obj.ElectrodeStack.Separator.Dimensions(3)*(4*NumberOfLayers+4);

                    AnodeLengthRound = (NumberOfLayers+1)*2*pi*(0.5*CathodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*AnodeThickness+0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    CathodeLengthRound = NumberOfLayers*2*pi*(0.5*CathodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*CathodeThickness+0.5*((NumberOfLayers)*ElectrodePairThickness));
                    SepLength1Round = (NumberOfLayers+1)*2*pi*(0.5*CathodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLength2Round = (NumberOfLayers+1)*2*pi*(0.5*CathodeThickness+obj.ElectrodeStack.Separator.Dimensions(3)...
                        +AnodeThickness+0.5*obj.ElectrodeStack.Separator.Dimensions(3)...
                        +0.5*((NumberOfLayers+1)*ElectrodePairThickness));
                    SepLengthRound=SepLength1Round+SepLength2Round;
                else
                    error('Incorrect winding style!')
                end

                if strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'STD')
                    AnodeLength=AnodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers+2);
                    CathodeLength=CathodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers);
                    SepLength=SepLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(4*NumberOfLayers+4);
                elseif strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'LO')
                    AnodeLength=AnodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers+2);
                    CathodeLength=CathodeLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(2*NumberOfLayers+1);
                    SepLength=SepLengthRound+(ElectrodeStackWidth-StackThicknesNew)*(4*NumberOfLayers+4);
                else
                    error('Incorrect winding style!')
                end
                obj.ElectrodeStack.Anode.CoatingDimensions(:, 1)=AnodeLength;
                obj.ElectrodeStack.Anode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)=AnodeLength;
                obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1)=CathodeLength;
                obj.ElectrodeStack.Cathode.CoatingDimensions(:, 2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)=CathodeLength;
                obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.Separator.Dimensions(1)=SepLength;
                obj.ElectrodeStack.Separator.Dimensions(2)=ElectrodeStackHeight;
                obj.ElectrodeStack.NrOfAnodes = obj.ElectrodeStack.NrOfJellyRolls;
                obj.ElectrodeStack.NrOfCathodes = obj.ElectrodeStack.NrOfJellyRolls;
                obj.ElectrodeStack.NrOfSeparators = obj.ElectrodeStack.NrOfJellyRolls;
                obj.ElectrodeStack.NrOfWindingsOrLayers = NumberOfLayers;
                obj.ElectrodeStack.Anode.CurrentCollector.TabNumber=NumberOfLayers+1;
                obj.ElectrodeStack.Cathode.CurrentCollector.TabNumber=NumberOfLayers;
                obj.Housing.Dimensions(3)=obj.ElectrodeStack.NrOfJellyRolls*StackThicknesNew+2*obj.Housing.WallThickness...
                    +obj.Housing.RestrictionsOfInnerDimensions(5)+obj.Housing.RestrictionsOfInnerDimensions(6);

                obj.ElectrodeStack.Anode.CurrentCollector=obj.ElectrodeStack.Anode.CurrentCollector.RefreshCalc();
                obj.ElectrodeStack.Cathode.CurrentCollector=obj.ElectrodeStack.Cathode.CurrentCollector.RefreshCalc();
                obj.ElectrodeStack.Anode=obj.ElectrodeStack.Anode.RefreshCalc();
                obj.ElectrodeStack.Cathode=obj.ElectrodeStack.Cathode.RefreshCalc();
                obj.ElectrodeStack.Separator=obj.ElectrodeStack.Separator.RefreshCalc();
                obj.ElectrodeStack=obj.ElectrodeStack.RefreshCalc();
                obj.Housing=obj.Housing.RefreshCalc();
            end
        end
        %calculation of the energy denisity
        function obj = CalcEnergyDensity(obj)
            obj.Energy = obj.NominalVoltage * obj.Capacity;
            obj.EnergyCha = obj.NominalVoltageCha * obj.Capacity;
            obj.GravEnergyDensity = obj.Energy / obj.Weight * 1e3;
            obj.VolEnergyDensity = obj.Energy / obj.Volume * 1e3;
        end
        %calculation of the internal resistance normalized capacity
        function obj = CalcInternalResistanceNormalizedCapacity(obj)
            obj.InternalResistanceNormalizedCapacity = obj.InternalResistance * obj.Capacity;
        end
        %calculation of the power density
        function obj = CalcPowerDensity(obj)
            SpecificConstHeat = 10; % in W/100g - constant losses per 100g of electrode stack mass;
            ConstHeatGen = SpecificConstHeat * obj.ElectrodeStack.Weight / 100;
            CurrentConstHeatGen = sqrt(ConstHeatGen / obj.InternalResistance * 1000);
            PowerConstHeatGen = (obj.NominalVoltage - CurrentConstHeatGen * obj.InternalResistance / 1000) * CurrentConstHeatGen;
            obj.GravPowerDensityConstHeatGen = PowerConstHeatGen / obj.Weight * 1e3;
            obj.VolPowerDensityConstHeatGen = PowerConstHeatGen / obj.Volume * 1e3;

            IdealLoadResistance = obj.InternalResistance;
            CurrentIdealLoadResistance = obj.NominalVoltage / (IdealLoadResistance + obj.InternalResistance) * 1000;
            PowerIdealLoadResistance = (obj.NominalVoltage - CurrentIdealLoadResistance * obj.InternalResistance / 1000) * CurrentIdealLoadResistance;
            obj.GravPowerDensityIdealLoadResistance = PowerIdealLoadResistance / obj.Weight * 1e3;
            obj.VolPowerDensityIdealLoadResistance = PowerIdealLoadResistance / obj.Volume * 1e3;

            obj.Power = PowerConstHeatGen;
            obj.GravPowerDensity = obj.GravPowerDensityConstHeatGen;
            obj.VolPowerDensity = obj.VolPowerDensityConstHeatGen;
        end
        %method to compare dimensions of electrode stack and housing
        function obj = CompareElectrodeStackAndHousingDimensions(obj)
            AnodeMaxThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            AnodeMinThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1));
            CathodeMaxThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            CathodeMinThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1));

            if (AnodeMaxThickness+CathodeMinThickness)>(CathodeMaxThickness+AnodeMinThickness)
                AnodeThickness = AnodeMaxThickness;
                CathodeThickness = CathodeMinThickness;
            else
                AnodeThickness = AnodeMinThickness;
                CathodeThickness = CathodeMaxThickness;
            end

            if strcmp(obj.Type, 'pouch')
                ElectrodeStackWidth = obj.ElectrodeStack.Separator.Dimensions(1);
                ElectrodeStackHeight = obj.ElectrodeStack.Separator.Dimensions(2);
                ElectrodeStackThickness = CathodeThickness * obj.ElectrodeStack.NrOfCathodes + ...
                    AnodeThickness * (obj.ElectrodeStack.NrOfAnodes) + ...
                    obj.ElectrodeStack.Separator.Dimensions(3) * (obj.ElectrodeStack.NrOfSeparators);
                obj.EstimatedElectrodeStackDimensions = [ElectrodeStackWidth, ElectrodeStackHeight, ElectrodeStackThickness];
                obj.DiscrepancyDimensionsElectrodeStackAndHousing = obj.Housing.AvailableStackDimensions - obj.EstimatedElectrodeStackDimensions;
            elseif strcmp(obj.Type, 'cylindrical')
                ElectrodeStackInnerRadius = obj.Housing.AvailableStackDimensions(2);
                CrossSectionArea = pi()*ElectrodeStackInnerRadius^2 ...
                    +AnodeThickness*obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)*obj.ElectrodeStack.NrOfAnodes ...
                    +CathodeThickness*obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)*obj.ElectrodeStack.NrOfCathodes ...
                    +obj.ElectrodeStack.Separator.Dimensions(3)*obj.ElectrodeStack.Separator.Dimensions(1)*obj.ElectrodeStack.NrOfSeparators;
                ElectrodeStackOuterRadius = sqrt(CrossSectionArea/pi());
                ElectrodeStackHeight = obj.ElectrodeStack.Separator.Dimensions(2);
                obj.EstimatedElectrodeStackDimensions = [ElectrodeStackOuterRadius, ElectrodeStackInnerRadius, ElectrodeStackHeight];
                obj.DiscrepancyDimensionsElectrodeStackAndHousing = obj.Housing.AvailableStackDimensions - obj.EstimatedElectrodeStackDimensions;
            elseif strcmp(obj.Type, 'prismatic')
                CrossSectionArea = ...
                    AnodeThickness*obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(1)*obj.ElectrodeStack.NrOfAnodes ...
                    +CathodeThickness*obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(1)*obj.ElectrodeStack.NrOfCathodes ...
                    +obj.ElectrodeStack.Separator.Dimensions(3)*obj.ElectrodeStack.Separator.Dimensions(1)*obj.ElectrodeStack.NrOfSeparators;
                ElectrodeStackHeight = obj.ElectrodeStack.Separator.Dimensions(2);

                if strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'TD')
                    ElectrodeStackWidth=obj.Housing.AvailableStackDimensions(1);
                elseif strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'LR')
                    ElectrodeStackWidth=obj.Housing.AvailableStackDimensions(2);
                end
                L=ElectrodeStackWidth;
                A=CrossSectionArea;

                p=-L/(1-pi()/4);
                q=A/(1-pi()/4);

                h=-p/2-sqrt((p/2)^2-q);
                ElectrodeStackThickness=h;

                if strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'TD')
                    obj.EstimatedElectrodeStackDimensions = [ElectrodeStackWidth, ElectrodeStackHeight, ElectrodeStackThickness*obj.ElectrodeStack.NrOfJellyRolls];
                elseif strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'LR')
                    obj.EstimatedElectrodeStackDimensions = [ElectrodeStackHeight, ElectrodeStackWidth, ElectrodeStackThickness*obj.ElectrodeStack.NrOfJellyRolls];
                end

                obj.DiscrepancyDimensionsElectrodeStackAndHousing = obj.Housing.AvailableStackDimensions - obj.EstimatedElectrodeStackDimensions;
            else
                error('Incorrect Cell Type!')
            end
        end
        %calculatio of the number of windings or layers
        function obj = CalcNrOfWindingsOrLayers(obj)
            AnodeMaxThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            AnodeMinThickness = obj.ElectrodeStack.Anode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Anode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Anode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Anode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange(1));
            CathodeMaxThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(2));
            CathodeMinThickness = obj.ElectrodeStack.Cathode.CurrentCollector.Dimensions(3) + (obj.ElectrodeStack.Cathode.CoatingDimensions(1, 3)+obj.ElectrodeStack.Cathode.CoatingDimensions(2, 3))...
                *(1+obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.RelVolumeIncreaseOnLith*obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange(1));

            if (AnodeMaxThickness+CathodeMinThickness)>(CathodeMaxThickness+AnodeMinThickness)
                AnodeThickness = AnodeMaxThickness;
                CathodeThickness = CathodeMinThickness;
            else
                AnodeThickness = AnodeMinThickness;
                CathodeThickness = CathodeMaxThickness;
            end

            if strcmp(obj.Housing.Type, 'pouch')
                NumberOfLayers = min(obj.ElectrodeStack.NrOfAnodes, obj.ElectrodeStack.NrOfCathodes);
            elseif strcmp(obj.Housing.Type, 'cylindrical')
                ElectrodePairThickness=AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3);
                CathodeLength = min(obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1));

                S=obj.ElectrodeStack.Separator.Dimensions(3);
                A=AnodeThickness;
                K=CathodeThickness;
                P=ElectrodePairThickness;
                L=CathodeLength;
                Ri_K=obj.Housing.AvailableStackDimensions(2)+S+A+S+0.5*K ; %inner cathode radius

                p=(2*Ri_K)/(P);
                q=-(L)/(pi()*P);
                NumberOfLayers = -p/2+sqrt((-p/2)^2-q); %Solution of quadratic equation above

            elseif strcmp(obj.Housing.Type, 'prismatic')
                if strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'TD')
                    ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(1);
                elseif strcmp(obj.ElectrodeStack.OrientationOfWindingAxis, 'LR')
                    ElectrodeStackWidth = obj.Housing.AvailableStackDimensions(2);
                end
                ElectrodePairThickness=AnodeThickness+CathodeThickness+2*obj.ElectrodeStack.Separator.Dimensions(3);

                CathodeLength = min(obj.ElectrodeStack.Cathode.CoatingDimensions(:, 1));

                if strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'STD')

                    S=obj.ElectrodeStack.Separator.Dimensions(3);
                    A=AnodeThickness;
                    K=CathodeThickness;
                    P=ElectrodePairThickness;
                    W=ElectrodeStackWidth;
                    L=CathodeLength;

                    p=(-(4*pi-8)*S-(2*pi-4)*A-pi*K-2*W)/((4-pi)*P);
                    q=L/((4-pi)*P);
                    NumberOfLayers = -p/2+sqrt((-p/2)^2-q); %Solution of quadratic equation above

                    NumberOfLayers=ceil(NumberOfLayers);

                elseif strcmp(obj.ElectrodeStack.PrismaticWindingStyle, 'LO')

                    S=obj.ElectrodeStack.Separator.Dimensions(3);
                    A=AnodeThickness;
                    K=CathodeThickness;
                    P=ElectrodePairThickness;
                    W=ElectrodeStackWidth;
                    L=CathodeLength;

                    p=(-(4*pi-8)*S-(2*pi-4)*A-(2*pi-2)*K-2*W+2*P)/((4-pi)*P);
                    q=(L-(W-2*A-K-4*S))/((4-pi)*P);
                    NumberOfLayers = -p/2+sqrt((-p/2)^2-q); %Solution of quadratic equation above

                    NumberOfLayers=ceil(NumberOfLayers);

                else
                    error('Incorrect winding style!')
                end
            end
            obj.ElectrodeStack.NrOfWindingsOrLayers = NumberOfLayers;
        end
        %creation of the list of used elements
        function obj = CalcListOfElements(obj)
            % add electrode stack
            obj.ListOfElements = obj.ElectrodeStack.ListOfElements;

            % add housing
            obj.ListOfElements = [obj.ListOfElements; obj.Housing.ListOfElements];

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
        %creation of the list of substances
        function obj = CalcListOfSubstances(obj)
            % add anode
            obj.ListOfSubstances = obj.ElectrodeStack.ListOfSubstances;

            % add housing
            obj.ListOfSubstances = [obj.ListOfSubstances; obj.Housing.ListOfSubstances];

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
        %calculation of the list of components
        function obj = CalcListOfComponents(obj)
            obj.ListOfComponents = table(0,0);
            obj.ListOfComponents.Properties.Description = 'List of components and their corresponding weight';
            obj.ListOfComponents.Properties.VariableNames = {'Component', 'Weight'};
            obj.ListOfComponents.Properties.VariableUnits = {'string', 'g'};
            obj.ListOfComponents(1,:) = [];

            % add anode
            obj.ListOfComponents = [obj.ListOfComponents; {'Anode active material', ...
                obj.ElectrodeStack.NrOfAnodes * obj.ElectrodeStack.Anode.CoatingWeight * obj.ElectrodeStack.Anode.Coating.WeightFractionActiveMaterial ...
                + obj.ElectrodeStack.NrOfAnodes * obj.ElectrodeStack.Anode.InactiveTransferMaterialWeight}];
            obj.ListOfComponents = [obj.ListOfComponents; {'Anode binder', obj.ElectrodeStack.NrOfAnodes * obj.ElectrodeStack.Anode.CoatingWeight * obj.ElectrodeStack.Anode.Coating.WeightFractionBinder}];
            obj.ListOfComponents = [obj.ListOfComponents; {'Anode conductive additive', obj.ElectrodeStack.NrOfAnodes * obj.ElectrodeStack.Anode.CoatingWeight * obj.ElectrodeStack.Anode.Coating.WeightFractionConductiveAdditive}];
            obj.ListOfComponents = [obj.ListOfComponents; {'Anode current collector', obj.ElectrodeStack.NrOfAnodes * obj.ElectrodeStack.Anode.CurrentCollector.Weight}];

            % add cathode
            obj.ListOfComponents = [obj.ListOfComponents; {'Cathode active material', ...
                obj.ElectrodeStack.NrOfCathodes * obj.ElectrodeStack.Cathode.CoatingWeight * obj.ElectrodeStack.Cathode.Coating.WeightFractionActiveMaterial ...
                + obj.ElectrodeStack.NrOfCathodes * obj.ElectrodeStack.Cathode.InactiveTransferMaterialWeight}];
            obj.ListOfComponents = [obj.ListOfComponents; {'Cathode binder', obj.ElectrodeStack.NrOfCathodes * obj.ElectrodeStack.Cathode.CoatingWeight * obj.ElectrodeStack.Cathode.Coating.WeightFractionBinder}];
            obj.ListOfComponents = [obj.ListOfComponents; {'Cathode conductive additive', obj.ElectrodeStack.NrOfCathodes * obj.ElectrodeStack.Cathode.CoatingWeight * obj.ElectrodeStack.Cathode.Coating.WeightFractionConductiveAdditive}];
            obj.ListOfComponents = [obj.ListOfComponents; {'Cathode current collector', obj.ElectrodeStack.NrOfCathodes * obj.ElectrodeStack.Cathode.CurrentCollector.Weight}];

            % add active transfer material
            obj.ListOfComponents = [obj.ListOfComponents; {'Active transfer material', obj.ElectrodeStack.ActiveTransferMaterialWeight}];

            % add separator
            obj.ListOfComponents = [obj.ListOfComponents; {'Separator', obj.ElectrodeStack.SeparatorWeight}];

            % add electrolyte
            obj.ListOfComponents = [obj.ListOfComponents; {'Electrolyte', obj.ElectrodeStack.ElectrolyteWeight}];

            % add housing
            obj.ListOfComponents = [obj.ListOfComponents; {'Housing', obj.Housing.Weight}];
        end
    end
end