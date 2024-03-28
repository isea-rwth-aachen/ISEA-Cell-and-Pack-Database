function fcn_batteryID_pdf(xmlstruct)
%% PDF Layout
%Create figure
figure1=figure; %figure1 corresponds to the complete PDF which is generated at the end of this script
set(figure1,'Name','BatteryID','NumberTitle','off'); figure1.Units='centimeters';
figure1.Visible='off';
figure1.PaperUnits='centimeters';
figure1.PaperSize=[21,29.7];
figure1.OuterPosition=[0,0,21,29.7];
figure1.Position=[0,0,21,29.7]; 
figure1.InnerPosition=[0,0,21,29.7];
figure1.PaperPositionMode='manual';
figure1.PaperPosition=[0,0,21,29.7];
figure1.Color=[0.9,0.9,0.9];
figure1.Resize='off'; 
%% Balken rechts
ax1=axes(figure1);
ax1.YAxis.Visible='off';
ax1.XAxis.Visible='off';
ax1.Position=[0,0,1,1];
p1=patch(ax1,'XData',[0.66,0.66,1,1],'YData',[0,1,1,0]); 
p1.FaceColor=[0.78,0.83,0.95]; %RWTH light blue
p1.EdgeColor=[0.78,0.83,0.95];
ax1.XLim=[0,1];
ax1.YLim=[0,1];
hold(ax1,'on')
set(gca, 'visible', 'off');
%% Balken oben
x1 = 0:0.001:1;
y1 = -0.2*(x1-0.5).^2+0.925;
p2=patch([0,x1,1],[1,y1,1],[0,0.33,0.62]);
p2.FaceColor=[0,0.33,0.62]; %RWTH blue
p2.EdgeColor=[0,0.33,0.62];
pause(0.1); %having a break to create the figure
%% create Textboxen
% headline
topborder=figure1.Position(4)-figure1.Position(2);
anno1=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String','\bf\underline{BatteryID}',...
    'Color',[1,1,1],'FontWeight','bold','EdgeColor','none','FitBoxToText','on','Interpreter','latex','FontSize',14);
anno1.Units='centimeters';
anno1.Position=[8,topborder-1.5,1,1];
anno1.FitBoxToText='on';
anno1.Position=[21/2-anno1.Position(3)/2, anno1.Position(2), anno1.Position(3),anno1.Position(4)];
anno1a=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Document Number: ',xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text],...
    'Color',[1,1,1],'FontWeight','bold','EdgeColor','none');
anno1a.Units='centimeters';
anno1a.Position=[16,topborder-1,1,1];
anno1a.FitBoxToText='on';
anno1b=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Prepared by: ',xmlstruct.BatteryID.GeneralInformation.MetaData.PreparedBy.Text],...
    'Color',[1,1,1],'FontWeight','bold','EdgeColor','none');
anno1b.Units='centimeters';
anno1b.Position=[16,topborder-1.5,1,1];
anno1b.FitBoxToText='on';
anno1c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Prepared on: ',xmlstruct.BatteryID.GeneralInformation.MetaData.DatePrepared.Text],...
    'Color',[1,1,1],'FontWeight','bold','EdgeColor','none');
