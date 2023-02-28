function [ verts, faces ] = FcnCylinderVerticesFaces(dimensions)

Radius = dimensions(1);
Height = dimensions(2);
NrOfPointsCircle = 30;
verts = [0, 0, 0; 0, Height, 0];
faces = [];
for index = 1: NrOfPointsCircle
    Width = Radius * sin(index / NrOfPointsCircle * 2*pi);
    Depth = Radius * cos(index / NrOfPointsCircle * 2*pi);
    verts = [verts; Width, 0, Depth];
    verts = [verts; Width, Height, Depth];
    NrOfVerts = length(verts(:,1));
    if index >1
        faces = [faces; NrOfVerts-1, NrOfVerts-3, 1, 1];
        faces = [faces; NrOfVerts, NrOfVerts-2, 2, 2];
        faces = [faces; NrOfVerts, NrOfVerts-2, NrOfVerts-3, NrOfVerts-1];
    end
end
NrOfVerts = length(verts(:,1));
faces = [faces; 3, NrOfVerts-1, 1, 1];
faces = [faces; 4, NrOfVerts, 2, 2];
faces = [faces; 4, NrOfVerts, NrOfVerts-1, 3];
end