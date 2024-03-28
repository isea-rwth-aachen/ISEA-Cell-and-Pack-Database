function cells = fcn_get_cellVariations(app)
%% function for creating varied cells due to parameter and component variations at the parameter variation tab
%% init
global global_housings;
global global_ACMaterial;
global global_blends;
base_cell                   = app.CellParaVarDropDown.Value;
base_cell_name              = convertStringsToChars(GetProperty(base_cell,'Name'));
base_housing_name           = convertStringsToChars(GetProperty(base_cell.Housing,'Name'));
base_anode_name             = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Anode.Coating.ActiveMaterial,'Name'));
base_cathode_name           = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Cathode.Coating.ActiveMaterial,'Name'));
base_housing                = base_cell.Housing;
base_anode                  = base_cell.ElectrodeStack.Anode.Coating.ActiveMaterial;
base_cathode                = base_cell.ElectrodeStack.Cathode.Coating.ActiveMaterial;
base_electrodeStack         = base_cell.ElectrodeStack;
cells                       = [];
if ~isempty(app.ParaVarTable.StyleConfigurations) && ~isempty(app.ParaVarTable.StyleConfigurations.Target)
    removeStyle(app.ParaVarTable,1);
end
%% get housings
if ~isempty(app.HousingParaVarTable.Data) && nnz(app.HousingParaVarTable.Data.("Vary"))
    idx_is_selected                     = app.HousingParaVarTable.Data.("Vary");
    names_selected                      = app.HousingParaVarTable.RowName(idx_is_selected);
    is_base_housing_selected            = ismember(names_selected,base_housing_name);
    global_housing_names                = cellfun(@(x) convertStringsToChars(GetProperty(x,'Name')), global_housings,'UniformOutput',false);
    [~,idx_global_housing]              = ismember(names_selected(~is_base_housing_selected),global_housing_names);
    housings                            = global_housings(idx_global_housing);
else
    housings                            = [];
end
%% get active material anode
if ~isempty(app.ActiveMaterialParaVarTable.Data) && nnz(app.ActiveMaterialParaVarTable.Data.("Is Anode"))
    idx_is_selected                     = app.ActiveMaterialParaVarTable.Data.("Is Anode");
    names_selected                      = app.ActiveMaterialParaVarTable.RowName(idx_is_selected);
    is_base_anode_selected              = ismember(names_selected,base_anode_name);
    global_AcMaterials_names            = arrayfun(@(x) convertStringsToChars(GetProperty(global_ACMaterial(x),'Name')), (1:numel(global_ACMaterial)),'UniformOutput',false);
    [~,idx_global_anode]                = ismember(names_selected(~is_base_anode_selected),global_AcMaterials_names);
    if idx_global_anode == 0
        global_Blends_names                 = arrayfun(@(x) convertStringsToChars(GetProperty(global_blends(x),'Name')), (1:numel(global_blends)),'UniformOutput',false);
        [~,idx_global_anode_blend]          = ismember(names_selected(~is_base_anode_selected),global_Blends_names);
        anodes                              = global_blends(idx_global_anode_blend);
    else
        anodes                              = global_ACMaterial(idx_global_anode);
    end
else
    anodes                              = [];
end

%% get active material cathode
if ~isempty(app.ActiveMaterialParaVarTable.Data) && nnz(app.ActiveMaterialParaVarTable.Data.("Is Cathode"))
    idx_is_selected                     = app.ActiveMaterialParaVarTable.Data.("Is Cathode");
    names_selected                      = app.ActiveMaterialParaVarTable.RowName(idx_is_selected);
    is_base_cathode_selected            = ismember(names_selected,base_cathode_name);
    global_AcMaterials_names            = arrayfun(@(x) convertStringsToChars(GetProperty(global_ACMaterial(x),'Name')), (1:numel(global_ACMaterial)),'UniformOutput',false);
    [~,idx_global_anode]                = ismember(names_selected(~is_base_cathode_selected),global_AcMaterials_names);
    cathodes                            = global_ACMaterial(idx_global_anode);
else
    cathodes                            = [];
