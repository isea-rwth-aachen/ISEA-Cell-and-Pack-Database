function fcn_plot_Housings(app,housings,axes_name1,axes_name2,cell)
%% function for creating the ICM plot of the selected electrolyte and the comparison between more then one electrolyte at 25°C
n_data              = numel(housings);
if ~isa(housings,'cell')
    housings                                  = arrayfun(@(x) {housings(x)}, (1:numel(housings))); 
end
if n_data == 0 || ~any(arrayfun(@(x) isa(housings{x},'Housing') || isa(housings{x},'HousingPouch') || isa(housings{x},'HousingCylindrical') || isa(housings{x},'HousingGeneric') || isa(housings{x},'HousingPrismatic'),(1:n_data)))
    return;
end
if nargin == 5 && isa(cell, 'Cell')
    subtitel        = arrayfun(@(x) convertStringsToChars(GetProperty(cell(x),'Name')),(1:numel(cell)), 'UniformOutput', false);
end
%% get plot of the single housing
if nargin < 5 && ~isempty(axes_name1) || (nargin == 5 && ~isa(cell, 'Cell') && ~isempty(axes_name1))
    cla(app.(axes_name1),'reset');
    fcn_plot_each_Housing_object(app,axes_name1,housings{1},0,'outer',[0.4660 0.6740 0.1880]);
    fcn_plot_each_Housing_object(app,axes_name1,housings{1},0,'plusPole',[0.6350 0.0780 0.1840]);
    fcn_plot_each_Housing_object(app,axes_name1,housings{1},0,'negativePole',[0 0 0]);
    fcn_plot_each_Housing_object(app,axes_name1,housings{1},0,'inner',[0.9290 0.6940 0.1250]);
    axis(app.(axes_name1), 'equal');
    name_cell                                       = convertStringsToChars(GetProperty(housings{1},'Name'));
    app.(axes_name1).Title.Interpreter              = 'none';
    app.(axes_name1).Title.String                   = name_cell;
    app.(axes_name1).XLabel.String                  = 'mm';
    app.(axes_name1).XLabel.String                  = 'mm';
    app.(axes_name1).XLabel.String                  = 'mm';
    app.(axes_name1).XLabel.FontSize                = 14;
    app.(axes_name1).XLabel.FontSize                = 14;
    app.(axes_name1).XLabel.FontSize                = 14;
    view(app.(axes_name1),-45,30);
elseif nargin == 5 && isa(cell, 'Cell')
    figure_housing      = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', [strjoin(subtitel,' and ') ' 3D represenation']);
    set(figure_housing, 'CreateFcn','set(gcbf,''Visible'',''on'')');
    set(0, 'CurrentFigure', figure_housing);
    axes_figure         = axes('Parent', figure_housing);
    fcn_plot_each_Housing_object([],axes_figure,housings{1},0,'outer',[0.4660 0.6740 0.1880]);
    fcn_plot_each_Housing_object([],axes_figure,housings{1},0,'plusPole',[0.6350 0.0780 0.1840]);
    fcn_plot_each_Housing_object([],axes_figure,housings{1},0,'negativePole',[0 0 0]);
    fcn_plot_each_Housing_object([],axes_figure,housings{1},0,'inner',[0.9290 0.6940 0.1250]);
    axis(axes_figure, 'equal');
    name_cell                                       = convertStringsToChars(GetProperty(housings{1},'Name'));
    axes_figure.Title.Interpreter                   = 'none';
    axes_figure.Title.String                        = name_cell;
    view(axes_figure,-45,30);
    set(axes_figure, 'FontSize', 14);
    figure_housing.CurrentAxes.YLabel.String        = 'Y [mm]';
    figure_housing.CurrentAxes.YLabel.FontSize      = 14;
    figure_housing.CurrentAxes.XLabel.String        = 'X [mm]';
    figure_housing.CurrentAxes.XLabel.FontSize      = 14;
    figure_housing.CurrentAxes.ZLabel.String        = 'Z [mm]';
    figure_housing.CurrentAxes.ZLabel.FontSize      = 14;
    figure_housing.CurrentAxes.Title.String         = ['3D representation of the cell(s) ' strjoin(subtitel, ' and ')];
    figure_housing.CurrentAxes.Title.FontSize       = 16;
