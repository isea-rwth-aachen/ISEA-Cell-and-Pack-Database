function fcn_get_spider_plot_cells(app,cells,axes_name,flag_figure)
%% function for creating a spider diagram for comparison of max. three cells
%% init
global global_cells;
global global_variedCells;
n_data              = numel(cells);
if n_data == 0 || ~any(arrayfun(@(x) isa(cells(x),'Cell'),(1:n_data)))
    return;
end
if nargin < 4 
    flag_figure     = false;
end
vgl_cells           = [global_cells global_variedCells];
%% get data
grav_energy_density                 = arrayfun(@(x) GetProperty(cells(x),'GravEnergyDensity'),(1:n_data), 'UniformOutput', false);
vol_energy_density                  = arrayfun(@(x) GetProperty(cells(x),'VolEnergyDensity'),(1:n_data), 'UniformOutput', false);
grav_power_density                  = arrayfun(@(x) GetProperty(cells(x),'GravPowerDensity'),(1:n_data), 'UniformOutput', false);
vol_power_density                   = arrayfun(@(x) GetProperty(cells(x),'VolPowerDensity'),(1:n_data), 'UniformOutput', false);
grav_energy_density(cellfun(@isempty,grav_energy_density))      = {0};
vol_energy_density(cellfun(@isempty,vol_energy_density))        = {0};
grav_power_density(cellfun(@isempty,grav_power_density))        = {0};
vol_power_density(cellfun(@isempty,vol_power_density))          = {0};
grav_energy_density                                             = cell2mat(grav_energy_density);
vol_energy_density                                              = cell2mat(vol_energy_density);
grav_power_density                                              = cell2mat(grav_power_density);
vol_power_density                                               = cell2mat(vol_power_density);
grav_energy_density(grav_energy_density==0)                     = NaN;
vol_energy_density(vol_energy_density==0)                       = NaN;
grav_power_density(grav_power_density==0)                       = NaN;
vol_power_density(vol_power_density==0)                         = NaN;
global_max_value                    = [max(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'GravEnergyDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))...
                                        max(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'VolEnergyDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))...
                                        max(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'GravPowerDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))...
                                        max(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'VolPowerDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))];
global_min_value                    = [min(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'GravEnergyDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))...
                                        min(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'VolEnergyDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))...
                                        min(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'GravPowerDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))...
                                        min(cell2mat(arrayfun(@(x) GetProperty(vgl_cells(x),'VolPowerDensity'),(1:numel(vgl_cells)), 'UniformOutput', false)))];
%% get spiderplot data
n_points                            = 4;
spider_labels                       = cell(n_points, 1);
spider_labels(1)                    = {'grav. energy density'};
spider_labels(2)                    = {'vol. energy density'};
spider_labels(3)                    = {'grav. power density'};
spider_labels(4)                    = {'vol. power density'};
spider_data                         = [grav_energy_density' vol_energy_density' grav_power_density' vol_power_density'];
axes_interval                       = 3;
axes_precision                      = 0; %no float comma
%% plot spider diagram
if flag_figure
    names_cell                      = arrayfun(@(x) convertStringsToChars(GetProperty(cells(x),'Name')),(1:n_data), 'UniformOutput', false);
    titel_figure                    = strjoin(names_cell,' and ');
    figure_spider                   = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', ['Spider diagram of ' titel_figure]);
    axes_figure                     = axes('Parent', figure_spider);
    hold(axes_figure, 'on');
    fcn_generate_spider_plot([],spider_data, spider_labels, axes_interval, axes_precision,axes_figure,global_max_value,global_min_value,'Marker', 'o','LineStyle', '-','LineWidth', 2,'MarkerSize', 5);
    legend(axes_figure, names_cell, 'FontSize', 10,'Location','northeastoutside','Interpreter', 'none');
    set(axes_figure, 'Visible', 'off');
    set(figure_spider, 'Visible','on');
else
    cla(app.(axes_name),'reset');
    axes(app.(axes_name));
    hold(app.(axes_name), 'on');
    fcn_generate_spider_plot(app,spider_data, spider_labels, axes_interval, axes_precision,axes_name,global_max_value,global_min_value,'Marker', 'o','LineStyle', '-','LineWidth', 2,'MarkerSize', 5);
end
end