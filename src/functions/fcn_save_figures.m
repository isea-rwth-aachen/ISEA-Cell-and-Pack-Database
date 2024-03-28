%% fcn_save_figures
% function to save the generated figures The input data consists of the axes objects,the titles of the plots and the path to store the plots
function fcn_save_figures(varargin)
%%% init
id_titel                = cellfun(@(x) ischar(x) | isstring(x),varargin);
id_path                 = cellfun(@(x) contains(x,{'\','/'}),varargin(id_titel));
figures_cell            = varargin(~id_titel);
titel_cell              = varargin(id_titel);
%%% path selection
if nnz(id_path) == 1
    path_to_save            = titel_cell{id_path};
    titel_cell              = titel_cell(~id_path);
    if ~exist(path_to_save,'dir')
        mkdir(path_to_save);
    end
else
    path_to_save            = uigetdir(pwd,'Please select a location for saving the plot(s).');
end

if path_to_save == 0
    return;
end
n_figures               = numel(figures_cell);
%%% call function to create the figure
figures_to_save         = arrayfun(@(x) fcn_create_figure_for_saving(figures_cell{x},titel_cell{x}),(1:n_figures),'UniformOutput',false);   
filenames               = cellfun(@(x) strrep(x,' ', '_'),titel_cell, 'UniformOutput', false);
%%% save the figure in three different datatyps
figures_to_save         = [figures_to_save{:}];
arrayfun(@(x) savefig(figures_to_save(x),fullfile(path_to_save,filenames{x})), (1:n_figures));
arrayfun(@(x) saveas(figures_to_save(x),fullfile(path_to_save,filenames{x}), 'emf'), (1:n_figures));
arrayfun(@(x) saveas(figures_to_save(x),fullfile(path_to_save,filenames{x}), 'svg'), (1:n_figures));
msgbox('Figures were successfully saved under the specified path.','Save figures','help');
end

%% fcn_create_figure_for_saving
% create the figure(s) based on one axes from the GUI. In the sub-functions
% the axes gets created and in this function the figure and filtering
% between one and multiple axes are made
function fig = fcn_create_figure_for_saving(axes,titel)        
fig                     = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', titel);
if iscell(axes)
    is_axes         = cellfun(@(x) isa(x,'matlab.ui.control.UIAxes'),axes);
    isn_empty       = cellfun(@(x) ~isempty(x.Children),axes);
    axes_cell       = axes(is_axes & isn_empty);
    fig             = fcn_write_figure(axes_cell,fig);
else
    fig             = fcn_write_figure(axes,fig);
end
set(fig, 'CreateFcn','set(gcbf,''Visible'',''on'')');
end

%% fcn_write_figure
% this function distinct between multiple plots in one figure and single
% plots in one figure. Its calling also the function to mirror the axes.
function fig = fcn_write_figure(UIAxes,fig)
n_axes      = numel(UIAxes);
switch n_axes
    case 1
        id_subplots  = [1 1];
    case 2
        id_subplots  = [2 1];
    case 3
        id_subplots  = [3 1];
    case 4
        id_subplots  = [2 2];
end
if iscell(UIAxes)
    fig = arrayfun(@(x) fcn_make_subplot([id_subplots x],fig,UIAxes{x}),(1:n_axes));
else
    fig = fcn_make_subplot([id_subplots 1],fig,UIAxes);
end
end

%% fcn_make_subplot
% this function mirrors the the axtual axes and created the exact some one
% in the new figure again
function fig = fcn_make_subplot(id_subplots,fig,UIAxes)
set(0, 'CurrentFigure', fig);
h                               = subplot(id_subplots(1),id_subplots(2),id_subplots(3));
%check if two y-axis
if numel(UIAxes.YAxis) == 2
    yyaxis(UIAxes,'left');
    flag_two_yaxis  = true;
    copyobj(UIAxes.XAxis.Parent.Children,h);
    yyaxis(UIAxes,'right');
    yyaxis(fig.CurrentAxes,'right');
    copyobj(UIAxes.XAxis.Parent.Children,h);
    yyaxis(UIAxes,'left');
    yyaxis(fig.CurrentAxes,'left');
else
    flag_two_yaxis  = false;
    copyobj(UIAxes.XAxis.Parent.Children,h);
end
if ismember('Legend',fieldnames(UIAxes)) && isa(UIAxes.Legend,'matlab.graphics.illustration.Legend') && ~isempty(UIAxes.Legend.String)
    lgndName1                           = UIAxes.Legend.String;
    lgd                                 = legend(lgndName1);
    lgd.Box                             = UIAxes.Legend.Box;
    lgd.Location                        = UIAxes.Legend.Location;
    lgd.FontSize                        = 30;
end
if ismember('Parent',fieldnames(UIAxes)) && isa(UIAxes.Parent,'matlab.ui.container.GridLayout')
    grid(fig.CurrentAxes, 'on');
end
if ismember('Children',fieldnames(UIAxes)) && any(arrayfun(@(x) isa(UIAxes.Children(x),'matlab.graphics.primitive.Text'),(1:numel(UIAxes.Children))))
    idx_text                        = arrayfun(@(x) isa(UIAxes.Children(x),'matlab.graphics.primitive.Text'),(1:numel(UIAxes.Children))) .* (1:numel(UIAxes.Children));
    idx_text(idx_text==0)           = [];
    arrayfun(@(x) set(fig.CurrentAxes.Children(x), 'FontSize', UIAxes.Children(x).FontSize * 1.25),idx_text);
end
fig.CurrentAxes.YLabel.String       = UIAxes.YLabel.String;
fig.CurrentAxes.YLabel.Interpreter  = UIAxes.YLabel.Interpreter;
fig.CurrentAxes.XLabel.String       = UIAxes.XLabel.String;
fig.CurrentAxes.XLabel.Interpreter  = UIAxes.XLabel.Interpreter;
fig.CurrentAxes.ZLabel.String       = UIAxes.ZLabel.String;
fig.CurrentAxes.ZLabel.Interpreter  = UIAxes.ZLabel.Interpreter;
fig.CurrentAxes.Title.String        = UIAxes.Title.String;
fig.CurrentAxes.Title.Interpreter   = UIAxes.Title.Interpreter;
fig.CurrentAxes.XDir                = UIAxes.XDir;
fig.CurrentAxes.XLim                = UIAxes.XLim;
fig.CurrentAxes.YLim                = UIAxes.YLim;
fig.CurrentAxes.ZLim                = UIAxes.ZLim;
fig.CurrentAxes.LineWidth           = 2;
fig.CurrentAxes.View                = UIAxes.View;
fig.CurrentAxes.Visible             = UIAxes.Visible;
fig.CurrentAxes.XDir                = UIAxes.XDir;
fig.CurrentAxes.YDir                = UIAxes.YDir;
fig.CurrentAxes.ZDir                = UIAxes.ZDir;
fig.CurrentAxes.XScale              = UIAxes.XScale;
fig.CurrentAxes.YScale              = UIAxes.YScale;
fig.CurrentAxes.DataAspectRatio         = UIAxes.DataAspectRatio;
fig.CurrentAxes.DataAspectRatioMode     = UIAxes.DataAspectRatioMode;
fig.CurrentAxes.PlotBoxAspectRatioMode  = UIAxes.PlotBoxAspectRatioMode;
fig.CurrentAxes.XGrid                   = UIAxes.XGrid;
fig.CurrentAxes.YGrid                   = UIAxes.YGrid;
fig.CurrentAxes.ZGrid                   = UIAxes.ZGrid;
% adjust plot object line thickness
temp_graphic_objects                = arrayfun(@fcn_adjust_PlotObject_LineThickness,fig.CurrentAxes.Children,'UniformOutput',false);
fig.CurrentAxes.Children            = [temp_graphic_objects{:}];
if flag_two_yaxis
    yyaxis(UIAxes,'right');
    yyaxis(fig.CurrentAxes,'right');
    fig.CurrentAxes.YLabel.String       = UIAxes.YLabel.String;
    fig.CurrentAxes.YLabel.FontSize     = 24;
    fig.CurrentAxes.YLabel.Interpreter  = UIAxes.YLabel.Interpreter;
    fig.CurrentAxes.YLim                = UIAxes.YLim;
    fig.CurrentAxes.YDir                = UIAxes.YDir;
    fig.CurrentAxes.YScale              = UIAxes.YScale;
    temp_graphic_objects                = arrayfun(@fcn_adjust_PlotObject_LineThickness,fig.CurrentAxes.Children,'UniformOutput',false);
    fig.CurrentAxes.Children            = [temp_graphic_objects{:}];
    yyaxis(UIAxes,'left');
    yyaxis(fig.CurrentAxes,'left');
end
set(fig.CurrentAxes,'FontSize',26);
end

function plot_object = fcn_adjust_PlotObject_LineThickness(plot_object)
    object_type         = underlyingType(plot_object);
    switch object_type
        case 'matlab.graphics.chart.primitive.Line'
            plot_object.LineWidth   = 4;
    end
end