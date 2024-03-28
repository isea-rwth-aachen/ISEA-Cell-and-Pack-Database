classdef Housing

    properties
        Name string
        Material Material
        Dimensions double                       % in mm
        WallThickness double                    % in mm
        RestrictionsOfInnerDimensions double    % in mm [left, right, bottom, top, front, back]
        MaterialPosPole Material
        PositionOfPosPole double                % in mm
        SizeOfPosPole double                    % in mm
        WeightPosPole double                    % in g
        MaterialNegPole Material
        PositionOfNegPole double                % in mm
        SizeOfNegPole double                    % in mm
        WeightNegPole double                    % in g
        AdditionalMaterials cell                % vector of additional materials
        AdditionalMaterialWeights double        % vector of additional material weights in g; referring to AdditionalMaterial vector
        WallWeight double                       % in g
        Volume double                           % in cm³
        InnerVolume double                      % in cm³
        AvailableStackDimensions double         % in mm
        Weight double                           % in g
        Type string                             % options: 'pouch', 'cylindrical', 'prismatic'

        Verts double
        Faces double
        GraphicalObjects_Vec GraphicalObject

        ListOfElements table
        ListOfSubstances table

        AddInfo struct                          % any additional info that has to be added to material
        Source string                           % literature source, measurements, etc.
        Confidential string                     % 'Yes' or 'No'
    end
    %% Methods
    methods
        % constructor
        function obj = Housing()
        end
        % refresh calculation if parameter have changed
        function obj = RefreshCalc(obj)
        end
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class Housing return 0']);
                output = 0;
            end
        end
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class Housing']);
            end
        end
        % create list of used Elements
        function obj = CalcListOfElements(obj)
            obj.ListOfElements = table(0,0);
            obj.ListOfElements.Properties.Description = 'List of elements and their corresponding weight';
            obj.ListOfElements.Properties.VariableNames = {'Element', 'Weight'};
            obj.ListOfElements.Properties.VariableUnits = {'string', 'g'};
            obj.ListOfElements(1,:) = [];
            % add neg pole
            if isa(obj.MaterialNegPole, 'Element')
                NewListEntry = {obj.MaterialNegPole.Name, obj.WeightNegPole};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            elseif isa(obj.MaterialNegPole, 'Substance')
                for index = 1: length(obj.MaterialNegPole.Elements)
                    Element_temp = obj.MaterialNegPole.Elements(index);
                    Weight_temp = obj.WeightNegPole * obj.MaterialNegPole.ElementsWeightFractions(index);
                    NewListEntry = {Element_temp.Name, Weight_temp};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                end
            else
                error('Incorrect data type!')
            end
            % add pos pole
            if isa(obj.MaterialPosPole, 'Element')
                NewListEntry = {obj.MaterialPosPole.Name, obj.WeightPosPole};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            elseif isa(obj.MaterialPosPole, 'Substance')
                for index = 1: length(obj.MaterialPosPole.Elements)
                    Element_temp = obj.MaterialPosPole.Elements(index);
                    Weight_temp = obj.WeightPosPole * obj.MaterialPosPole.ElementsWeightFractions(index);

                    NewListEntry = {Element_temp.Name, Weight_temp};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                end
            else
                error('Incorrect data type!')
            end
            % add additional materials
            for index = 1:length(obj.AdditionalMaterials)
                if isa(obj.AdditionalMaterials{index}, 'Element')
                    NewListEntry = {obj.AdditionalMaterials{index}.Name, obj.AdditionalMaterialWeights(index)};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                elseif isa(obj.AdditionalMaterials{index}, 'Substance')
                    for index2 = 1: length(obj.AdditionalMaterials{index}.Elements)
                        Element_temp = obj.AdditionalMaterials{index}.Elements(index2);
                        Weight_temp = obj.AdditionalMaterialWeights(index) * obj.AdditionalMaterials{index}.ElementsWeightFractions(index2);
                        NewListEntry = {Element_temp.Name, Weight_temp};
                        obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                    end
                else
                    error('Incorrect data type!')
                end
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
        % create list of used substances
        function obj = CalcListOfSubstances(obj)
            obj.ListOfSubstances = table(0,0);
            obj.ListOfSubstances.Properties.Description = 'List of substances and their corresponding weight';
            obj.ListOfSubstances.Properties.VariableNames = {'Substance', 'Weight'};
            obj.ListOfSubstances.Properties.VariableUnits = {'string', 'g'};
            obj.ListOfSubstances(1,:) = [];
            % add neg pole
            NewListEntry = {obj.MaterialNegPole.Abbreviation, obj.WeightNegPole};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % add pos pole
            NewListEntry = {obj.MaterialPosPole.Abbreviation, obj.WeightPosPole};
            obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            % add additional materials
            for index = 1:length(obj.AdditionalMaterials)
                NewListEntry = {obj.AdditionalMaterials{index}.Abbreviation, obj.AdditionalMaterialWeights(index)};
                obj.ListOfSubstances = [obj.ListOfSubstances; NewListEntry];
            end
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
		% overload compare operator
		function logical = eq(A,B) 
           name_A           = GetProperty(A,'Name');
           name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
           logical          = strcmp(name_A,name_B);
        end
    end
end