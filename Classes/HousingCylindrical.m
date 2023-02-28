classdef HousingCylindrical < Housing

    properties

    end
    %% Methods
    methods
        % constructor
        function obj = HousingCylindrical(Name, Material, Dimensions, WallThickness, RestrictionsOfInnerDimensions, MaterialPosPole, SizeOfPosPole, MaterialNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights)
            if length(Dimensions)~=2
                error('Dimensions Vector must have a length of 2');
            end
            if length(RestrictionsOfInnerDimensions)~=4
                error('RestrictionsOfInnerDimensions Vector must have a length of 4');
            end
            obj.Name = Name;
            obj.Material = Material;
            obj.Dimensions = Dimensions; % [radius, height]
            obj.WallThickness = WallThickness;
            obj.RestrictionsOfInnerDimensions = RestrictionsOfInnerDimensions; % [delta radius outside, delta radius inside, bottom, top]
            obj.MaterialPosPole = MaterialPosPole;
            obj.PositionOfPosPole = NaN;
            obj.SizeOfPosPole = SizeOfPosPole; % [radius, height]
            obj.MaterialNegPole = MaterialNegPole;
            obj.PositionOfNegPole = NaN;
            obj.SizeOfNegPole = SizeOfNegPole; % [radius, height]
            obj.AdditionalMaterials = AdditionalMaterials;
            obj.AdditionalMaterialWeights = AdditionalMaterialWeights;
            obj.Type = 'cylindrical';
            obj = CalcVolumeAndDimensions(obj);
            obj = CalcWeight(obj);
            obj = CalcVerticesFaces(obj);
            obj = CalcListOfElementsInklHousing(obj);
            obj = CalcListOfSubstancesInklHousing(obj);
        end
    end
    %% Public Methods
    methods (Access = public)
        function obj = RefreshCalc(obj)
            obj = CalcVolumeAndDimensions(obj);
            obj = CalcWeight(obj);
            obj = CalcListOfElementsInklHousing(obj);
            obj = CalcListOfSubstancesInklHousing(obj);
        end
    end
    %% Private Methods
    methods (Access = private)
        % calculate volume and dimensions
        function obj = CalcVolumeAndDimensions(obj)
            obj.Volume = (pi * power(obj.Dimensions(1), 2) * obj.Dimensions(2) ...
                + pi * power(obj.SizeOfNegPole(1), 2) * obj.SizeOfNegPole(2) ...
                + pi * power(obj.SizeOfPosPole(1), 2) * obj.SizeOfPosPole(2)) / 1e3;
            r_lim_outside = obj.Dimensions(1) - 1*obj.WallThickness ...
                - obj.RestrictionsOfInnerDimensions(1);
            r_lim_inside = obj.RestrictionsOfInnerDimensions(2);
            h_lim = obj.Dimensions(2) - 2*obj.WallThickness ...
                - obj.RestrictionsOfInnerDimensions(3) ...
                - obj.RestrictionsOfInnerDimensions(4);
            obj.AvailableStackDimensions = [r_lim_outside, r_lim_inside, h_lim];
            obj.InnerVolume = (pi * power(obj.AvailableStackDimensions(1), 2) * obj.AvailableStackDimensions(3) ...
                - pi * power(obj.AvailableStackDimensions(2), 2) * obj.AvailableStackDimensions(3)) / 1e3;
        end
        % calculate weight
        function obj = CalcWeight(obj)
            WallVolume = (pi * power(obj.Dimensions(1), 2) * obj.Dimensions(2) ...
                - pi * power(obj.Dimensions(1) - obj.WallThickness, 2) * (obj.Dimensions(2) - 2*obj.WallThickness)) / 1e3;
            obj.WallWeight = WallVolume * obj.Material.Density;
            obj.WeightPosPole = pi*power(obj.SizeOfPosPole(1), 2)*obj.SizeOfPosPole(2) / 1e3 * obj.MaterialPosPole.Density;
            obj.WeightNegPole = pi*power(obj.SizeOfNegPole(1), 2)*obj.SizeOfNegPole(2) / 1e3 * obj.MaterialNegPole.Density;
            obj.Weight = obj.WallWeight + obj.WeightPosPole + obj.WeightNegPole + sum(obj.AdditionalMaterialWeights);
        end
        % calculate vertices and faces for 3D object
        function obj = CalcVerticesFaces(obj)
            obj.Verts = [];
            obj.Faces = [];
            GO_CellBody = GraphicalObject('CellHousing', [], []);
            GO_NegPole = GraphicalObject('NegPole', [], []);
            GO_PosPole = GraphicalObject('PosPole', [], []);
            Verts_shift_all = [obj.Dimensions(1), 0, obj.Dimensions(1)];
            [Verts_temp, Faces_temp] = FcnCylinderVerticesFaces(obj.Dimensions);
            Verts_shift = [0, obj.SizeOfNegPole(2), 0];
            Verts_temp = Verts_temp + Verts_shift + Verts_shift_all;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            % add neg pole
            [Verts_temp, Faces_temp] = FcnCylinderVerticesFaces(obj.SizeOfNegPole);
            Verts_shift = [0, 0, 0];
            Verts_temp = Verts_temp + Verts_shift + Verts_shift_all;
            GO_NegPole = AddToGraphicalObject(GO_NegPole, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            % add pos pole
            [Verts_temp, Faces_temp] = FcnCylinderVerticesFaces(obj.SizeOfPosPole);
            Verts_shift = [0, obj.SizeOfNegPole(2)+obj.Dimensions(2), 0];
            Verts_temp = Verts_temp + Verts_shift + Verts_shift_all;
            GO_PosPole = AddToGraphicalObject(GO_PosPole, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            obj.GraphicalObjects_Vec = [GO_CellBody, GO_NegPole, GO_PosPole];
        end
        % create list of used elements
        function obj = CalcListOfElementsInklHousing(obj)
            obj = CalcListOfElements(obj);
            % add housing
            if isa(obj.Material, 'Element')
                NewListEntry = {obj.Material.Name, obj.WallWeight};
                obj.ListOfElements = [obj.ListOfElements; NewListEntry];
            elseif isa(obj.Material, 'Substance')
                for index = 1: length(obj.Material.Elements)
                    Element_temp = obj.Material.Elements(index);
                    Weight_temp = obj.WallWeight * obj.Material.ElementsWeightFractions(index);
                    NewListEntry = {Element_temp.Name, Weight_temp};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                end
            else
                error('Incorrect data type!')
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
        function obj = CalcListOfSubstancesInklHousing(obj)
            obj = CalcListOfSubstances(obj);
            % add housing
            NewListEntry = {obj.Material.Abbreviation, obj.WallWeight};
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