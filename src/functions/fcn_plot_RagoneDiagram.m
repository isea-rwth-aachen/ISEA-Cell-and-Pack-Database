function fcn_plot_RagoneDiagram(app, axes_name)
% Function creates a Ragone Diagram for all stored battery cells
cla(app.(axes_name),'reset')
global global_cells;
% Get cell names
cellNames = arrayfun(@(x) GetProperty(x, 'Name'), global_cells, 'UniformOutput', false);
% Create arrays to store GED/GPD values
GEDvalues = zeros(1, numel(cellNames));
GPDvalues = zeros(1, numel(cellNames));
for i = 1:numel(cellNames)
    GEDvalues(i) = global_cells(i).GravEnergyDensity;
    GPDvalues(i) = global_cells(i).GravPowerDensity;
end 
colormat = fcn_get_plot_color(numel(cellNames));
% create scatter plot with all cells
scatter(app.(axes_name),GEDvalues,GPDvalues,36,colormat,'filled');
    app.(axes_name).YLabel.String       = 'GravEnergyDensity [Wh/kg]';
    app.(axes_name).YLabel.FontSize     = 14;
    app.(axes_name).XLabel.String       = 'GravPowerDensity [W/kg]';
    app.(axes_name).XLabel.FontSize     = 14;
    app.(axes_name).Title.String        = 'Ragone Diagram of Battery Cells';
    app.(axes_name).Title.Interpreter   = 'none';
    app.(axes_name).Title.FontSize      = 16;
    text(app.(axes_name),GEDvalues,GPDvalues,cellNames,'VerticalAlignment','bottom','HorizontalAlignment','left','FontSize',9,'Interpreter','none')
end