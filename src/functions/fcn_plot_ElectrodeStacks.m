function fcn_plot_ElectrodeStacks(app,electrode_stacks,axes_name1,axes_name2,axes_name3,type,cell)
% function for creating the OCV plots of the selected electrode stack
%% init
n_data              = numel(electrode_stacks);
if n_data == 0 || ~any(arrayfun(@(x) isa(electrode_stacks(x),'ElectrodeStack'),(1:n_data)))
    return;
end
if nargin < 6 || (~strcmpi(type,'SOC') && ~strcmpi(type,'Capacity'))
    type            = 'SOC';
end
%% get plot data
ocv_dis_electrodes          = arrayfun(@(x) GetProperty(electrode_stacks(x),'OpenCircuitVoltage'),(1:n_data), 'UniformOutput',false);
ocv_cha_electrodes          = arrayfun(@(x) GetProperty(electrode_stacks(x),'OpenCircuitVoltageCha'),(1:n_data), 'UniformOutput',false);
soc_electrodes              = arrayfun(@(x) GetProperty(electrode_stacks(x),'StateOfCharge')*100,(1:n_data), 'UniformOutput',false);
mean_ocv                    = arrayfun(@(x) mean([ocv_dis_electrodes{x}; ocv_cha_electrodes{x}],1),1:n_data,'UniformOutput',false);
nom_voltage_dis             = arrayfun(@(x) GetProperty(electrode_stacks(x), 'NominalVoltage'),(1:n_data));
nom_voltage_cha             = arrayfun(@(x) GetProperty(electrode_stacks(x), 'NominalVoltageCha'),(1:n_data));
capacity                    = arrayfun(@(x) GetProperty(electrode_stacks(x), 'Capacity') .* soc_electrodes{x} ./ 100,(1:n_data), 'UniformOutput', false);
[~,idx_nom_dis]             = arrayfun(@(x) min(abs(ocv_dis_electrodes{x} - nom_voltage_dis(x))),(1:n_data));
[~,idx_nom_cha]             = arrayfun(@(x) min(abs(ocv_cha_electrodes{x} - nom_voltage_cha(x))),(1:n_data));
color_codes                 = fcn_get_plot_color(n_data*2);   
legend_names                = arrayfun(@(x) strrep(convertStringsToChars(GetProperty(electrode_stacks(x),'Name')),'_',' '),(1:n_data),'UniformOutput',false);
transfer_material           = arrayfun(@(x) convertStringsToChars(GetProperty(x.Anode.Coating.ActiveMaterial.TransferMaterial, 'Name')),electrode_stacks,'UniformOutput',false);
if nargin > 4
    switch type
        case 'SOC'
            difference_x            = [0; soc_electrodes{1}'; 100; flip(soc_electrodes{1}')]; %min and max for closing the shade between the curves
            difference_y            = [min(ocv_dis_electrodes{1}); ocv_cha_electrodes{1}'; max(ocv_dis_electrodes{1}); flip(ocv_dis_electrodes{1}')]; 
        case 'Capacity'
            difference_x            = [0; capacity{1}'; max(capacity{1}); flip(capacity{1}')]; %min and max for closing the shade between the curves
            difference_y            = [min(ocv_dis_electrodes{1}); ocv_cha_electrodes{1}'; max(ocv_dis_electrodes{1}); flip(ocv_dis_electrodes{1}')]; 
    end
end
if nargin == 7 && isa(cell, 'Cell')
    subtitle_name           = strjoin(arrayfun(@(x) convertStringsToChars(GetProperty(cell(x), 'Name')),(1:n_data),'UniformOutput', false), ' and ');
end
switch type
    case 'SOC'
        x_data              = soc_electrodes;
        x_label             = 'SOC in %';
    case 'Capacity'
        x_data              = capacity;
        x_label             = 'Capacity in Ah';
