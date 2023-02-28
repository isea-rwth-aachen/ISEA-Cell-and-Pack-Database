classdef GraphicalObject

    properties
        Name string
        Vertices double
        Faces double

        Faces_Triangular double

        Color double

        Width double
        Height double
        Thickness double

        Width_Center double
        Height_Center double
        Thickness_Center double

        Width_Min double
        Height_Min double
        Thickness_Min double

        AddInfo struct                          % any additional info that has to be added to material
        Source string                           % literature source, measurements, etc.
        Confidential string                     % 'Yes' or 'No'
    end
    %% Methods
    methods
        %constructor
        function obj = GraphicalObject(Name, Vertices, Faces)
            obj.Name = Name;
            obj.Vertices = Vertices;
            obj.Faces = Faces;

            obj = GetColor(obj);
            obj = CalcOuterDimensions(obj);
        end
        %get method
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
                warning([property,' is not a Property of class GraphicalObject return 0']);
                output = 0;
            end
        end
        %set method
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value;
            else
                error([property,' is not a Property of class GraphicalObject']);
            end
        end

        function obj = GetColor(obj)
            load('PlotsAndTools\ColorListForPlots\Color_List.mat', 'Colors_All');
            switch obj.Name
                case 'Anode'
                    obj.Color = Colors_All{1};
                case 'Cathode'
                    obj.Color = Colors_All{2};
                case 'Separator'
                    obj.Color = Colors_All{3};
                case 'Electrolyte'
                    obj.Color = Colors_All{4};
                case 'CellHousing'
                    obj.Color = Colors_All{5};
                case 'ActiveTransferMaterial'
                    obj.Color = Colors_All{6};
                case 'CCAnode'
                    obj.Color = Colors_All{7};
                case 'CCCathode'
                    obj.Color = Colors_All{8};
                case 'Cell'
                    obj.Color = Colors_All{9};
                case 'NegPole'
                    obj.Color = Colors_All{10};
                case 'PosPole'
                    obj.Color = Colors_All{11};
                otherwise
                    obj.Color = [255, 0, 0]/255;
            end
        end
        %calculation of the outer dimensions
        function obj = CalcOuterDimensions(obj)
            if ~isempty(obj.Vertices)
                obj.Width = max(obj.Vertices(:, 1)) - min(obj.Vertices(:, 1));
                obj.Height = max(obj.Vertices(:, 2)) - min(obj.Vertices(:, 2));
                obj.Thickness = max(obj.Vertices(:, 3)) - min(obj.Vertices(:, 3));

                obj.Width_Center = 0.5 * (max(obj.Vertices(:, 1)) + min(obj.Vertices(:, 1)));
                obj.Height_Center = 0.5 * (max(obj.Vertices(:, 2)) + min(obj.Vertices(:, 2)));
                obj.Thickness_Center = 0.5 * (max(obj.Vertices(:, 3)) + min(obj.Vertices(:, 3)));

                obj.Width_Min = min(obj.Vertices(:, 1));
                obj.Height_Min = min(obj.Vertices(:, 2));
                obj.Thickness_Min = min(obj.Vertices(:, 3));
            end
        end
        %method to add a graphical object
        function obj = AddToGraphicalObject(obj, Vertices_Additional, Faces_Additional)
            Faces_Additional = Faces_Additional + size(obj.Vertices, 1);
            obj.Vertices = [obj.Vertices; Vertices_Additional];
            obj.Faces = [obj.Faces; Faces_Additional];
            obj = CalcOuterDimensions(obj);
        end
        %method to rotate a graphical object
        function obj = RotateGraphicalObject(obj, Angle, Axis)
            if ~isempty(obj.Vertices)
                Radiant = Angle * pi / 180;
                switch Axis
                    case 'Width'
                        Matrix_rotation = [ 1, 0, 0; ...
                            0, cos(Radiant), -sin(Radiant); ...
                            0, sin(Radiant), cos(Radiant) ];
                    case 'Height'
                        Matrix_rotation = [ cos(Radiant), 0, sin(Radiant); ...
                            0, 1, 0; ...
                            -sin(Radiant), 0, cos(Radiant) ];
                    case 'Depth'
                        Matrix_rotation = [ cos(Radiant), -sin(Radiant), 0; ...
                            sin(Radiant), cos(Radiant), 0; ...
                            0, 0, 1 ];
                    otherwise
                        error('Incorrect Axis!');
                end
                obj. Vertices = Matrix_rotation * obj.Vertices';
                obj.Vertices = obj.Vertices';
                obj = CalcOuterDimensions(obj);
            end
        end
        %method to rotate a graphical object around the center
        function obj = RotateGraphicalObjectAroundCenter(obj, Angle, Axis)
            Center = [obj.Width_Center, obj.Height_Center, obj.Thickness_Center];
            obj.Vertices = obj.Vertices - Center;
            obj = RotateGraphicalObject(obj, Angle, Axis);
            obj.Vertices = obj.Vertices + Center;
        end
        %calculate the triangular mesh
        function obj = CalcTriangularMesh(obj)
            obj.Faces_Triangular = [];
            for index = 1:length(obj.Faces)
                Face = obj.Faces(index,:);
                obj.Faces_Triangular = [obj.Faces_Triangular; Face([1, 2, 3]); Face([1, 3, 4])];
            end
        end
    end
end