anno1c.Units='centimeters';
anno1c.Position=[16,topborder-2,1,1];
anno1c.FitBoxToText='on';
% General Information
anno2=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String','\bf\underline{General information:}',...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none','FitBoxToText','on','Interpreter','latex','FontSize',14);
anno2.Units='centimeters';
anno2.Position=[0.5,topborder-4.75,1,1];
anno2.FitBoxToText='on';
% Meta Data
anno2a=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String','\bf\underline{Meta Data:}',...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none','FitBoxToText','on','Interpreter','latex','FontSize',11);
anno2a.Units='centimeters';
anno2a.Position=[0.5,topborder-5.55,1,1];
anno2a.FitBoxToText='on';
anno3=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Battery Name: ',xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryName.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno3.Units='centimeters';
anno3.Position=[0.5,topborder-6,1,1];
anno3.FitBoxToText='on';
anno4=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Battery Identifier: ',xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryIdentifier.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno4.Units='centimeters';
anno4.Position=[0.5,topborder-6.5,1,1];
anno4.FitBoxToText='on';
anno5=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Battery Type: ',xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryType.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno5.Units='centimeters';
anno5.Position=[0.5,topborder-7,1,1];
anno5.FitBoxToText='on';
anno7=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Brand: ',xmlstruct.BatteryID.GeneralInformation.MetaData.Brand.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno7.Units='centimeters';
anno7.Position=[0.5,topborder-7.5,1,1];
anno7.FitBoxToText='on';
anno8=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Classification: ',xmlstruct.BatteryID.GeneralInformation.MetaData.ClassificationCell.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno8.Units='centimeters';
anno8.Position=[0.5,topborder-8,1,1];
anno8.FitBoxToText='on';
anno9=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Keywords: ',xmlstruct.BatteryID.GeneralInformation.MetaData.Keywords.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno9.Units='centimeters';
anno9.Position=[0.5,topborder-8.5,1,1];
anno9.FitBoxToText='on';
% Mechanical Parameters
anno9a=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String','\bf\underline{Mechanical Parameters:}',...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none','FitBoxToText','on','Interpreter','latex','FontSize',11);
anno9a.Units='centimeters';
anno9a.Position=[0.5,topborder-9.55,1,1];
anno9a.FitBoxToText='on';
anno10=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Housing Style: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno10.Units='centimeters';
anno10.Position=[0.5,topborder-10,1,1];
anno10.FitBoxToText='on';
anno11=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Weight: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Weight.Value.Text,' g'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno11.Units='centimeters';
anno11.Position=[0.5,topborder-10.5,1,1];
anno11.FitBoxToText='on';
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Prismatic')
    anno12=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Thickness: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPrismatic.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno12.Units='centimeters';
    anno12.Position=[0.5,topborder-11,1,1];
    anno12.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Prismatic')
    anno13=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Width: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPrismatic.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno13.Units='centimeters';
    anno13.Position=[0.5,topborder-11.5,1,1];
    anno13.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Prismatic')
    anno14=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Length: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPrismatic.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno14.Units='centimeters';
    anno14.Position=[0.5,topborder-12,1,1];
    anno14.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Pouch')
    anno12=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Thickness: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPouch.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno12.Units='centimeters';
    anno12.Position=[0.5,topborder-11,1,1];
    anno12.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Pouch')
    anno13=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Width: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPouch.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno13.Units='centimeters';
    anno13.Position=[0.5,topborder-11.5,1,1];
    anno13.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Pouch')
    anno14=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Length: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPouch.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno14.Units='centimeters';
    anno14.Position=[0.5,topborder-12,1,1];
    anno14.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Cylindric')
    anno12=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Radius: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.RadiusCylindric.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno12.Units='centimeters';
    anno12.Position=[0.5,topborder-11,1,1];
    anno12.FitBoxToText='on';
end
if strcmp(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text,'Cylindric')
    anno13=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Length: ',xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthCylindric.Text,' mm'],...
        'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
    anno13.Units='centimeters';
    anno13.Position=[0.5,topborder-11.5,1,1];
    anno13.FitBoxToText='on';