end
if contains(transfer_material{1},'lithium')
    intercalation_name      = 'lithiation';
    deintercalation_name    = 'delithiation';
elseif contains(transfer_material{1},'sodium')
    intercalation_name      = 'sodiation';
    deintercalation_name    = 'desodiation';
else
    warning('The transfer material (de-)intercalation process is not named. Use Lithiation and Delithiation');
    intercalation_name      = 'lithiation/sodiation';
    deintercalation_name    = 'delithiation/desodiation';
end
%% plot discharge OCV
if nargin > 2 && ~isempty(axes_name1)
    cla(app.(axes_name1),'reset');
    axes(app.(axes_name1));
    hold(app.(axes_name1), 'on');
    arrayfun(@(x) plot(app.(axes_name1), flip(x_data{x}), flip(ocv_dis_electrodes{x}), 'Color', color_codes(x,:), 'LineWidth', 2.0, 'MarkerIndices', idx_nom_dis(x), 'MarkerSize',...
                        8, 'Marker', 'o'),(1:n_data));
    set(app.(axes_name1), 'xdir', 'reverse');
    legend(app.(axes_name1), legend_names, 'FontSize', 10,'Location','southwest');
    if strcmpi(type, 'Capacity')
        xlim(app.(axes_name1), [0 max(arrayfun(@(x) max(x_data{x}),(1:n_data)))]);
        xlabel(app.(axes_name1),x_label);
    else
        xlim(app.(axes_name1), [0 100]);
        xlabel(app.(axes_name1),x_label);
    end
    app.(axes_name1).YLabel.String       = 'Voltage in V';
    app.(axes_name1).YLabel.FontSize     = 14;
    app.(axes_name1).XLabel.FontSize     = 14;
    grid(app.(axes_name1),"on");
elseif nargin == 7 && isa(cell, 'Cell')
    fig_ocv                 = figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', strjoin(['OCV' legend_names]));
    set(fig_ocv, 'CreateFcn','set(gcbf,''Visible'',''on'')');
    set(0, 'CurrentFigure', fig_ocv);
    if n_data > 1
        discharge_plot      = subplot(2,1,1);
    else
        discharge_plot      = subplot(3,1,1);
    end
    hold on;
    arrayfun(@(x) plot(discharge_plot,flip(x_data{x}),flip(ocv_dis_electrodes{x}), 'Color', color_codes(x,:), 'LineWidth', 2.0, 'MarkerIndices', idx_nom_dis(x), 'MarkerSize',...
                        8, 'Marker', 'o'),(1:n_data));
    set(discharge_plot, 'xdir', 'reverse');
    set(fig_ocv.CurrentAxes, 'FontSize', 14);
    fig_ocv.CurrentAxes.YLabel.String       = 'Voltage in V';
    fig_ocv.CurrentAxes.YLabel.FontSize     = 14;
    fig_ocv.CurrentAxes.XLabel.String       = x_label;
    fig_ocv.CurrentAxes.XLabel.FontSize     = 14;
    fig_ocv.CurrentAxes.Title.String        = 'Open circuit voltage discharge';
    fig_ocv.CurrentAxes.Title.FontSize      = 16;
    grid(fig_ocv.CurrentAxes,"on");
    if n_data < 4
        fig_ocv.CurrentAxes.Subtitle.String     = subtitle_name;
        fig_ocv.CurrentAxes.Subtitle.Interpreter= 'none';
    end
    grid on;
    if strcmpi(type, 'Capacity')
       xlim(fig_ocv.CurrentAxes, [0 max(arrayfun(@(x) max(x_data{x}),(1:n_data)))]);
    end
    legend(fig_ocv.CurrentAxes, legend_names, 'FontSize', 14,'Location','southwest');
