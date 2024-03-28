function fcn_generate_spider_plot(app,P, P_labels, axes_interval, axes_precision,axes_name,global_max,global_min, varargin)
% Create a spider web or radar plot with an axes specified for each column
%%% Point Properties %%%
% Number of points
[row_of_points, num_of_points] = size(P);
%%% Error Check %%%
% Check if axes properties are an integer
if floor(axes_interval) ~= axes_interval || floor(axes_precision) ~= axes_precision
    error('Error: Please enter in an integer for the axes properties.');
end
% Check if the labels are the same number as the number of points
if length(P_labels) ~= num_of_points
    error('Error: Please make sure the number of labels is the same as the number of points.');
end
% Pre-allocation
max_values = zeros(1, num_of_points);
min_values = zeros(1, num_of_points);
axis_increment = zeros(1, num_of_points);
% Normalized axis increment
normalized_axis_increment = 1/axes_interval;
% get axes to operate
if isempty(app)
    axes_operate        = 'axes_name';
else
    axes_operate        = ['app.' axes_name];
end
% Iterate through number of points
for ii = 1:num_of_points
    % Group of points
    group_points = P(:, ii);
    % Max and min value of each group
    if ~isempty(global_max) && numel(global_max) == num_of_points
        max_values(ii)      = global_max(ii);
    else
        max_values(ii) = max(group_points);
    end
    if ~isempty(global_min) && numel(global_min) == num_of_points
        min_values(ii)      = global_min(ii);
    else
        min_values(ii) = min(group_points);
    end
    range = max_values(ii) - min_values(ii);
    % Axis increment
    axis_increment(ii) = range/axes_interval;
    % Normalize points to range from [0, 1]
    P(:, ii) = (P(:, ii)-min(group_points))/range;
    % Shift points by one axis increment
    P(:, ii) = P(:, ii) + normalized_axis_increment;
end

%%% Polar Axes %%%
% Polar increments
polar_increments = 2*pi/num_of_points;
% Normalized  max limit of axes
axes_limit = 1;
% Shift axes limit by one axis increment
axes_limit = axes_limit + normalized_axis_increment;
% Polar points
radius = [0; axes_limit];
theta = 0:polar_increments:2*pi;
% Convert polar to cartesian coordinates
[x_axes, y_axes] = pol2cart(theta, radius);
% Plot polar axes
grey = [1, 1, 1] * 0.5;
h = line(eval(axes_operate),x_axes, y_axes,...
    'LineWidth', 1,...
    'Color', grey);

% Iterate through all the line handles
for ii = 1:length(h)
    % Remove polar axes from legend
    h(ii).Annotation.LegendInformation.IconDisplayStyle = 'off';
end

%%% Polar Isocurves %%%
% Shifted axes interval
shifted_axes_interval = axes_interval+1;
% Incremental radius
radius = (0:axes_limit/shifted_axes_interval:axes_limit)';
% Convert polar to cartesian coordinates
[x_isocurves, y_isocurves] = pol2cart(theta, radius);
%flip cost axes
if ii == 3
    x_isocurves(:, ii) = flip(x_isocurves(:, ii));
    y_isocurves(:, ii) = flip(y_isocurves(:, ii));
end
% Plot polar isocurves
hold(eval(axes_operate), 'on');
h = plot(eval(axes_operate),x_isocurves', y_isocurves',...
    'LineWidth', 1.5,...
    'Color', grey);
% Iterate through all the plot handles
for ii = 1:length(h)
    % Remove polar isocurves from legend
    h(ii).Annotation.LegendInformation.IconDisplayStyle = 'off';
end
%%% Figure Properties %%%
colors      = fcn_get_plot_color(row_of_points);
% Repeat colors is necessary
repeat_colors = fix(row_of_points/size(colors, 1))+1;
colors = repmat(colors, repeat_colors, 1);
%%% Data Points %%%
% Iterate through all the rows
for ii = 1:row_of_points
    % Convert polar to cartesian coordinates
    [x_points, y_points] = pol2cart(theta(1:end-1), P(ii, :));
    % Make points circular
    x_circular = [x_points, x_points(1)];
    y_circular = [y_points, y_points(1)];
    % Plot data points
    plot(eval(axes_operate),x_circular, y_circular,...
        'Color', colors(ii, :),...
        'MarkerFaceColor', colors(ii, :),...
        varargin{:});
