function fig = FcnPlotBalancing(obj, cell_OCV_with_anode, cell_OCV_with_cathode)

if isa(obj, 'Cell')
    cell.soc = obj.StateOfCharge;
    cell.ocv = obj.OpenCircuitVoltage;
    anode.ocv = obj.ElectrodeStack.Anode.Coating.ActiveMaterial.OpenCircuitPotential;
    anode.Li_x = obj.ElectrodeStack.Anode.Coating.ActiveMaterial.OccupancyRate;
    cath.ocv = obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.OpenCircuitPotential;
    cath.Li_x = obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.OccupancyRate;

    anode.lith.pset = obj.ElectrodeStack.Anode.Coating.ActiveMaterial.CommonOccupancyRange;
    cath.lith.pset = obj.ElectrodeStack.Cathode.Coating.ActiveMaterial.CommonOccupancyRange;

else
    error('wrong input type!');
end

lw=1.6;
fs=24;
load('PlotsAndTools\ColorListForPlots\Color_List.mat');

cath.lith.max=max(cath.Li_x);
cath.lith.min=min(cath.Li_x);
cath.lith.max_used=max(cath.lith.pset);
cath.lith.min_used=min(cath.lith.pset);
cath.lith.delta_used=abs(cath.lith.max_used-cath.lith.min_used);

anode.lith.max=max(anode.Li_x);
anode.lith.min=min(anode.Li_x);
anode.lith.max_used=max(anode.lith.pset);
anode.lith.min_used=min(anode.lith.pset);
anode.lith.delta_used=abs(anode.lith.max_used-anode.lith.min_used);

cell.soc_range.max=max(cell.soc*100);
cell.soc_range.min=min(cell.soc*100);
cell.soc_range.delta=abs(cell.soc_range.max-cell.soc_range.min);

%% Von An geschrieben
cath.lith.delta_sample = linspace(cath.lith.min_used,cath.lith.max_used,1000);
cath.ocv_used = interp1(cath.Li_x,cath.ocv,cath.lith.delta_sample);
anode.lith.delta_sample = linspace(anode.lith.min_used,anode.lith.max_used,1000);
anode.ocv_used = interp1(anode.Li_x,anode.ocv,anode.lith.delta_sample);

cell.soc_used = linspace(0,100,1000);
cell.ocv_used = fliplr(cath.ocv_used)-anode.ocv_used;

%%
cath.lith.min_SOC=cell.soc_range.min - abs(cath.lith.max - cath.lith.max_used) * cell.soc_range.delta / cath.lith.delta_used;
cath.lith.max_SOC=cell.soc_range.max + abs(cath.lith.min - cath.lith.min_used) * cell.soc_range.delta / cath.lith.delta_used;

anode.lith.min_SOC=cell.soc_range.min - abs(anode.lith.min - anode.lith.min_used) * cell.soc_range.delta / anode.lith.delta_used;
anode.lith.max_SOC=cell.soc_range.max + abs(anode.lith.max - anode.lith.max_used) * cell.soc_range.delta / anode.lith.delta_used;

if cath.lith.min_SOC<anode.lith.min_SOC
    cell.soc_range.range(1)=cath.lith.min_SOC;
    cath.lith.range(2)=cath.lith.max;
    anode.lith.range(1)=anode.lith.min_used - abs(cath.lith.max - cath.lith.max_used) * anode.lith.delta_used / cath.lith.delta_used;
else
    cell.soc_range.range(1)=anode.lith.min_SOC;
    cath.lith.range(2)=cath.lith.max_used + abs(anode.lith.min - anode.lith.min_used) * cath.lith.delta_used / anode.lith.delta_used;
    anode.lith.range(1)=anode.lith.min;
end

if cath.lith.max_SOC>anode.lith.max_SOC
    cell.soc_range.range(2)=cath.lith.max_SOC;
    cath.lith.range(1)=cath.lith.min;
    anode.lith.range(2)=anode.lith.max_used + abs(cath.lith.min - cath.lith.min_used) * anode.lith.delta_used / cath.lith.delta_used;
