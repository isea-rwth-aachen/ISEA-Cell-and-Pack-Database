function fcn_get_dropDown_items(app,dropDownName,type)
global global_cells;
name_cells              = arrayfun(@(x) convertStringsToChars(GetProperty(global_cells(x), 'Name')),(1:numel(global_cells)),'UniformOutput', false);
if iscell(dropDownName)
    dropDownName        = cell2mat(dropDownName);
end
switch type
    case 'Cell'
        app.(dropDownName).Items       = name_cells;
        app.(dropDownName).ItemsData   = global_cells;
end
end