end
%%% Axis Properties %%%
% Figure background
set(eval(axes_operate),'Color','white');
% Iterate through all the number of points
for hh = 1:num_of_points
    % Shifted min value
    shifted_min_value = min_values(hh) - axis_increment(hh);
    % Axis label for each row
    row_axis_labels = round((shifted_min_value:axis_increment(hh):max_values(hh))');
    if isempty(row_axis_labels)
        row_axis_labels     = (1:length(radius));
    end
    % Iterate through all the isocurve radius
    for ii = 2:length(radius)
        % Display axis text for each isocurve
        text(eval(axes_operate),x_isocurves(ii, hh) + 0.07, y_isocurves(ii, hh) + 0.04, sprintf(sprintf('%%.%if', axes_precision), row_axis_labels(ii)),...
            'Units', 'Data',...
            'Color', 'k',...
            'FontSize', 13,...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'middle');
    end
end
% Label points
x_label = x_isocurves(end, :);
y_label = y_isocurves(end, :);
% Shift axis label
shift_pos = 0.07;
% Iterate through each label
for ii = 1:num_of_points
    % Angle of point in radians
    theta_point = theta(ii);
    % Find out which quadrant the point is in
    if theta_point == 0
        quadrant = 0;
    elseif theta_point == pi/2
        quadrant = 1.5;
    elseif theta_point == pi
        quadrant = 2.5;
    elseif theta_point == 3*pi/2
        quadrant = 3.5;
    elseif theta_point == 2*pi
        quadrant = 0;
    elseif theta_point > 0 && theta_point < pi/2
        quadrant = 1;
    elseif theta_point > pi/2 && theta_point < pi
        quadrant = 2;
    elseif theta_point > pi && theta_point < 3*pi/2
        quadrant = 3;
    elseif theta_point > 3*pi/2 && theta_point < 2*pi
        quadrant = 4;
    end
    % Adjust text alignment information depending on quadrant
    switch quadrant
        case 0
            horz_align = 'left';
            vert_align = 'middle';
            x_pos = shift_pos;
            y_pos = -shift_pos;
        case 1
            horz_align = 'left';
            vert_align = 'bottom';
            x_pos = shift_pos;
            y_pos = shift_pos + 0.05;
        case 1.5
            horz_align = 'center';
            vert_align = 'bottom';
            x_pos = 0;
            y_pos = shift_pos;
        case 2
            horz_align = 'right';
            vert_align = 'bottom';
            x_pos = -shift_pos;
            y_pos = shift_pos;
        case 2.5
            horz_align = 'right';
            vert_align = 'middle';
            x_pos = -shift_pos;
            y_pos = 0;
        case 3
            horz_align = 'right';
            vert_align = 'top';
            x_pos = -shift_pos;
            y_pos = -shift_pos;
        case 3.5
            horz_align = 'center';
            vert_align = 'top';
            x_pos = 0;
            y_pos = -shift_pos;
        case 4
            horz_align = 'left';
            vert_align = 'top';
            x_pos = shift_pos;
            y_pos = -shift_pos;
    end
    % Display text label
    text(eval(axes_operate),x_label(ii)+x_pos, y_label(ii)+y_pos, P_labels{ii},...
        'Units', 'Data',...
        'HorizontalAlignment', horz_align,...
        'VerticalAlignment', vert_align,...
        'EdgeColor', 'k',...
        'BackgroundColor', 'w');
end
% Axis limits
axis(eval(axes_operate), 'square');
axis(eval(axes_operate),[-axes_limit, axes_limit, -axes_limit, axes_limit]);
axis(eval(axes_operate), 'off');
end