else
    cell.soc_range.range(2)=anode.lith.max_SOC;
    cath.lith.range(1)=cath.lith.min_used - abs(anode.lith.max - anode.lith.max_used) * cath.lith.delta_used / anode.lith.delta_used;
    anode.lith.range(2)=anode.lith.max;
end

fig=figure('units','normalized','position',[0.1,0.1,0.7,0.7]);
sub(1)=subplot(2,1,1);
if cell_OCV_with_cathode
    sub(1).Position(2)=sub(1).Position(2)-0.02;
elseif cell_OCV_with_anode
    sub(1).Position(2)=sub(1).Position(2)+0.055;
end
sub(1).Visible='off';
% plot cathode OCV
ax1 = axes('Position',sub(1).Position,...
    'XAxisLocation','bottom',...
    'YAxisLocation','left',...
    'XGrid', 'on',...
    'YGrid', 'on',...
    'XColor', Colors_MKu{2},...
    'YColor', Colors_MKu{2},...
    'Color','w',...
    'XDir', 'reverse',...
    'FontSize', fs);
xlabel('cathode lithiation x'); ylabel('OCP vs Li/Li^+ in V');
xlabh = get(gca,'xlabel'); set(xlabh, 'HorizontalAlignment', 'right'); set(xlabh, 'VerticalAlignment', 'cap');
line(cath.Li_x, cath.ocv, 'Parent', ax1, 'Color', Colors_MKu{2}, 'LineWidth', lw);
line([cath.lith.min_used, cath.lith.max_used], [interp1(cath.Li_x, cath.ocv, cath.lith.min_used), interp1(cath.Li_x, cath.ocv, cath.lith.max_used)], 'Parent', ax1, 'LineStyle', 'none', 'Marker', 'x', 'MarkerSize', 10, 'Color', Colors_MKu{2}, 'LineWidth', lw);
xlim(cath.lith.range);
ylim(get(ax1, 'YLim'));
% plot cell OCV
if cell_OCV_with_cathode
    ax2 = axes('Position',ax1.Position,...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'XColor', 'k',...
        'YColor', 'k',...
        'Color','none',...
        'FontSize', fs);
    xlabel('SoC in %'); ylabel('OCV in V');
    line(cell.soc*100, cell.ocv, 'Parent', ax2, 'Color', 'k', 'LineWidth', lw);
    line(cell.soc_used, cell.ocv_used, 'Parent', ax2, 'Color', [0.1, 0.8, 0], 'LineStyle', '--', 'LineWidth', lw);

    ax1.YLim=[min(ax1.YLim(1), ax2.YLim(1)), max(ax1.YLim(2), ax2.YLim(2))];
    ax2.YLim=[min(ax1.YLim(1), ax2.YLim(1)), max(ax1.YLim(2), ax2.YLim(2))];
    legend('measured cell OCV', 'calculated cell OCV', 'Location', 'East');
    xlim(cell.soc_range.range);
    try
        text_handle=text(ax2, 50, interp1(cell.soc*100, cell.ocv, 50)-0.05*(ax2.YLim(2)-ax2.YLim(1)), ['RMSE: ', num2str(obj.AddInfo.RMSE*1000, '%.1f'), ' mV'], 'FontSize', fs, 'BackgroundColor', [0.9, 0.9, 0.9]);
        set(text_handle, 'VerticalAlignment', 'top')
    end
end
text(ax1, cath.lith.min_used-0.01, interp1(cath.Li_x, cath.ocv, cath.lith.min_used), [' ', num2str(round(cath.lith.min_used,3))], 'FontSize', fs, 'BackgroundColor', [0.9, 0.9, 0.9]);
text(ax1, cath.lith.max_used-0.01, interp1(cath.Li_x, cath.ocv, cath.lith.max_used), [' ', num2str(round(cath.lith.max_used,3))], 'FontSize', fs, 'BackgroundColor', [0.9, 0.9, 0.9]);
line([cath.lith.min_used, cath.lith.min_used], get(ax1, 'YLim'), 'Parent', ax1, 'LineStyle', '--', 'Color', 'k', 'LineWidth', lw);
line([cath.lith.max_used, cath.lith.max_used], get(ax1, 'YLim'), 'Parent', ax1, 'LineStyle', '--', 'Color', 'k', 'LineWidth', lw);
legend(ax1, 'cathode OCP', 'Location', 'NorthWest');