end
%% Return if only one housing is to be displayed.
if (n_data == 1 || nargin < 4) && (nargin == 5 && isa(cell, 'Cell'))
    set(figure_housing, 'Visible','on');
    return;
elseif n_data == 1 || nargin < 4
    return;
end
%% get plot of the compared housings
if nargin < 5
    offset_x = fcn_calc_offset(housings{1});
    cla(app.(axes_name2),'reset');
    fcn_plot_each_Housing_object(app,axes_name2,housings{1},0,'outer',[0.4660 0.6740 0.1880]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{1},0,'plusPole',[0.6350 0.0780 0.1840]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{1},0,'negativePole',[0 0 0]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{1},0,'inner',[0.9290 0.6940 0.1250]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{2},offset_x,'outer',[0.3010 0.7450 0.9330]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{2},offset_x,'plusPole',[0.6350 0.0780 0.1840]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{2},offset_x,'negativePole',[0 0 0]);
    fcn_plot_each_Housing_object(app,axes_name2,housings{2},offset_x,'inner', [204 	153 	0] ./ 255);
    axis(app.(axes_name2), 'equal');
    view(app.(axes_name2),-45,30);  
    name_cells                                       = join([convertStringsToChars(GetProperty(housings{1},'Name')) ' and ' convertStringsToChars(GetProperty(housings{2},'Name'))]);
    app.(axes_name2).Title.Interpreter      = 'none';
    app.(axes_name2).Title.String           = name_cells;
elseif nargin == 5 && isa(cell, 'Cell')
    hold(axes_figure,'on');
    offset_x        = 0;
    color           = fcn_get_plot_color(n_data - 1);
    for i = 2:n_data
        offset_x = fcn_calc_offset(housings{i - 1}) + offset_x;
        fcn_plot_each_Housing_object([],axes_figure,housings{i},offset_x,'outer',color(i - 1,:));
        fcn_plot_each_Housing_object([],axes_figure,housings{i},offset_x,'plusPole',[0.6350 0.0780 0.1840]);
        fcn_plot_each_Housing_object([],axes_figure,housings{i},offset_x,'negativePole',[0 0 0]);
        fcn_plot_each_Housing_object([],axes_figure,housings{i},offset_x,'inner', [204 	153 	0] ./ 255);
    end
    axis(axes_figure, 'equal');
    view(axes_figure,-45,30);  
end

if nargin == 5 && isa(cell, 'Cell')
    set(figure_housing, 'Visible','on');
end
end

function fcn_plot_each_Housing_object(app,axes_name,housing,offset_x,object_type,color)
type            = GetProperty(housing, 'Type');
if isempty(app)
    axes_operate    = 'axes_name';
else
    axes_operate    = ['app.' axes_name];
