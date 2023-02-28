classdef Electrode
    %     for active_material [length,width,height,length,width,height]
    %     due to two sides if only one side is coated [length,width,height,0,0,0]
    properties
        Name string
        CurrentCollector CurrentCollector

        Coating Coating
        CoatingDimensions double                % width, height, thickness in mm
        CoatingBulkVolume double                % in cm³
        CoatingWeight double                    % in g

        InactiveTransferMaterialWeight double   % in g
        ActiveTransferMaterialWeight double     % in g

        ElectrolyteAvailableVolume double       % in cm³
        Weight double                           % in g excluding ActiveTransferMaterialWeight
        Porosity double                         % no unit 0 <= Porosity <= 1
        CoatingTortuosity double                % no unit 0 <= Tortuosity <= 1
        ElectrolyteTortuosity double            % no unit 0 <= Tortuosity <= 1
        Volume double                           % Bulkvolume in cm³
        ActiveSurface double                    % in cm²
        SurfaceCapacity double                  % in mAh/cm²
        TotalThickness double                   % in mm

        ListOfElements table
        ListOfSubstances table

        AddInfo struct                          % any additional info that has to be added to material
        Source string                           % literature source, measurements, etc.
        Confidential string                     % 'Yes' or 'No'
    end
    %% Methods
    methods
        % constructor
        function obj = Electrode(Name, CurrentCollector, Coating, CoatingDimensions, Porosity, opt_SurfaceCapacity)
            if exist('opt_SurfaceCapacity', 'var') %Set initial value if coating thickness has to be calculated
                CoatingDimensions(1, 3)=0.1;
                CoatingDimensions(2, 3)=0.1;
            end
            obj.Name = Name;
            obj.CurrentCollector = CurrentCollector;
            obj.Coating = Coating;
            obj.CoatingDimensions = CoatingDimensions;
            obj.Porosity = Porosity;
            obj = CalcSurfaceArea(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcSurfaceCapacity(obj);
            obj = CalcTortuosity(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
            if exist('opt_SurfaceCapacity', 'var') %calculate coating thickness to fit surface capacity
                obj=AdaptThicknessToSurfaceCapacity(obj, opt_SurfaceCapacity);
            end
        end
        % function to adapt the thickness to the given surface capacity
        function obj = AdaptThicknessToSurfaceCapacity ( obj, SurfaceCapacity)
            obj.CoatingDimensions(1, 3) = obj.CoatingDimensions(1, 3)*SurfaceCapacity/obj.SurfaceCapacity;
            obj.CoatingDimensions(2, 3) = obj.CoatingDimensions(2, 3)*SurfaceCapacity/obj.SurfaceCapacity;
            obj=RefreshCalc(obj);
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
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Electrode']);
            end
        end
        % refresh the calculation after paramter change
        function obj = RefreshCalc(obj)
            obj = CalcSurfaceArea(obj);
            obj = CalcVolume(obj);
            obj = CalcWeight(obj);
            obj = CalcSurfaceCapacity(obj);
            obj = CalcTortuosity(obj);
            obj = CalcListOfElements(obj);
            obj = CalcListOfSubstances(obj);
        end

    end
    %% Private Methods
    methods (Access = private)
        % calculation of the surface area
        function obj = CalcSurfaceArea(obj)
            obj.ActiveSurface = (obj.CoatingDimensions(1,1) * obj.CoatingDimensions(1,2) + obj.CoatingDimensions(2,1) * obj.CoatingDimensions(2,2)) * 1e-2; % in cm²
        end
        % calculation of the volume
        function obj = CalcVolume(obj)
            obj.TotalThickness = obj.CurrentCollector.Dimensions(3) + obj.CoatingDimensions(1,3) + obj.CoatingDimensions(2,3);
            obj.CoatingBulkVolume = (prod(obj.CoatingDimensions(1,:)) + prod(obj.CoatingDimensions(2,:))) * 1e-3; % in cm³
            obj.ElectrolyteAvailableVolume = obj.Porosity * obj.CoatingBulkVolume; % in cm³
            obj.Volume = obj.CurrentCollector.Volume + obj.CoatingBulkVolume; % in cm³
        end
        % calculation fo the weight
        function obj = CalcWeight(obj)
            obj.CoatingWeight = obj.CoatingBulkVolume * (1 - obj.Porosity) * obj.Coating.Density; % in cm³ * g/cm³ = g
            obj.InactiveTransferMaterialWeight = obj.Coating.ActiveMaterial.CommonOccupancyRange(1) * obj.CoatingWeight / obj.Coating.MolarMass * obj.Coating.ActiveMaterial.TransferMaterial.MolarMass; % in g / (g/mol) * g/mol = g
            obj.ActiveTransferMaterialWeight = (obj.Coating.ActiveMaterial.CommonOccupancyRange(2) - obj.Coating.ActiveMaterial.CommonOccupancyRange(1)) * obj.CoatingWeight / obj.Coating.MolarMass * obj.Coating.ActiveMaterial.TransferMaterial.MolarMass; % in g / (g/mol) * g/mol = g
            obj.Weight = obj.CurrentCollector.Weight + obj.CoatingWeight + obj.InactiveTransferMaterialWeight; % in g
        end
        % calculation of the surface capacity
        function obj = CalcSurfaceCapacity(obj)
            if obj.CoatingDimensions(1,3) ~= obj.CoatingDimensions(2,3)
                warning('the two sides of the coating do not have the same thickness! surface capacity cannot be calculated.');
            end
            obj.SurfaceCapacity = obj.Coating.GravCapacity * obj.Coating.Density * obj.CoatingDimensions(1,3) * 1e-1 * (1 - obj.Porosity); % in mAh/cm²
        end
        % calculation of the tortuosity
        function obj = CalcTortuosity(obj)
            obj.ElectrolyteTortuosity = 1 / power(obj.Porosity, 0.5); % Bruggemann relation
            obj.CoatingTortuosity = 1 / power((1 - obj.Porosity), 0.5); % Bruggemann relation
        end
        %
        function obj = CalcListOfElements(obj)
            obj.ListOfElements = table(0,0);
            obj.ListOfElements.Properties.Description = 'List of elements and their corresponding weight';
            obj.ListOfElements.Properties.VariableNames = {'Element', 'Weight'};
            obj.ListOfElements.Properties.VariableUnits = {'string', 'g'};
            obj.ListOfElements(1,:) = [];
            % add transfer material
            NewListEntry = {obj.Coating.ActiveMaterial.TransferMaterial.Name, obj.InactiveTransferMaterialWeight}; % acitve transfer material will be considered on electrode stack level
            obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            % add current collector
            if isa(obj.CurrentCollector.Material, 'Element')
                NewListEntry = {obj.CurrentCollector.Material.Name, obj.CurrentCollector.Weight};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            elseif isa(obj.CurrentCollector.Material, 'Substance')
                for index = 1: length(obj.CurrentCollector.Material.Elements)
                    Element_temp = obj.CurrentCollector.Material.Elements(index);
                    Weight_temp = obj.CurrentCollector.Weight * obj.CurrentCollector.Material.ElementsWeightFractions(index);
                    NewListEntry = {Element_temp.Name, Weight_temp};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                end
            else
                error('Incorrect data type!')
            end
            % add active material
            for index = 1:length(obj.Coating.ActiveMaterial.Elements)
                Element_temp = obj.Coating.ActiveMaterial.Elements(index);
                MolarFraction_temp = obj.Coating.ActiveMaterial.MolarFractions(index);
                Weight_temp = obj.CoatingWeight * obj.Coating.WeightFractionActiveMaterial / obj.Coating.ActiveMaterial.MolarMass * MolarFraction_temp * Element_temp.MolarMass;
                NewListEntry = {Element_temp.Name, Weight_temp};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            end
            % add binder
            for index = 1:length(obj.Coating.Binder.Elements)
                Element_temp = obj.Coating.Binder.Elements(index);
                MolarFraction_temp = obj.Coating.Binder.MolarFractions(index);
                Weight_temp = obj.CoatingWeight * obj.Coating.WeightFractionBinder / obj.Coating.Binder.MolarMass * MolarFraction_temp * Element_temp.MolarMass;
                NewListEntry = {Element_temp.Name, Weight_temp};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            end
            % add conductive additive
            for index = 1:length(obj.Coating.ConductiveAdditive.Elements)
                Element_temp = obj.Coating.ConductiveAdditive.Elements(index);
                MolarFraction_temp = obj.Coating.ConductiveAdditive.MolarFractions(index);
                Weight_temp = obj.CoatingWeight * obj.Coating.WeightFractionConductiveAdditive / obj.Coating.ConductiveAdditive.MolarMass * MolarFraction_temp * Element_temp.MolarMass;
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
        % Creation of the List of Substances
        function obj = CalcListOfSubstances(obj)
            obj.ListOfSubstances = table(0,0);
            obj.ListOfSubstances.Properties.Description = 'List of substances and their corresponding weight';
            obj.ListOfSubstances.Properties.VariableNames = {'Substance', 'Weight'};
            obj.ListOfSubstances.Properties.VariableUnits = {'string', 'g'};
            obj.ListOfSubstances(1,:) = [];
            % add current collector
            NewListEntry = {obj.CurrentCollector.Material.Abbreviation, obj.CurrentCollector.Weight};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % add active material
            NewListEntry = {obj.Coating.ActiveMaterial.Abbreviation, obj.CoatingWeight * obj.Coating.WeightFractionActiveMaterial + obj.InactiveTransferMaterialWeight};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % add binder
            NewListEntry = {obj.Coating.Binder.Abbreviation, obj.CoatingWeight * obj.Coating.WeightFractionBinder};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % add conductive additive
            NewListEntry = {obj.Coating.ConductiveAdditive.Abbreviation, obj.CoatingWeight * obj.Coating.WeightFractionConductiveAdditive};
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
    end
end