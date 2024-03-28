function Cell_add = fcn_get_Cell_object(app,event)
%% function for creating a new cell object due to user inputs
%% init
fieldnames_app          = fieldnames(app);
if exist('event','var')
    idx_object              = cellfun(@(x) isobject(app.(x)) & ~istable(app.(x)),fieldnames_app);
    fieldnames_objects      = fieldnames_app(idx_object);
    idx_dropDown            = cell2mat(cellfun(@(x) isa(app.(x),'matlab.ui.control.DropDown') & (app.(x).Parent == event.Source.Parent), fieldnames_app(idx_object),'UniformOutput',false));
    name_dropDown_all       = fieldnames_objects(idx_dropDown);
    tab                     = event.Source.Tag;
else
    idx_dropDown            = cell2mat(cellfun(@(x) isa(app.(x),'matlab.ui.control.DropDown'), fieldnames(app),'UniformOutput',false));
    name_dropDown_all       = fieldnames_app(idx_dropDown);
    tab                     = 'CM';
end
Cell_add                    = [];
%% get name from GUI
name_Cell               = app.CellNameField.Value;
if contains(name_Cell, 'e.g.') || isempty(name_Cell)
    app.nameField.FontColor                 = [1 0 0];
    app.nameField.FontWeight                = 'bold';
    app.nameField.FontSize                  = 14;
    app.nameField.Value                     = 'NAME';
    return;
end
%% get electrode stack of the cell from GUI
name_dropDown                               = name_dropDown_all(contains(name_dropDown_all, 'ElectrodeStack') & contains(name_dropDown_all, tab));
Electrode_Stack                             = app.(cell2mat(name_dropDown)).Value;
load([app.path_database,'\ElectrodeStacks\',Electrode_Stack,'.mat'])
Electrode_Stack=eval(Electrode_Stack);
%% get housing of the cell from GUI
name_dropDown                               = name_dropDown_all(contains(name_dropDown_all, 'Housing') & contains(name_dropDown_all, tab));
Housing                                     = app.(cell2mat(name_dropDown)).Value;
load([app.path_database,'\Housings\',Housing,'.mat'])
Housing=eval(Housing);
%% get separator of the electrode stack from GUI
if app.(['standard' tab 'Button']).Value
    CreationMode                                = 'std';
elseif app.(['fitHousing' tab 'Button']).Value
    CreationMode                                = 'FitStackToHousing';
elseif app.(['fitCapacity' tab 'Button']).Value
    CreationMode                                = 'FitCellToCapacity';
    TargetCapacity                              = app.(join(['TargetCapacity', tab ,'Field'])).Value;
end
%% get electrode stack object
try
    if exist('TargetCapacity','var')
       Cell_add                                     = Cell(name_Cell, Electrode_Stack, Housing,CreationMode,TargetCapacity); 
    else
       Cell_add                                     = Cell(name_Cell, Electrode_Stack, Housing,CreationMode); 
    end
catch ME
    msgbox(ME.message,'Error in create cell object', 'error');
    return;
end
%% get remaining attributes
%source
source                                      = string(app.sourceField.Value);
Cell_add                                    = SetProperty(Cell_add, 'Source',source);
%confidential
confidential                                = string(app.DropDownConfidential.Value); 
Cell_add                                    = SetProperty(Cell_add, 'Confidential',confidential);
end