end
hold(eval(axes_operate), 'on');
switch type
    case 'cylindrical'
        switch object_type
            case 'outer'
                dimensions          = GetProperty(housing,'Dimensions');
                radius              = dimensions(1);
                height              = dimensions(2);
                theta               = 0 : pi / 100 : 2*pi;
                a                   = radius * cos(theta);
                b                   = radius * sin(theta);
                surf(eval(axes_operate),[a; a]+offset_x,[b; b],[ones(1,size(theta,2)); zeros(1, size(theta,2))] * height,'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.6);
                patch(eval(axes_operate),a+offset_x, b, ones(1,size(theta,2))*height,[0 0 0], 'FaceAlpha',0.7);
                patch(eval(axes_operate),a+offset_x, b, zeros(1,size(theta,2)),[0 0 0], 'FaceAlpha',0.7);
            case 'inner'
                dimensions          = GetProperty(housing,'Dimensions');
                wall_thickness      = GetProperty(housing, 'WallThickness');
                radius              = dimensions(1);
                height              = dimensions(2);
                restrictions        = GetProperty(housing, 'RestrictionsOfInnerDimensions');
                delta_radius_out    = restrictions(1);
                delta_radius_in     = restrictions(2);
                res_bottom          = restrictions(3);
                res_top             = restrictions(4);
                radius_outer        = radius-delta_radius_out - wall_thickness;
                height              = height-res_bottom-res_top;
                theta               = 0 : pi / 100 : 2*pi;
                a_outer             = radius_outer * cos(theta);
                b_outer             = radius_outer * sin(theta);
                a_inner             = delta_radius_in * cos(theta);
                b_inner             = delta_radius_in * sin(theta);
                surf(eval(axes_operate),[a_outer; a_outer]+offset_x,[b_outer; b_outer],[ones(1,size(theta,2)) * height; zeros(1, size(theta,2)) + res_bottom],'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.7, 'LineStyle', '--');
                surf(eval(axes_operate),[a_inner; a_inner]+offset_x,[b_inner; b_inner],[ones(1,size(theta,2)) * height; zeros(1, size(theta,2)) + res_bottom],'EdgeColor', 'none', 'FaceColor', [0.4940 0.1840 0.5560], 'FaceAlpha', 0.7, 'LineStyle', '--');
                patch(eval(axes_operate),a_outer+offset_x, b_outer, ones(1,size(theta,2))*height,[0.502 0.502 0.502], 'FaceAlpha',0.3, 'LineWidth', 1.5, 'LineStyle', '--');
                patch(eval(axes_operate),a_outer+offset_x, b_outer, zeros(1,size(theta,2))+res_bottom,[0.502 0.502 0.502], 'FaceAlpha',0.3, 'LineWidth', 1.5, 'LineStyle', '--');
            case 'plusPole'
                dimensions          = GetProperty(housing,'SizeOfPosPole');
                radius              = dimensions(1);
                height              = dimensions(2);
                offset_z            = GetProperty(housing,'Dimensions');
                offset_z            = offset_z(2);
                theta               = 0 : 2 *pi / 100 : 2*pi;
                a                   = radius * cos(theta);
                b                   = dimensions(1) * sin(theta);
                surf(eval(axes_operate),[a; a]+offset_x,[b; b],[ones(1,size(theta,2)) * height + offset_z; zeros(1, size(theta,2)) + offset_z],'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.8);
                patch(eval(axes_operate),a+offset_x, b, (ones(1,size(theta,2))+offset_z) + height,color, 'FaceAlpha',1);
            case 'negativePole'
                dimensions          = GetProperty(housing,'SizeOfNegPole');
                radius              = dimensions(1);
                height              = dimensions(2);
                theta               = 0 : pi / 100 : 2*pi;
                a                   = radius * cos(theta);
                b                   = radius * sin(theta);
                surf(eval(axes_operate),[a; a]+offset_x,[b; b],[zeros(1,size(theta,2)) - height; zeros(1, size(theta,2))],'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.8);
                patch(eval(axes_operate),a+offset_x, b, ones(1,size(theta,2)) - height,	color, 'FaceAlpha',1);
        end
    case {'pouch' 'prismatic'}
        switch object_type
            case 'outer'
                dimensions          = GetProperty(housing, 'Dimensions');
                width               = dimensions(1);
                height              = dimensions(2);
                thickness           = dimensions(3);
                Vertices            = [0 0 0; 0 0 thickness; 0 height thickness;0 height 0; width height 0; width height thickness; width 0 thickness; width 0 0] + [offset_x 0 0];
                Faces               = [1 2 3 4; 3 4 5 6; 5 6 7 8; 2 7 8 1; 1 4 5 8; 3 6 7 2];
                patch(eval(axes_operate),'Faces', Faces, 'Vertices', Vertices, 'FaceColor',	color, 'FaceAlpha',0.7);
            case 'inner'
                dimensions          = GetProperty(housing, 'Dimensions');
                width               = dimensions(1);
                height              = dimensions(2);
                thickness           = dimensions(3);
                restriction         = GetProperty(housing, 'RestrictionsOfInnerDimensions');
                res_left            = restriction(1);
                res_right           = restriction(2);
                res_bottom          = restriction(3);
                res_top             = restriction(4);
                res_front           = restriction(5);
                res_back            = restriction(6);
                Vertices            = [0+res_left 0+res_bottom 0+res_front; 0+res_left 0+res_bottom thickness-res_back; 0+res_left height-res_top thickness-res_back;0+res_left height-res_top 0+res_front;...
                                        width-res_right height-res_top 0+res_front; width-res_right height-res_top thickness-res_back; width-res_right 0+res_bottom thickness-res_back; width-res_right 0+res_bottom 0+res_front] + [offset_x 0 0];
                Faces               = [1 2 3 4; 3 4 5 6; 5 6 7 8; 2 7 8 1; 1 4 5 8; 3 6 7 2];
                patch(eval(axes_operate),'Faces', Faces, 'Vertices', Vertices, 'FaceColor',	color, 'FaceAlpha',0.3, 'LineStyle', '--');
            case 'plusPole'
                position_pos_pole   = GetProperty(housing,'PositionOfPosPole');
                size_pos_pole       = GetProperty(housing,'SizeOfPosPole');
                position_x          = position_pos_pole(1);
                position_y          = housing.Dimensions(2);
                position_z          = position_pos_pole(2);
                size_x              = size_pos_pole(1);
                size_y              = size_pos_pole(2);
                size_z              = size_pos_pole(3);
                Vertices            = [-size_x/2 0 size_z/2; -size_x/2 size_y size_z/2; size_x/2 size_y size_z/2; size_x/2 0 size_z/2; size_x/2 0 -size_z/2; -size_x/2 0 -size_z/2; -size_x/2 size_y -size_z/2;...
                                        size_x/2 size_y -size_z/2] + [position_x position_y position_z] + [offset_x 0 0];
                Faces               = [1 2 3 4; 1 4 5 6; 5 6 7 8; 1 6 7 2; 4 5 8 3;2 7 8 3];
                patch(eval(axes_operate), 'Faces', Faces,'Vertices', Vertices,'FaceColor',[0.6350 0.0780 0.1840],'FaceAlpha',1);
            case 'negativePole'
                position_neg_pole   = GetProperty(housing,'PositionOfNegPole');
                size_neg_pole       = GetProperty(housing,'SizeOfNegPole');
                position_x          = position_neg_pole(1);
                position_y          = housing.Dimensions(2);
                position_z          = position_neg_pole(2);
                size_x              = size_neg_pole(1);
                size_y              = size_neg_pole(2);
                size_z              = size_neg_pole(3);
                Vertices            = [-size_x/2 0 size_z/2; -size_x/2 size_y size_z/2; size_x/2 size_y size_z/2; size_x/2 0 size_z/2; size_x/2 0 -size_z/2; -size_x/2 0 -size_z/2; -size_x/2 size_y -size_z/2;...
                                        size_x/2 size_y -size_z/2] + [position_x position_y position_z] + [offset_x 0 0];
                Faces               = [1 2 3 4; 1 4 5 6; 5 6 7 8; 1 6 7 2; 4 5 8 3; 2 7 8 3];
                patch(eval(axes_operate), 'Faces', Faces,'Vertices', Vertices,'FaceColor',[0 0.4470 0.7410],'FaceAlpha',1);
        end
end
hold(eval(axes_operate), 'off');
end

function offset_x = fcn_calc_offset(last_housing)

switch GetProperty(last_housing,'Type')
    case 'cylindrical'
        radius          = GetProperty(last_housing, 'Dimensions');
        radius          = radius(1);
        offset_x        = 2 * radius + 10;
    case {'pouch' 'prismatic'}
        width           = GetProperty(last_housing, 'Dimensions');
        width           = width(1);
        offset_x        = width + 10;
end
end