end
%% plot charge OCV
if nargin > 3 && ~isempty(axes_name2)
    cla(app.(axes_name2),'reset');
    axes(app.(axes_name2));
    hold(app.(axes_name2), 'on');
    arrayfun(@(x) plot(app.(axes_name2), x_data{x}, ocv_cha_electrodes{x}, 'Color', color_codes(x,:), 'LineWidth', 2.0,'MarkerIndices', idx_nom_cha(x), 'MarkerSize',...
                        8, 'Marker', 'o'),(1:n_data));
    legend(app.(axes_name2), legend_names, 'FontSize', 10,'Location','southeast');
    if strcmpi(type, 'Capacity')
        xlim(app.(axes_name2), [0 max(arrayfun(@(x) max(x_data{x}),(1:n_data)))]);
        xlabel(app.(axes_name2),x_label);
    else
        xlim(app.(axes_name2), [0 100]);
        xlabel(app.(axes_name2),x_label);
    end
    app.(axes_name2).YLabel.String       = 'Voltage in V';
    app.(axes_name2).YLabel.FontSize     = 14;
    app.(axes_name2).XLabel.FontSize     = 14;
    grid(app.(axes_name2),"on");
elseif nargin == 7 && isa(cell, 'Cell')
    if n_data > 1
        charge_plot                         = subplot(2,1,2);
    else
        charge_plot                         = subplot(3,1,2);
    end
    hold on;
    arrayfun(@(x) plot(charge_plot, x_data{x}, ocv_cha_electrodes{x}, 'Color', color_codes(x,:), 'LineWidth', 2.0,'MarkerIndices', idx_nom_cha(x), 'MarkerSize',...
                        8, 'Marker', 'o'),(1:n_data));
    fig_ocv.CurrentAxes.YLabel.String       = 'Voltage in V';
    fig_ocv.CurrentAxes.YLabel.FontSize     = 14;
    fig_ocv.CurrentAxes.XLabel.String       = x_label;
    fig_ocv.CurrentAxes.XLabel.FontSize     = 14;
    fig_ocv.CurrentAxes.Title.String        = 'Open circuit voltage charge';
    fig_ocv.CurrentAxes.Title.FontSize      = 16;
    grid(fig_ocv.CurrentAxes,"on");
    if n_data < 4
        fig_ocv.CurrentAxes.Subtitle.String     = subtitle_name;
        fig_ocv.CurrentAxes.Subtitle.Interpreter= 'none';
    end
    set(fig_ocv.CurrentAxes, 'FontSize', 14);
    grid on;
    legend(fig_ocv.CurrentAxes, legend_names, 'FontSize', 14,'Location','southeast');
end
%% plot charge and discharge OCV of the first electrode stack
if nargin > 4 && max(abs(ocv_cha_electrodes{1} - ocv_dis_electrodes{1})) > 0.02 && ~isempty(axes_name3)
    cla(app.(axes_name3),'reset');
    axes(app.(axes_name3));
    hold(app.(axes_name3), 'on');
    plot(app.(axes_name3), x_data{1}, ocv_dis_electrodes{1}, 'Color', [0.6350 0.0780 0.1840],'LineWidth', 2.0);
    plot(app.(axes_name3), x_data{1}, ocv_cha_electrodes{1}, 'Color', [0.4660 0.6740 0.1880],'LineWidth', 2.0);
    plot(app.(axes_name3), x_data{1}, mean_ocv{1},'Color',[0.4940 0.1840 0.5560],'LineStyle','--','LineWidth',2.0);
    patch(app.(axes_name3), difference_x, difference_y,[0.3010 0.7450 0.9330], 'FaceAlpha',0.3,'LineStyle','none');
    legend_names                    = {join([legend_names{1}, ' discharge']); join([legend_names{1}, ' charge']); join([legend_names{1}, ' average'])};
    legend(app.(axes_name3),legend_names, 'FontSize', 10, 'Location', 'northwest');
    if strcmpi(type, 'Capacity')
        xlim(app.(axes_name3), [0 max(arrayfun(@(x) max(x_data{x}),(1:n_data)))]);
        xlabel(app.(axes_name3),x_label);
    else
        xlim(app.(axes_name3), [0 100]);
        xlabel(app.(axes_name3),x_label);
    end
    app.(axes_name3).YLabel.String       = 'Voltage in V';
    app.(axes_name3).YLabel.FontSize     = 14;
    app.(axes_name3).XLabel.FontSize     = 14;
    grid(app.(axes_name3),"on");
