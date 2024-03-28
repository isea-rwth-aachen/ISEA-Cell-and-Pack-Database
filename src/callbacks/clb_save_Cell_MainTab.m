function clb_save_Cell_MainTab(app,event)
%% callback function for buttin save cell pushed at main tab
global add_Cell;
global global_cells;
global global_changedObjects;
fcn_busyLamp(app,'busy','BusyMainLamp');
add_Cell                = fcn_get_Cell_object(app,event);
%% check new cell data
name_new_Cell               = convertStringsToChars(GetProperty(add_Cell, 'Name'));
if ismember(name_new_Cell,arrayfun(@(x) convertStringsToChars((x.Name)),global_cells,'UniformOutput',false))
    msgbox('The name of the added cell already exists. Delete the existing cell with the same name or edit its attributes.','Adding new cell','help');
    fcn_busyLamp(app,'ready','BusyMainLamp');
    return;
end
%% add to global global cell array
global_cells             = [global_cells add_Cell];
global_changedObjects    = [global_changedObjects {add_Cell}];
clearvars -global add_Cell
fcn_update_CellCompareTable(app);
fcn_busyLamp(app,'ready','BusyMainLamp');
end