function xmlstruct = fcn_init_batteryID(varargin)
clearvars -except varargin
close all
%% General Information
xmlstruct=[];
%% Meta Data
xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryName.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryIdentifier.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.BatteryType.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.DocumentNumber.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.Keywords.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.Brand.Text='Virtual';
xmlstruct.BatteryID.GeneralInformation.MetaData.IECDesignation.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.PreparedBy.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.DatePrepared.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MetaData.ClassificationCell.Text='Default';
%% Mechanical Parameters
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Weight.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Weight.Unit.Text='g';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPrismatic.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPrismatic.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPrismatic.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPrismatic.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPrismatic.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPrismatic.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPouch.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPouch.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPouch.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPouch.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPouch.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPouch.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.RadiusCylindric.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.RadiusCylindric.Unit.Text='mm';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthCylindric.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthCylindric.Unit.Text='mm';
%% Electrical Parameters
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCapacity.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCapacity.Unit.Text='Ah';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCellVoltage.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCellVoltage.Unit.Text='V';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentCont.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentCont.Unit.Text='A';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentCont.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentCont.Unit.Text='A';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulse.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulse.Unit.Text='A';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulse.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulse.Unit.Text='A';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulseDuration.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxChargeCurrentPulseDuration.Unit.Text='s';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulseDuration.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxDischargeCurrentPulseDuration.Unit.Text='s';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeVoltage.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeVoltage.Unit.Text='V';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeCurrent.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfChargeCurrent.Unit.Text='A';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfDischargeVoltage.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.EndOfDischargeVoltage.Unit.Text='V';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Unit.Text='Wh/kg';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Unit.Text='Wh/l';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricPowerDensityPulse.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricPowerDensityPulse.Unit.Text='W/kg';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureCharge.Unit.Text='°C';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureCharge.Unit.Text='°C';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureDisCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MaxOperationTemperatureDisCharge.Unit.Text='°C';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureDisCharge.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.MinOperationTemperatureDisCharge.Unit.Text='°C';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.AverageCycleDurability.Value.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.AverageCycleDurability.Unit.Text='EFC';
%% Chemical Parameters
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrodeMaterials.Anode.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrodeMaterials.Cathode.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.SeparatorMaterial.Text='Default';
xmlstruct.BatteryID.GeneralInformation.ChemicalParameters.BatteryChemistry.ElectrolyteMaterial.Text='Default';
%% Performance Paramter
xmlstruct.BatteryID.PerformanceParameter.Capacity.Value.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCapacity.Value.Text;
xmlstruct.BatteryID.PerformanceParameter.Capacity.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCapacity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Theory.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Theory.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Material.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Material.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Cell.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Cell.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Module.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.GravimetricEnergyDensities.Module.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.GravimetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Theory.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Theory.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Material.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Material.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Cell.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Cell.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Module.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.VolumetricEnergyDensities.Module.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.VolumetricEnergyDensity.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.NominalVoltage.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.NominalVoltage.Unit.Text=xmlstruct.BatteryID.GeneralInformation.ElectricalParameters.NominalCellVoltage.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.CellDesign.Volume.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.CellDesign.Volume.Unit.Text='cm³';
xmlstruct.BatteryID.PerformanceParameter.CellDesign.Weight.Value.Text=xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Weight.Value.Text;
xmlstruct.BatteryID.PerformanceParameter.CellDesign.Weight.Unit.Text=xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Weight.Unit.Text;
xmlstruct.BatteryID.PerformanceParameter.CellDesign.PowerToEnergyRatio.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.CellDesign.SafetyMeasures.FunctionalSafety.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.CellDesign.SafetyMeasures.EletricalSafety.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.CellDesign.SafetyMeasures.ChemicalSafety.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.CellDesign.SafetyMeasures.MechanicalSafety.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.SOHc.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.SOHc.Unit.Text='%';
xmlstruct.BatteryID.PerformanceParameter.LifeState.SOHr.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.SOHr.Unit.Text='%';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageTemperature.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageTemperature.Unit.Text='°C';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageSOC.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageSOC.Unit.Text='%';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageDOD.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageDOD.Unit.Text='%';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageCurrent.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.AverageCurrent.Unit.Text='A';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.DurationDays.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.DurationDays.Unit.Text='days';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.DurationFullCycles.Value.Text='Default';
xmlstruct.BatteryID.PerformanceParameter.LifeState.History.DurationFullCycles.Unit.Text='s';
%% Cost Parameters
xmlstruct.BatteryID.CostParameter.CostRawMaterial.Value.Text='Default';
xmlstruct.BatteryID.CostParameter.CostRawMaterial.Unit.Text='€/kWh';
xmlstruct.BatteryID.CostParameter.EnergySpecificCostCell.Value.Text='Default';
xmlstruct.BatteryID.CostParameter.EnergySpecificCostCell.Unit.Text='€/kWh';
xmlstruct.BatteryID.CostParameter.PowerSpecificCostCell.Value.Text='Default';
xmlstruct.BatteryID.CostParameter.PowerSpecificCostCell.Unit.Text='€/kW';
xmlstruct.BatteryID.CostParameter.CostInvest.Value.Text='Default';
xmlstruct.BatteryID.CostParameter.CostInvest.Unit.Text='mio. €';
%% Model Level
%% Electrical Models
xmlstruct.BatteryID.ModelLevel.ElectricalModel.Text='Default';
%% Thermal Models
xmlstruct.BatteryID.ModelLevel.ThermalModel.HeatCapacity.Text='Default';
xmlstruct.BatteryID.ModelLevel.ThermalModel.HeatConductivity.Text='Default';
%% Ageing Models
xmlstruct.BatteryID.ModelLevel.AgeingModel.SemiEmpiricalModel.AgeingFactorCyclic.CyclicSOHc.Text='Default';
xmlstruct.BatteryID.ModelLevel.AgeingModel.SemiEmpiricalModel.AgeingFactorCyclic.CyclicSOHr.Text='Default';
xmlstruct.BatteryID.ModelLevel.AgeingModel.SemiEmpiricalModel.AgeingFactorCalendaric.CalendaricSOHc.Text='Default';
xmlstruct.BatteryID.ModelLevel.AgeingModel.SemiEmpiricalModel.AgeingFactorCalendaric.CalendaricSOHr.Text='Default';
%% PhysicoChemical Models
xmlstruct.BatteryID.ModelLevel.PhysicoChemicalModel.Text='Default';
if nargin==1
    struct2xml(xmlstruct,[varargin{:}]);
else
    struct2xml(xmlstruct,'Test.xml');
end