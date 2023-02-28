classdef HousingPouch < Housing

    properties
        FoilMaterials cell          % Materials and Substances the foil housing is made of
        FoilThicknesses double      % in mm
        FoilWeight double           % in g
        FoilMaterialWeights double  % in g
        FoilArea double             % in mm²
    end
    %% Methods
    methods
        % constructor
        function obj = HousingPouch(Name, FoilMaterials, FoilThicknesses, Dimensions, RestrictionsOfInnerDimensions, MaterialPosPole, PositionOfPosPole, SizeOfPosPole, MaterialNegPole, PositionOfNegPole, SizeOfNegPole, AdditionalMaterials, AdditionalMaterialWeights)
            if length(Dimensions)~=3
                error('Dimensions Vector must have a length of 3');
            end
            if length(RestrictionsOfInnerDimensions)~=6
                error('RestrictionsOfInnerDimensions Vector must have a length of 6');
            end
            obj.Name = Name;
            obj.FoilMaterials = FoilMaterials;
            obj.FoilThicknesses = FoilThicknesses;
            obj.Dimensions = Dimensions; % width, height, thickness]
            obj.WallThickness = sum(obj.FoilThicknesses);
            obj.RestrictionsOfInnerDimensions = RestrictionsOfInnerDimensions; % [left, right, bottom, top, front, back]
            obj.MaterialPosPole = MaterialPosPole;
            obj.PositionOfPosPole = PositionOfPosPole;
            obj.SizeOfPosPole = SizeOfPosPole;
            obj.MaterialNegPole = MaterialNegPole;
            obj.PositionOfNegPole = PositionOfNegPole;
            obj.SizeOfNegPole = SizeOfNegPole;
            obj.AdditionalMaterials = AdditionalMaterials;
            obj.AdditionalMaterialWeights = AdditionalMaterialWeights;
            obj.Type = 'pouch';
            obj = CalcVolumeAndDimensions(obj);
            obj = CalcWeight(obj);
            obj = CalcVerticesFaces(obj);
            obj = CalcListOfElementsInklHousing(obj);
            obj = CalcListOfSubstancesInklHousing(obj);
        end
    end
    %% Public Methods
    methods (Access = public)
        % refresh calculation if paramters changed
        function obj = RefreshCalc(obj)
            obj = CalcVolumeAndDimensions(obj);
            obj = CalcWeight(obj);
            obj = CalcListOfElementsInklHousing(obj);
            obj = CalcListOfSubstancesInklHousing(obj);
        end
    end
    %% Private Methods
    methods (Access = private)
        %calculate volume and dimensions
        function obj = CalcVolumeAndDimensions(obj)
            obj.Volume = (prod(obj.Dimensions) + prod(obj.SizeOfNegPole) + prod(obj.SizeOfPosPole)) / 1e3;
            x_lim = obj.Dimensions(1) - 2*obj.WallThickness ...
                - obj.RestrictionsOfInnerDimensions(1) ...
                - obj.RestrictionsOfInnerDimensions(2);
            y_lim = obj.Dimensions(2) - 2*obj.WallThickness ...
                - obj.RestrictionsOfInnerDimensions(3) ...
                - obj.RestrictionsOfInnerDimensions(4);
            z_lim = obj.Dimensions(3) - 2*obj.WallThickness ...
                - obj.RestrictionsOfInnerDimensions(5) ...
                - obj.RestrictionsOfInnerDimensions(6);
            obj.AvailableStackDimensions = [x_lim, y_lim, z_lim];
            obj.InnerVolume = x_lim * y_lim * z_lim / 1e3;
        end
        % calculate weight
        function obj = CalcWeight(obj)
            obj.FoilArea = 2 * obj.Dimensions(1) * obj.Dimensions(2) ...
                + 2 * obj.AvailableStackDimensions(1) * obj.Dimensions(3) ...
                + 2 * obj.AvailableStackDimensions(2)* obj.Dimensions(3) / 1e3;
            obj.FoilWeight = 0;
            for index=1:length(obj.FoilMaterials)
                obj.FoilMaterialWeights(index) = obj.FoilArea * obj.FoilThicknesses(index) /1e3 * obj.FoilMaterials{index}.Density;
                obj.FoilWeight = obj.FoilWeight + obj.FoilMaterialWeights(index);
            end
            if(~isempty(obj.SizeOfPosPole) || ~isempty(obj.SizeOfNegPole))
                VolumePosPole = obj.SizeOfPosPole(1)*obj.SizeOfPosPole(2)*obj.SizeOfPosPole(3);
                VolumeNegPole = obj.SizeOfNegPole(1)*obj.SizeOfNegPole(2)*obj.SizeOfNegPole(3);
            else
                VolumePosPole = 0;
                VolumeNegPole = 0;
            end
            obj.WeightPosPole = VolumePosPole/1e3 * obj.MaterialPosPole.Density;
            obj.WeightNegPole = VolumeNegPole/1e3 * obj.MaterialNegPole.Density;
            obj.Weight = obj.FoilWeight + obj.WeightPosPole + obj.WeightNegPole + sum(obj.AdditionalMaterialWeights);
        end
        % calculate vertices and faces for 3D object
        function obj = CalcVerticesFaces(obj)
            obj.Verts = [];
            obj.Faces = [];
            GO_CellBody = GraphicalObject('CellHousing', [], []);
            GO_NegPole = GraphicalObject('NegPole', [], []);
            GO_PosPole = GraphicalObject('PosPole', [], []);
            % add housing
            x_dim = obj.Dimensions(1) ...
                - obj.RestrictionsOfInnerDimensions(1) ...
                - obj.RestrictionsOfInnerDimensions(2);
            y_dim = obj.Dimensions(2) ...
                - obj.RestrictionsOfInnerDimensions(3) ...
                - obj.RestrictionsOfInnerDimensions(4);
            z_dim = obj.Dimensions(3) ...
                - obj.RestrictionsOfInnerDimensions(5) ...
                - obj.RestrictionsOfInnerDimensions(6);
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([x_dim, y_dim, z_dim]);
            Verts_shift = [obj.RestrictionsOfInnerDimensions(1), obj.RestrictionsOfInnerDimensions(3), obj.RestrictionsOfInnerDimensions(5)];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([obj.Dimensions(1), obj.RestrictionsOfInnerDimensions(3), 2*obj.WallThickness]);
            Verts_shift = [0, 0, obj.PositionOfNegPole(2)-obj.WallThickness];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([obj.Dimensions(1), obj.RestrictionsOfInnerDimensions(4), 2*obj.WallThickness]);
            Verts_shift = [0, obj.Dimensions(2)-obj.RestrictionsOfInnerDimensions(4), obj.PositionOfNegPole(2)-obj.WallThickness];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([obj.RestrictionsOfInnerDimensions(1), obj.Dimensions(2), 2*obj.WallThickness]);
            Verts_shift = [0, 0, obj.PositionOfNegPole(2)-obj.WallThickness];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([obj.RestrictionsOfInnerDimensions(2), obj.Dimensions(2), 2*obj.WallThickness]);
            Verts_shift = [obj.Dimensions(1)-obj.RestrictionsOfInnerDimensions(2), 0, obj.PositionOfNegPole(2)-obj.WallThickness];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            % add neg pole
            x_dim = obj.SizeOfNegPole(1) + 2*obj.WallThickness;
            y_dim = obj.RestrictionsOfInnerDimensions(4);
            z_dim = obj.SizeOfNegPole(3) + 2*obj.WallThickness;
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([x_dim, y_dim, z_dim]);
            Verts_shift = [obj.PositionOfNegPole(1) - obj.SizeOfNegPole(1)/2 - obj.WallThickness, ...
                obj.Dimensions(2)-obj.RestrictionsOfInnerDimensions(4), ...
                obj.PositionOfNegPole(2) - obj.SizeOfNegPole(3)/2 - obj.WallThickness];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces(obj.SizeOfNegPole);
            Verts_shift = [obj.PositionOfNegPole(1) - obj.SizeOfNegPole(1)/2, ...
                obj.Dimensions(2), ...
                obj.PositionOfNegPole(2) - obj.SizeOfNegPole(3)/2];
            Verts_temp = Verts_temp + Verts_shift;
            GO_NegPole = AddToGraphicalObject(GO_NegPole, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            % add pos pole
            x_dim = obj.SizeOfPosPole(1) + 2*obj.WallThickness;
            y_dim = obj.RestrictionsOfInnerDimensions(4);
            z_dim = obj.SizeOfPosPole(3) + 2*obj.WallThickness;
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces([x_dim, y_dim, z_dim]);
            Verts_shift = [obj.PositionOfPosPole(1) - obj.SizeOfPosPole(1)/2 - obj.WallThickness, ...
                obj.Dimensions(2)-obj.RestrictionsOfInnerDimensions(4), ...
                obj.PositionOfPosPole(2) - obj.SizeOfPosPole(3)/2 - obj.WallThickness];
            Verts_temp = Verts_temp + Verts_shift;
            GO_CellBody = AddToGraphicalObject(GO_CellBody, Verts_temp, Faces_temp);
            Faces_temp = Faces_temp + size(obj.Verts, 1);
            obj.Verts = [obj.Verts; Verts_temp];
            obj.Faces = [obj.Faces; Faces_temp];
            [Verts_temp, Faces_temp] = FcnCuboidVerticesFaces(obj.SizeOfPosPole);
            Verts_shift = [obj.PositionOfPosPole(1) - obj.SizeOfPosPole(1)/2, ...
                obj.Dimensions(2), ...
                obj.PositionOfPosPole(2) - obj.SizeOfPosPole(3)/2];
            Verts_temp = Verts_temp + Verts_shift;
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
            for index = 1:length(obj.FoilMaterials)
                if isa(obj.FoilMaterials{index}, 'Element')
                    NewListEntry = {obj.FoilMaterials{index}.Name, obj.FoilMaterialWeights(index)};
                    obj.ListOfElements = [obj.ListOfElements; NewListEntry];
                elseif isa(obj.FoilMaterials{index}, 'Substance')
                    for index2 = 1: length(obj.FoilMaterials{index}.Elements)
                        Element_temp = obj.FoilMaterials{index}.Elements(index2);
                        Weight_temp = obj.FoilMaterialWeights(index) * obj.FoilMaterials{index}.ElementsWeightFractions(index2);

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
        function obj = CalcListOfSubstancesInklHousing(obj)
            obj = CalcListOfSubstances(obj);
            % add housing
            for index = 1:length(obj.FoilMaterials)
                NewListEntry = {obj.FoilMaterials{index}.Abbreviation, obj.FoilMaterialWeights(index)};
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
    end
end