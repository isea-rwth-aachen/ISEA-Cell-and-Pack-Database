function clb_exportBatteryID(app,event)
basefolder=cd;
batteryID_template_path=[basefolder,'\src\util\batteryID\Templates\emptyID.xml'];
battery = app.CellExportDropDown.Value;
fcn_import_ICPD_batteryID(app,batteryID_template_path,battery);
end
