function clb_exportCell_MainTab(app,path)
%% callback function for button export cell pushed at the main tab
fcn_busyLamp(app,'busy','BusyMainLamp')
%% get simulation options object
app.ExportInformationTextArea.Value = {'Export information:'};
sim_options             = fcn_get_Simulationoptions_Object(app);
if ~isa(sim_options,'Simulationsoption')
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
cell                                = app.CellExportDropDown.Value;
[final_YAML_struct,para_log]        = fcn_get_yaml_struct_of_cell(app,cell,sim_options);
%% check for missing parameters
if ~isempty(para_log)
   answer                           = questdlg([num2str(size(para_log,1)) ' parameters could not be identified. For a meaningful simulation by the PCM, some of them are necessary. Do you want to add the parameters or continue the export?'],...
                                        'YAML-Export', 'Continue', 'Missing paramter');
end
%% save in chosen folder
if nargin < 2
    path = uigetdir(cd,'Select saving path folder');
    figure(app.ISEAcellpackdatabaseUIFigure);
    if ~path
        return;
    end
end
filename = fullfile(path,strcat(cell.Name, '.yml'));
yaml.WriteYaml(filename,final_YAML_struct);
fcn_busyLamp(app,'ready','BusyMainLamp');
end