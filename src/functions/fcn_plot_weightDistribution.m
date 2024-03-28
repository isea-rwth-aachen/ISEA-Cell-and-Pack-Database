function fcn_plot_weightDistribution(app,cells,axes_name1)
% function for plotting the weight distribuation of the cell
%% init
n_data              = numel(cells);
if n_data == 0 || ~any(arrayfun(@(x) isa(cells(x),'Cell'),(1:n_data)))
    return;
end
%% get data
weights_data        = arrayfun(@(x) [cells(x).ElectrodeStack.Anode.CoatingWeight * cells(x).ElectrodeStack.NrOfAnodes cells(x).ElectrodeStack.Anode.CurrentCollector.Weight * cells(x).ElectrodeStack.NrOfAnodes...
                        cells(x).ElectrodeStack.Cathode.CoatingWeight * cells(x).ElectrodeStack.NrOfCathodes cells(x).ElectrodeStack.Cathode.CurrentCollector.Weight * cells(x).ElectrodeStack.NrOfCathodes...
                        cells(x).ElectrodeStack.SeparatorWeight cells(x).ElectrodeStack.ElectrolyteWeight cells(x).ElectrodeStack.ActiveTransferMaterialWeight cells(x).Housing.Weight],(1:n_data),'UniformOutput', false);
weight_labels       = {'Anode coating', 'Anode collector', 'Cathode coating', 'Cathode collector' 'Separator', 'Electrolyte' 'Active transfer material', 'Housing'};
color_codes         = fcn_get_plot_color(numel(weight_labels));
%% get plot
if n_data == 1 && nargin == 3 && ~isempty(axes_name1)
    cla(app.(axes_name1),'reset');
elseif n_data == 1 && (nargin < 3 || isempty(axes_name1))
    name_cell                       = convertStringsToChars(GetProperty(cells,'Name'));
    figure_weight_distribution      = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', ['Weight distribution of the cell ' name_cell]);
    set(figure_weight_distribution, 'CreateFcn','set(gcbf,''Visible'',''on'')');
    set(0, 'CurrentFigure', figure_weight_distribution);
    axes_figure                     = axes('Parent', figure_weight_distribution);
    pie(axes_figure,cell2mat(weights_data));
    lgd                             = legend(weight_labels, 'Location', 'eastoutside');
    set(axes_figure, 'FontSize', 14);
    figure_weight_distribution.CurrentAxes.Title.String         = ['Weight distribution of the cell ' name_cell];
    figure_weight_distribution.CurrentAxes.Title.FontSize       = 16;
    axes_figure.Colormap                                        = color_codes;
    set(figure_weight_distribution, 'Visible','on');
elseif n_data < 5 && ~isempty(axes_name1)
    warning('Fcn_plot_weightDistribution: Case not implemented');
else
    figure_weight_distribution      = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', 'Weight distribution of the selected cells');
    set(figure_weight_distribution, 'CreateFcn','set(gcbf,''Visible'',''on'')');
    set(0, 'CurrentFigure', figure_weight_distribution);
    axes_figure                     = axes('Parent', figure_weight_distribution);
    total_weight_cell               = cellfun(@sum,weights_data);
    bar_data                        = (cell2mat(weights_data')'./total_weight_cell).* 100;
    name_cells                      = arrayfun(@(x) strrep(convertStringsToChars(GetProperty(cells(x),'Name')),'_',' '),(1:n_data),'UniformOutput', false);
    x_bar_data                      = categorical(name_cells);
    x_bar_data                      = reordercats(x_bar_data,name_cells);
    bar_weight_distruibution        = bar(axes_figure,x_bar_data,bar_data,'stacked');
    ylim([0 100]);
    figure_weight_distribution.CurrentAxes.YLabel.String        = 'Weight percentage [%]';
    figure_weight_distribution.CurrentAxes.YLabel.FontSize      = 14;
    set(axes_figure, 'FontSize', 14);
    figure_weight_distribution.CurrentAxes.Title.String         = 'Weight distribution of the selected cells';
    figure_weight_distribution.CurrentAxes.Title.FontSize       = 16;
    figure_weight_distribution.CurrentAxes.TickLabelInterpreter = 'none';
    lgd                                                         = legend(weight_labels, 'Location', 'eastoutside');
    grid(figure_weight_distribution.CurrentAxes,'on');
    ytip_last_data                                              = 0;
    set(figure_weight_distribution, 'Visible','on');
end
end