end
%% get parameter variations
if ~isempty(app.ParaVarTable.Data)
    idx_is_selected                     = app.ParaVarTable.Data.("Vary");
    parameter_names                     = app.ParaVarTable.RowName(idx_is_selected);
    min_value_para                      = app.ParaVarTable.Data{idx_is_selected,'min'};
    max_value_para                      = app.ParaVarTable.Data{idx_is_selected,'max'};
    n_variations                        = app.ParaVarTable.Data{idx_is_selected,'# variations'} - 1;
    flag_fitStack                       = app.FitStackHousingCheckBox.Value;
    flag_SurfaceCapacity                = app.HoldSurfaceCapacityCheckBox.Value;
    if flag_SurfaceCapacity
        target_SurfaceCapacity              = app.ParaVariSurfaceCapacityField.Value;
    else
        target_SurfaceCapacity              = 0;
    end
    if any(n_variations < 1)
       idx_to_less_vary                     = find(n_variations < 1);
       to_less_vary_style                   = uistyle('BackgroundColor', 'red');
       addStyle(app.ParaVarTable,to_less_vary_style,'row',idx_to_less_vary);
       return;
    end
    stepsize                            = (max_value_para - min_value_para) ./ n_variations;
    parameter                           = arrayfun(@(x) (min_value_para(x) : stepsize(x) : max_value_para(x)),(1:numel(parameter_names)), 'UniformOutput', false);
else
    parameter                           = [];
end
%% create varied cells
% copy due to varied housings
if numel(housings) > 0
    n_copys                             = numel(housings);
    temp_cells                          = arrayfun(@(x) Cell(base_cell_name,base_electrodeStack, housings{x},'FitStackToHousing'),(1:n_copys));
    temp_cells                          = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_cells(x),strcat('varHousing_',num2str(x))),(1:n_copys));
    cells                               = [cells temp_cells];
end
% copy due to varied anode
if numel(anodes)> 0
    n_copys                             = numel(anodes);
    temp_cells                          = arrayfun(@(x) copy(base_cell),(1:n_copys));
    temp_coating                        = arrayfun(@(x) GetProperty(temp_cells(x).ElectrodeStack.Anode,'Coating'),(1:n_copys));
    temp_coating                        = arrayfun(@(x) SetProperty(temp_coating(x),'ActiveMaterial',anodes(x)),(1:n_copys));
    temp_coating                        = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_coating(x),strcat('varACMaterialAnode_', num2str(x))),(1:n_copys));
    temp_coating                        = arrayfun(@(x) RefreshCalc(temp_coating(x)),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) GetProperty(temp_cells(x).ElectrodeStack,'Anode'),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) SetProperty(temp_electrode(x),'Coating',temp_coating(x)),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_electrode(x),strcat('varACMaterialAnode_', num2str(x))),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) RefreshCalc(temp_electrode(x)),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) GetProperty(temp_cells(x),'ElectrodeStack'),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) SetProperty(temp_electrode_stack(x),'Anode',temp_electrode(x)),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_electrode_stack(x),strcat('varACMaterialAnode_', num2str(x))),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) RefreshCalc(temp_electrode_stack(x)),(1:n_copys));
    temp_cells                          = arrayfun(@(x) SetProperty(temp_cells(x),'ElectrodeStack',temp_electrode_stack(x)),(1:n_copys));
    temp_cells                          = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_cells(x),strcat('varACMaterialAnode_', num2str(x))),(1:n_copys));
    temp_cells                          = arrayfun(@(x) RefreshCalc(temp_cells(x)),(1:n_copys));
    cells                               = [cells temp_cells];
    clear temp_cells temp_coating temp_electrode temp_electrode_stack
end
% copy due to varied cathode
if numel(cathodes)> 0
    n_copys                             = numel(cathodes);
    temp_cells                          = arrayfun(@(x) copy(base_cell),(1:n_copys));
    temp_coating                        = arrayfun(@(x) GetProperty(temp_cells(x).ElectrodeStack.Anode,'Coating'),(1:n_copys));
    temp_coating                        = arrayfun(@(x) SetProperty(temp_coating(x),'ActiveMaterial',cathodes(x)),(1:n_copys));
    temp_coating                        = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_coating(x),strcat('varACMaterialCathode_', num2str(x))),(1:n_copys));
    temp_coating                        = arrayfun(@(x) RefreshCalc(temp_coating(x)),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) GetProperty(temp_cells(x).ElectrodeStack,'Cathode'),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) SetProperty(temp_electrode(x),'Coating',temp_coating(x)),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_electrode(x),strcat('varACMaterialCathode_', num2str(x))),(1:n_copys));
    temp_electrode                      = arrayfun(@(x) RefreshCalc(temp_electrode(x)),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) GetProperty(temp_cells(x),'ElectrodeStack'),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) SetProperty(temp_electrode_stack(x),'Cathode',temp_electrode(x)),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_electrode_stack(x),strcat('varACMaterialCathode_', num2str(x))),(1:n_copys));
    temp_electrode_stack                = arrayfun(@(x) RefreshCalc(temp_electrode_stack(x)),(1:n_copys));
    temp_cells                          = arrayfun(@(x) SetProperty(temp_cells(x),'ElectrodeStack',temp_electrode_stack(x)),(1:n_copys));
    temp_cells                          = arrayfun(@(x) fcn_change_properties_due_to_variation(temp_cells(x),strcat('varACMaterialCathode_', num2str(x))),(1:n_copys));
    temp_cells                          = arrayfun(@(x) RefreshCalc(temp_cells(x)),(1:n_copys));
    cells                               = [cells temp_cells];
    clear temp_cells temp_coating temp_electrode temp_electrode_stack