elseif nargin > 4 && ~isempty(axes_name3)
    cla(app.(axes_name3),'reset');
    axes(app.(axes_name3));
    hold(app.(axes_name3), 'on');
    plot(app.(axes_name3), x_data{1}, ocv_dis_electrodes{1}, 'Color', [0.6350 0.0780 0.1840],'LineWidth', 2.0);
    plot(app.(axes_name3), x_data{1}, ocv_cha_electrodes{1}, 'Color', [0.4660 0.6740 0.1880],'LineWidth', 2.0);
    legend_names                    = {'No significant difference could be determined'; 'between the OCV during charging and discharging.'};
    legend(app.(axes_name3),legend_names, 'FontSize', 10);
    if strcmpi(type, 'Capacity')
        xlim(app.(axes_name3), [0 max(arrayfun(@(x) max(x_data{x}),(1:n_data)))]);
        xlabel(app.(axes_name3),x_label);
    else
        xlim(app.(axes_name3), [0 100]);
        xlabel(app.(axes_name3),x_label);
    end
    grid(app.(axes_name3),"on");
elseif nargin == 7 && isa(cell, 'Cell') && n_data == 1
    compared_ocv          = subplot(3,1,3);
    hold on;
    plot(compared_ocv, x_data{1}, ocv_dis_electrodes{1}, 'Color', [0.6350 0.0780 0.1840],'LineWidth', 2.0);
    plot(compared_ocv, x_data{1}, ocv_cha_electrodes{1}, 'Color', [0.4660 0.6740 0.1880],'LineWidth', 2.0); 
    plot(compared_ocv, x_data{1}, mean_ocv{1},'Color',[0.4940 0.1840 0.5560],'LineStyle','--','LineWidth',2.0);
    if  max(abs(ocv_cha_electrodes{1} - ocv_dis_electrodes{1})) > 0.02
        patch(compared_ocv, difference_x, difference_y,[0.3010 0.7450 0.9330], 'FaceAlpha',0.3,'LineStyle','none');
        legend_names                    = {join([legend_names{1}, ' discharge']); join([legend_names{1}, ' charge'])};
        legend(compared_ocv,legend_names, 'FontSize', 10, 'Location', 'northwest');
    else
        legend_names                    = {'No significant difference could be determined'; 'between the OCV during charging and discharging.'};
        legend(compared_ocv,legend_names, 'FontSize', 10);
    end
    fig_ocv.CurrentAxes.YLabel.String       = 'Voltage in V';
    fig_ocv.CurrentAxes.YLabel.FontSize     = 14;
    fig_ocv.CurrentAxes.XLabel.String       = x_label;
    fig_ocv.CurrentAxes.XLabel.FontSize     = 14;
    fig_ocv.CurrentAxes.Title.String        = 'Open circuit voltages compared';
    fig_ocv.CurrentAxes.Title.FontSize      = 16;
    grid(fig_ocv.CurrentAxes,"on");
    if n_data < 4
        fig_ocv.CurrentAxes.Subtitle.String     = subtitle_name;
        fig_ocv.CurrentAxes.Subtitle.Interpreter= 'none';
    end
    set(gca, 'FontSize', 14);
    grid on;
    if strcmpi(type, 'Capacity')
       xlim(fig_ocv.CurrentAxes, [0 max(arrayfun(@(x) max(x_data{x}),(1:n_data)))]);
    end
end
if nargin == 7 && isa(cell, 'Cell')
    set(fig_ocv, 'Visible', 'on');
end
end