sub(2)=subplot(2,1,2);
sub(2).Visible='off';
if cell_OCV_with_anode
    sub(2).Position(2)=sub(2).Position(2)-0.00;
end
% plot anode OCV
ax1 = axes('Position',sub(2).Position,...
    'XAxisLocation','bottom',...
    'YAxisLocation','left',...
    'XGrid', 'on',...
    'YGrid', 'on',...
    'XColor', Colors_MKu{1},...
    'YColor', Colors_MKu{1},...
    'Color','w',...
    'FontSize', fs);
xlabel('anode lithiation x'); ylabel('OCP vs Li/Li^+ in V');
line(anode.Li_x, anode.ocv, 'Parent', ax1, 'Color', Colors_MKu{1}, 'LineWidth', lw);
line([anode.lith.min_used, anode.lith.max_used], [interp1(anode.Li_x, anode.ocv, anode.lith.min_used), interp1(anode.Li_x, anode.ocv, anode.lith.max_used)], 'Parent', ax1, 'LineStyle', 'none', 'Marker', 'x', 'MarkerSize', 10, 'Color', Colors_MKu{1}, 'LineWidth', lw);
xlim(anode.lith.range);
ylim(get(ax1, 'YLim'));
legend(ax1, 'Anode');
% plot cell OCV
if cell_OCV_with_anode
    ax2 = axes('Position',ax1.Position,...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'XColor', 'k',...
        'YColor', 'k',...
        'Color','none',...
        'FontSize', fs);
    xlabel('SoC in %'); ylabel('OCV in V');
    xlabh = get(gca,'xlabel'); set(xlabh, 'HorizontalAlignment', 'left'); % set(xlabh, 'VerticalAlignment', 'cap');
    line(cell.soc*100, cell.ocv, 'Parent', ax2, 'Color', 'k', 'LineWidth', lw);
    line(cell.soc_used, cell.ocv_used, 'Parent', ax2, 'Color', [0.1, 0.8, 0], 'LineStyle', '--', 'LineWidth', lw);

    ax1.YLim=[min(ax1.YLim(1), ax2.YLim(1)), max(ax1.YLim(2), ax2.YLim(2))];
    ax2.YLim=[min(ax1.YLim(1), ax2.YLim(1)), max(ax1.YLim(2), ax2.YLim(2))];
    legend('measured cell OCV', 'calculated cell OCV', 'Location', 'East');
    xlim(cell.soc_range.range);
    try
        text_handle=text(ax2, 50, interp1(cell.soc*100, cell.ocv, 50)-0.05*(ax2.YLim(2)-ax2.YLim(1)), ['RMSE: ', num2str(obj.AddInfo.RMSE*1000, '%.1f'), ' mV'], 'FontSize', fs, 'BackgroundColor', [0.9, 0.9, 0.9]);
        set(text_handle, 'VerticalAlignment', 'top')
    end
end

text(ax1, anode.lith.min_used+0.01, interp1(anode.Li_x, anode.ocv, anode.lith.min_used), [' ', num2str(round(anode.lith.min_used,3))], 'FontSize', fs, 'BackgroundColor', [0.9, 0.9, 0.9]);
text(ax1, anode.lith.max_used+0.01, interp1(anode.Li_x, anode.ocv, anode.lith.max_used), [' ', num2str(round(anode.lith.max_used,3))], 'FontSize', fs, 'BackgroundColor', [0.9, 0.9, 0.9]);
line([anode.lith.min_used, anode.lith.min_used], get(ax1, 'YLim'), 'Parent', ax1, 'LineStyle', '--', 'Color', 'k', 'LineWidth', lw);
line([anode.lith.max_used, anode.lith.max_used], get(ax1, 'YLim'), 'Parent', ax1, 'LineStyle', '--', 'Color', 'k', 'LineWidth', lw);
legend(ax1, 'anode OCP', 'Location', 'NorthEast');
end