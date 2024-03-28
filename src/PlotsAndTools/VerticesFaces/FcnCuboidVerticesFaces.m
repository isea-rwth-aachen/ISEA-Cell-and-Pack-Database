function [ verts, faces ] = FcnCuboidVerticesFaces(dimensions)
% origin (0,0,0)
width = dimensions(1);
height = dimensions(2);
thickness = dimensions(3);

verts=[	0, 0, 0; ...                     %Punkt A (vgl Abb 1.1)
    width, 0, 0; ...                % B
    width, height, 0; ...          % C
    0, height, 0; ...               % D
    0, 0, thickness; ...            % E
    width, 0, thickness; ...       % F
    width, height, thickness; ... % G
    0, height, thickness; ...      % H
    ];

faces=[	1, 2, 3, 4; ... %Front
    1, 2, 6, 5; ... %Bottom
    1, 4, 8, 5; ... %Lrft
    7, 6, 2, 3; ... %Right
    7, 3, 4, 8; ... %Lid
    7, 6, 5, 8; ... %Back
    ];

end