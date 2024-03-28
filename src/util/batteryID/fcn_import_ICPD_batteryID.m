function fcn_import_ICPD_batteryID(app,batteryID_template_path,ICPD_model)
addpath('Classes\');
xmlstruct=xml2struct(batteryID_template_path);
basefolder=cd;
xmlstruct_ECM=xml2struct([basefolder,'\src\util\batteryID\Templates\electricalModel_template.xml']);
%% Meta Data
xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryName.Text=convertStringsToChars(erase(ICPD_model.Name,'Cell_'));
xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryType.Text=ICPD_model.Type;
xmlstruct.BatteryID.GeneralInformation.MetaData.PreparedBy.Text='ISEA';
xmlstruct.BatteryID.GeneralInformation.MetaData.DatePrepared.Text=char(datetime('today','Format','default'));
xmlstruct.BatteryID.GeneralInformation.MetaData.ClassificationCell.Text='virtual';
xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text='00001';
%% Mechanical Parameters
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Value.Text=ICPD_model.Housing.Type;
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Weight.Value.Text=num2str(ICPD_model.Weight);
% Switch case for cell type
switch ICPD_model.Housing.Type
    case "prismatic"
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPrismatic.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,1));
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPrismatic.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,2));
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPrismatic.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,3));
    case "pouch"
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPouch.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,1));
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPouch.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,2));
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPouch.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,3));
    case "cylindrical"
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.RadiusCylindric.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,1));
        xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthCylindric.Value.Text=num2str(ICPD_model.Housing.Dimensions(1,2));
end
%% Eletrical Parameters
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCapacity.Value.Text=num2str(ICPD_model.Capacity);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCellVoltage.Value.Text=num2str(ICPD_model.NominalVoltage);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentCont.Value.Text='Default'; % Todo
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentCont.Value.Text='Default'; % Todo
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulse.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulse.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulseDuration.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulseDuration.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeVoltage.Value.Text=num2str(ICPD_model.MaxOpenCircuitVoltageCha);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeCurrent.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfDischargeVoltage.Value.Text=num2str(ICPD_model.MinOpenCircuitVoltage);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Value.Text=num2str(ICPD_model.GravEnergyDensity);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Value.Text=num2str(ICPD_model.VolEnergyDensity);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricPowerDensityPulse.Value.Text=num2str(ICPD_model.GravPowerDensity);
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureDisCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureDisCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.AverageCycleDurability.Value.Text='Default';
%% Chemical Parameters
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrodeMaterials.Anode.Text=erase(ICPD_model.ElectrodeStack.Anode.Coating.ActiveMaterial.Abbreviation,'_Meas');
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrodeMaterials.Cathode.Text=erase(ICPD_model.ElectrodeStack.Cathode.Coating.ActiveMaterial.Abbreviation,'_Meas');
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.SeparatorMaterial.Text='PE-PP';
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrolyteMaterial.Text=ICPD_model.ElectrodeStack.Electrolyte.Name;
%% Performance Parameters
xmlstruct.BatteryID.PerformanceParameter.CellDesign.Volume.Value.Text=num2str(ICPD_model.Volume);
xmlstruct.BatteryID.PerformanceParameter.CellDesign.Weight.Value.Text=num2str(ICPD_model.Weight);
xmlstruct.BatteryID.PerformanceParameter.Capacity.Value.Text=num2str(ICPD_model.Capacity);
xmlstruct.BatteryID.PerformanceParameter.NominalVoltage.Value.Text=num2str(ICPD_model.NominalVoltage);
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Cell.Value.Text=num2str(ICPD_model.GravEnergyDensity);
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Cell.Value.Text=num2str(ICPD_model.VolEnergyDensity);
xmlstruct.BatteryID.PerformanceParameter.CellDesign.PowerToEnergyRatio.Value.Text=num2str((ICPD_model.Power/ICPD_model.Energy));
%% LifeStates
xmlstruct.BatteryID.PerformanceParameter.LifeState.SOHc.Value.Text='100';
xmlstruct.BatteryID.PerformanceParameter.LifeState.SOHr.Value.Text='100';
%% Model Level
% Electrical Model
if isfield(xmlstruct.BatteryID.ModelLevel.ElectricalModel,'Text')
    xmlstruct.BatteryID.ModelLevel.ElectricalModel=rmfield(xmlstruct.BatteryID.ModelLevel.ElectricalModel,'Text');
end
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV=xmlstruct_ECM.ISEA_R_OCV;
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.MetaData.electrical.Date.Text=xmlstruct.BatteryID.GeneralInformation.MetaData.DatePrepared.Text;
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.MetaData.electrical.CellName.Text=xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryName.Text;
%Rser
stringa=num2str(ones(1,11)*ICPD_model.InternalResistance/1000);
stringb=stringa==' ';
stringc=[0, diff(stringb)];
stringd=stringc==1;
stringa(stringd)=',';
for i=1:10
    stringa=strrep(stringa,'  ',' ');
end
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.LookupData.Text=[newline,char(9),char(9),char(9),char(9),char(9),char(9),stringa,newline,char(9),char(9),char(9),char(9),char(9),char(9)];
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.MeasurementPointsRow.Text=[newline,char(9),char(9),char(9),char(9),char(9),char(9),'0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100',newline,char(9),char(9),char(9),char(9),char(9),char(9)];
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.MeasurementPointsColumn.Text='25';
%OCV
string1=num2str(ICPD_model.OpenCircuitVoltage);
string2=string1==' ';
string3=[0,diff(string2)];
string4=string3==1;
string1(string4)=',';
for i=1:10
    string1=strrep(string1,'  ',' ');
end
stringw=num2str(ICPD_model.StateOfCharge*100);
stringx=stringw==' ';
stringy=[0, diff(stringx)];
stringz=stringy==1;
stringw(stringz)=',';
for i=1:10
    stringw=strrep(stringw,'  ',' ');
end
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOCV.Object.LookupData.Text=[newline,char(9),char(9),char(9),char(9),char(9),char(9),string1,newline,char(9),char(9),char(9),char(9),char(9),char(9)];
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOCV.Object.MeasurementPointsRow.Text=[newline,char(9),char(9),char(9),char(9),char(9),char(9),stringw,newline,char(9),char(9),char(9),char(9),char(9),char(9)];
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOCV.Object.MeasurementPointsColumn.Text='25';
%Root
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyR2RC.Soc.InitialCapacity.Text=num2str(ICPD_model.Capacity);
xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyR2RC.Soc.MeasurementPoints.Text=xmlstruct.BatteryID.ModelLevel.ElectricalModel.ISEA_R_OCV.Configuration.CustomDefinitions.MyOhmicResistanceser.Object.MeasurementPointsRow.Text;
%% Abspeichern der XML
struct2xml(xmlstruct,erase(ICPD_model.Name,'Cell_')+'_'+string(xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text)+'.xml');
movefile(erase(ICPD_model.Name,'Cell_')+'_'+string(xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text)+'.xml','export/batteryID/')
if app.ExportbatteryIDasPDFCheckBox.Value
    fcn_batteryID_pdf(xmlstruct);
    movefile(['BatteryID_',xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryName.Text,'_',xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text,'.pdf'],'export/batteryID/')
end
end