end
% Chemical Paramters
anno9b=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String','\bf\underline{Chemical Parameters:}',...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none','FitBoxToText','on','Interpreter','latex','FontSize',11);
anno9b.Units='centimeters';
anno9b.Position=[6,topborder-9.55,1,1];
anno9b.FitBoxToText='on';
anno10b=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Anode Material: ',xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrodeMaterials.Anode.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno10b.Units='centimeters';
anno10b.Position=[6,topborder-10,1,1];
anno10b.FitBoxToText='on';
anno11b=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Cathode Material: ',xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrodeMaterials.Cathode.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno11b.Units='centimeters';
anno11b.Position=[6,topborder-10.5,1,1];
anno11b.FitBoxToText='on';
anno12b=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Separator Material: ',xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.SeparatorMaterial.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno12b.Units='centimeters';
anno12b.Position=[6,topborder-11,1,1];
anno12b.FitBoxToText='on';
anno13b=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Electrolyte Material: ',xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrolyteMaterial.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno13b.Units='centimeters';
anno13b.Position=[6,topborder-11.5,1,1];
anno13b.FitBoxToText='on';
% Electrical Parameters
anno2c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String','\bf\underline{Electrical Parameters:}',...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none','FitBoxToText','on','Interpreter','latex','FontSize',11);
anno2c.Units='centimeters';
anno2c.Position=[12,topborder-5.55,1,1];
anno2c.FitBoxToText='on';
anno3c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Nominal Capacity: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCapacity.Value.Text,' Ah'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno3c.Units='centimeters';
anno3c.Position=[12,topborder-6,1,1];
anno3c.FitBoxToText='on';
anno4c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Nominal Cell Voltage: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCellVoltage.Value.Text,' V'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno4c.Units='centimeters';
anno4c.Position=[12,topborder-6.5,1,1];
anno4c.FitBoxToText='on';
anno5c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Charge Current (cont.): ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentCont.Value.Text,' A'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno5c.Units='centimeters';
anno5c.Position=[12,topborder-7,1,1];
anno5c.FitBoxToText='on';
anno7c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Discharge Current (cont.): ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentCont.Value.Text,' A'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno7c.Units='centimeters';
anno7c.Position=[12,topborder-7.5,1,1];
anno7c.FitBoxToText='on';
anno8c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Charge Current (pulse): ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulse.Value.Text,' A'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno8c.Units='centimeters';
anno8c.Position=[12,topborder-8,1,1];
anno8c.FitBoxToText='on';
anno9c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Discharge Current (pulse): ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulse.Value.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno9c.Units='centimeters';
anno9c.Position=[12,topborder-8.5,1,1];
anno9c.FitBoxToText='on';
anno6c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Charge Current Pulse Duration: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulseDuration.Value.Text,' s'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno6c.Units='centimeters';
anno6c.Position=[12,topborder-9,1,1];
anno6c.FitBoxToText='on';
anno10c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Discharge Current Pulse Duration: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulseDuration.Value.Text,' s'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno10c.Units='centimeters';
anno10c.Position=[12,topborder-9.5,1,1];
anno10c.FitBoxToText='on';
anno11c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['End of Charge Voltage: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeVoltage.Value.Text,' V'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno11c.Units='centimeters';
anno11c.Position=[12,topborder-10,1,1];
anno11c.FitBoxToText='on';
anno12c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['End of Discharge Voltage: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfDischargeVoltage.Value.Text,' V'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno12c.Units='centimeters';
anno12c.Position=[12,topborder-10.5,1,1];
anno12c.FitBoxToText='on';
anno13c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['End of Charge Current: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeCurrent.Value.Text,' A'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno13c.Units='centimeters';
anno13c.Position=[12,topborder-11,1,1];
anno13c.FitBoxToText='on';
anno14c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Gravimetric Energy Density: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Value.Text,' Wh/kg'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno14c.Units='centimeters';
anno14c.Position=[12,topborder-11.5,1,1];
anno14c.FitBoxToText='on';
anno15c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Volumetric Energy Density: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Value.Text,' Wh/l'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno15c.Units='centimeters';
anno15c.Position=[12,topborder-12,1,1];
anno15c.FitBoxToText='on';
anno16c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Gravimetric Puls Power Density: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricPowerDensityPulse.Value.Text,' W/kg'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno16c.Units='centimeters';
anno16c.Position=[12,topborder-12.5,1,1];
anno16c.FitBoxToText='on';
anno17c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Max Operation Temperature Charging: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureCharge.Value.Text,' °C'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno17c.Units='centimeters';
anno17c.Position=[12,topborder-13,1,1];
anno17c.FitBoxToText='on';
anno18c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Min Operation Temperature Charging: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureCharge.Value.Text,' °C'],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno18c.Units='centimeters';
anno18c.Position=[12,topborder-13.5,1,1];
anno18c.FitBoxToText='on';
anno19c=annotation(figure1,'textbox',[0.05,0.65,0.3,0.1],'String',['Average Cycle Durability: ',xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.AverageCycleDurability.Value.Text],...
    'Color',[0,0,0],'FontWeight','bold','EdgeColor','none');
anno19c.Units='centimeters';
anno19c.Position=[12,topborder-14,1,1];
anno19c.FitBoxToText='on';

%% Plots:
% create spiderplot
D1 = [0.179, 0.34905, 48.3,  4.6, 0.93, 4.2, 5.0, 0.5]; %Kokam %ToDo
P = D1;
figure_export.data.s2.P=P; %necessary to be able to export the plot later on
axi3=axes('Units','centimeters','position',[14.7,6,5,5]); %spiderwebdiagram properties
spider_plot_R2019b(P,...
    'AxesLabels', {'A', 'B', 'C', 'D',...
    'E','F', 'G','H'},... %Axes Labels
    'AxesInterval', 3,...
    'AxesPrecision', 1,...
    'AxesDisplay', 'all',...
    'AxesLimits', [ 0 0 0 0 0 0 0 0; 0.4 0.8 80 10 1 10 10 1],...
    'FillOption', 'on',...
    'FillTransparency', 0.2,...
    'Color', [0, 0.33, 0.62],... %RWTH blue
    'LineStyle', '-',...
    'LineWidth', 3,...
    'AxesFont', 'Arial',...
    'LabelFont', 'Arial',...
    'AxesFontSize', 8,...
    'LabelFontSize', 10,...
    'Direction', 'clockwise',...
    'AxesDirection', {'normal', 'normal', 'normal', 'normal', 'normal','normal','normal','normal'},...
    'AxesLabelsOffset', 0.25,...
    'AxesColor', [0.6, 0.6, 0.6],...
    'AxesLabelsEdge', 'none',...
    'AxesScaling', 'linear',...
    'AxesOffset', 1,...
    'AxesZoom', 1,...
    'AxesHorzAlign', 'quadrant',...
    'AxesVertAlign', 'quadrant');
xlim([-0.99 1.01])
ylim([-0.97 1.03])

% create meshgridplot:
if isfield(xmlstruct.BatteryID.ModelLevel.ElectricalModel,'ISEA_R2RC')
eval(['R_i_vec=[',xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R2RC.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.LookupData.Text,'];'])
eval(['soc_vec=[',xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R2RC.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.MeasurementPointsRow.Text,'];'])
eval(['temp_vec=[',xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R2RC.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.MeasurementPointsColumn.Text,'];'])
axi2=axes('Units','centimeters','position',[1.25,6,5,5],'Color',[0.9,0.9,0.9]);
s1=surfl(soc_vec,temp_vec,R_i_vec);
axi2.XLabel.String='SOC in %';
axi2.YLabel.String='T in °C';
axi2.ZLabel.String='R_i in \Omega';
axi2.YAxis.Direction='reverse';

figure_export.data.s1.x=soc_vec; %necessary to be able to export the plot later on
figure_export.data.s1.y=temp_vec;
figure_export.data.s1.z=R_i_vec;
end

%% create OCV:
if isfield(xmlstruct.BatteryID.ModelLevel.ElectricalModel,'ISEA_R2RC')
eval(['volt_vec=[',xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R2RC.Configuration.CustomDefinitions.MyOCV.Object.LookupData.Text,'];'])
eval(['soc_vec=[',xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R2RC.Configuration.CustomDefinitions.MyOCV.Object.MeasurementPointsRow.Text,'];'])
legend_values=str2num(xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R2RC.Configuration.CustomDefinitions.MyOCV.Object.MeasurementPointsColumn.Text);
axi4=axes('Units','centimeters','position',[8,6,5,5],'Color',[0.9,0.9,0.9]);
figure_export.data.s3.X=soc_vec; %necessary to be able to export the plot later on
figure_export.data.s3.Y=volt_vec;
plot(soc_vec,volt_vec,'LineWidth',3); %RWTH blue
axi4.Box='on';
axi4.XGrid='on';
axi4.XMinorGrid='on';
axi4.YGrid='on';
axi4.YMinorGrid='on';
axi4.XLabel.String='State of charge in %'; %x-axis labeling
axi4.YLabel.String='Open Circuit Voltage in V'; %y-axis labeling
axi4.XLim=[0,100];
leg1=legend(axi4,num2str(legend_values(:)));
leg1.Location='southeast';
end
%% Battery Geometry 3D - cylinder  patch function, cylindrical format
axi5=axes('Units','centimeters','Position',[0.5,topborder-3,2.5,2.5],'Color','none','XColor','none','YColor','none','ZColor','none','GridColor','none',...
    'MinorGridColor',[0 0 0]);% axis adjustment to make them "invisible" and so that the figure does not disappear.
fcn_plot_Housings_pdf(xmlstruct,axi5)
print(figure1,['BatteryID_',xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryName.Text,'_',xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text,'.pdf'],'-dpdf','-bestfit','-painters');
close all
end