end
% copy due to varied parameter
if numel(parameter) > 0
    n_copys                             = numel(parameter);
    temp_cells                          = arrayfun(@(x) copy(base_cell),(1:n_copys));
    [~,idx_parameter]                   = ismember(parameter_names,cellfun(@(x) x{1},app.id_para_to_listElement,'UniformOutput',false));
    id_para_to_cell                     = arrayfun(@(x) app.id_para_to_listElement{x}{2},idx_parameter,'UniformOutput',false);
    temp_cells                          = arrayfun(@(x) fcn_change_parameter_due_to_variation(temp_cells(x),parameter{x},id_para_to_cell{x},parameter_names{x},flag_fitStack,target_SurfaceCapacity),(1:n_copys),'UniformOutput',false);
    temp_cells                          = [temp_cells{:}];
    cells                               = [cells temp_cells];
end

end
function object = fcn_change_properties_due_to_variation(object,name_affix)
object      = SetProperty(object,'Name',strcat(GetProperty(object,'Name'),'_',name_affix));
object      = SetProperty(object, 'Source', 'Parameter variation');
object      = SetProperty(object, 'Confidential', 'No');
end

function objects = fcn_change_parameter_due_to_variation(base_object,parameter,id_parameter,parameter_names,flag_fitStack,target_SurfaceCapacity)
if ~exist('flag_fitStack','var')
    flag_fitStack           = false;
end
if ~exist('target_SurfaceCapacity','var')
    target_SurfaceCapacity  = 0;
end
n_variaitons        = numel(parameter);
parameter_names     = strrep(parameter_names,' ','_');
objects             = arrayfun(@(x) copy(base_object),(1:n_variaitons));
expressions         = arrayfun(@(x) ['objects(' num2str(x) ').' id_parameter ' = parameter(' num2str(x) ');'], (1:n_variaitons),'UniformOutput',false);
cellfun(@eval,expressions);
objects             = arrayfun(@(x) fcn_refreshCalc_cascaded(objects(x),id_parameter,x,parameter_names,flag_fitStack,target_SurfaceCapacity),(1:n_variaitons));
end

function cell = fcn_refreshCalc_cascaded(cell,id_parameter,id,name_para,flag_fitStack,target_SurfaceCapacity)
temp_string         = strsplit(id_parameter,'.');
% cell_elements       = temp_string(1:end-1);
cell_elements       = ['cell' temp_string];
if any(strcmp(cell_elements,'ElectrodeStack')) && target_SurfaceCapacity ~= 0
    cell.ElectrodeStack.CreationType    = 'Fit surface capacity';
end
n_paths             = numel(cell_elements);
object_name         = cell_elements{end-1};
temp_object         = RefreshCalc(eval(strjoin(cell_elements(1:end-1),'.')));
temp_object         = fcn_change_properties_due_to_variation(temp_object,strcat('varPara_',name_para,'_',num2str(id)));
prev_object         = SetProperty(eval(strjoin(cell_elements(1:end-1 -1),'.')),object_name,temp_object);
for i = 2 : n_paths - 2
   object_name      = cell_elements{end-i};
   temp_object      = RefreshCalc(prev_object);
   temp_object      = fcn_change_properties_due_to_variation(temp_object,strcat('varPara_',name_para,'_',num2str(id)));
   prev_object      = SetProperty(eval(strjoin(cell_elements(1:end-i -1),'.')),object_name,temp_object);
end
if strcmp(underlyingType(prev_object), 'Cell')
    if flag_fitStack
        cell.CreationMode                   = 'FitStackToHousing';
    end
    cell             = RefreshCalc(cell);
    cell             = fcn_change_properties_due_to_variation(cell,strcat('varPara_',name_para,'_',num2str(id)));
else
    error('Error::fcn_get_cellVariations:No cell was created at the end of the cascade. Check function!');
end
end