%% fcn_plot_Cell_OCV
% Function to plot the OCV and the ICA of the corresponding cells
function fcn_plot_Cell_OCV(app,cell_objects,axes_name1,flag_show_figure,axes_name2)
%% init
n_data              = numel(cell_objects);
if n_data == 0 || ~any(arrayfun(@(x) isa(cell_objects(x),'Cell'),(1:n_data)))
    return;
end
if nargin < 3 || isempty(axes_name1)
    flag_figure     = true;
else
    flag_figure     = false;
end
if nargin == 5
    flag_ICA        = true;
else
    flag_ICA        = false;
end
if ~exist("flag_show_figure",'var')
    flag_show_figure        = false;
end
%% get plot data
voltages            = arrayfun(@(x) mean([GetProperty(cell_objects(x), 'OpenCircuitVoltage'); GetProperty(cell_objects(x), 'OpenCircuitVoltage')],1),(1:n_data),'UniformOutput',false);
socs                = arrayfun(@(x) GetProperty(cell_objects(x),'StateOfCharge') .* 100,(1:n_data),'UniformOutput',false);
legend_names        = arrayfun(@(x) strrep(convertStringsToChars(GetProperty(cell_objects(x),'Name')),'_',' '),(1:n_data),'UniformOutput',false);
color_codes         = fcn_get_plot_color(n_data);  
if flag_ICA
    capacity        = arrayfun(@(x) cell_objects(x).Capacity .* linspace(0,1,10000),(1:n_data),'UniformOutput',false);
    voltages_ICA    = arrayfun(@(x) interp1(socs{x},voltages{x},linspace(0,100,10000)),(1:n_data),'UniformOutput',false);
    dQ              = cellfun(@(x) diff(x),capacity,'UniformOutput',false);
    dV              = cellfun(@(x) diff(x),voltages_ICA,'UniformOutput',false);
    dQ_dV           = arrayfun(@(x) [0 dQ{x}./dV{x}],(1:n_data),'UniformOutput',false);
end
%% plot OCV
if ~flag_figure
    cla(app.(axes_name1),'reset');
    axes(app.(axes_name1));
    hold(app.(axes_name1), 'on');
    arrayfun(@(x) plot(app.(axes_name1), socs{x},voltages{x}, 'Color', color_codes(x,:), 'LineWidth', 2.0),(1:n_data));
    app.(axes_name1).YLabel.String       = 'Voltage in V';
    app.(axes_name1).YLabel.FontSize     = 14;
    app.(axes_name1).XLabel.FontSize     = 14;
    app.(axes_name1).XLabel.String       = 'SOC in %';
    app.(axes_name1).XLim                = [0 100];
    if flag_ICA &&~isempty(axes_name2)
        cla(app.(axes_name2),'reset');
        axes(app.(axes_name2));
        hold(app.(axes_name2), 'on');
        arrayfun(@(x) plot(app.(axes_name2), voltages{x},dQ_dV{x}, 'Color', color_codes(x,:), 'LineWidth', 2.0),(1:n_data));
        app.(axes_name2).YLabel.String       = 'Incremental capacity $\partial Q/\partial V$ in Ah/V';
        app.(axes_name2).YLabel.FontSize     = 14;
        app.(axes_name2).XLabel.FontSize     = 14;
        app.(axes_name2).XLabel.String       = 'Voltage in V';
        app.(axes_name2).XLim                = [0 100];
    end
else
    fig_ocv                 = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', 'Open-circuit voltage cells');
    set(fig_ocv, 'CreateFcn','set(gcbf,''Visible'',''on'')');
    set(0, 'CurrentFigure', fig_ocv);
    if flag_ICA
        OCV_plot            = subplot(2,1,1);
    else
        OCV_plot            = axes(fig_ocv);
    end
    hold on;
    arrayfun(@(x) plot(OCV_plot, socs{x},voltages{x}, 'Color', color_codes(x,:), 'LineWidth', 2.0),(1:n_data));
    set(fig_ocv.CurrentAxes, 'FontSize', 18);
    fig_ocv.CurrentAxes.YLabel.String       = 'Voltage in V';
    fig_ocv.CurrentAxes.YLabel.FontSize     = 18;
    fig_ocv.CurrentAxes.XLabel.String       = 'SOC in %';
    fig_ocv.CurrentAxes.XLabel.FontSize     = 18;
    fig_ocv.CurrentAxes.Title.FontSize      = 20;
    legend(OCV_plot,legend_names,'Location','southeast');
    title(OCV_plot,'Open-circuit-voltages');
    grid on;
    if flag_ICA
        ICA_plot        = subplot(2,1,2);
        hold on;
        arrayfun(@(x) plot(ICA_plot, voltages_ICA{x},dQ_dV{x}, 'Color', color_codes(x,:), 'LineWidth', 2.0),(1:n_data));
         set(fig_ocv.CurrentAxes, 'FontSize', 18);
        fig_ocv.CurrentAxes.YLabel.String       = 'Incremental capacity \partial Q/\partial V in Ah/V';
        fig_ocv.CurrentAxes.YLabel.FontSize     = 18;
        fig_ocv.CurrentAxes.XLabel.String       = 'Voltage in V';
        fig_ocv.CurrentAxes.XLabel.FontSize     = 18;
        fig_ocv.CurrentAxes.Title.FontSize      = 20;
        fig_ocv.CurrentAxes.YScale              = 'log';
        legend(ICA_plot,legend_names,'Location','northwest');
        title(ICA_plot,'Incremental capacity analysis')
        grid on;
    end
end
%% set visibility figures
if flag_show_figure && flag_figure
    set(fig_ocv, 'Visible', 'on');
end
end