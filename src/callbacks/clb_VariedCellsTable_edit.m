function clb_VariedCellsTable_edit(app,event)
%% callback function for edit varied cells table edit
%% init
global global_variedCells;
global global_cells;
base_cell_name                  = convertStringsToChars(GetProperty(app.CellParaVarDropDown.Value,'Name'));
%% delete previous style configuration
if ~isempty(app.VariedCellsTable.StyleConfigurations) && ~isempty(app.VariedCellsTable.StyleConfigurations.Target)
    removeStyle(app.VariedCellsTable,1);
end
%% check edit data and change it in the global variables
indices                         = event.Indices;
if strcmpi(app.VariedCellsTable.ColumnName{indices(2)}, 'Select')
    return;
end
newData                         = event.NewData;
oldData                         = event.PreviousData;
global_cells_names              = arrayfun(@(x) convertStringsToChars(global_cells(x).Name),(1:numel(global_cells)),'UniformOutput', false);
global_identifier               = arrayfun(@(x) convertStringsToChars(global_variedCells(x).Name),(1:numel(global_variedCells)),'UniformOutput', false);
[~,id_global]                   = ismember(oldData,global_identifier);
if id_global == 0
     msgbox('The name of the base cell cannot be changed in the parameter variation table.', 'Name change not possible', 'help');
    if isstring(oldData)
        oldData                                             = convertStringsToChars(oldData);
        app.VariedCellsTable.Data.(indices(2))(indices(1))  = {oldData};
    else
        app.VariedCellsTable.Data.(indices(2))(indices(1))  = oldData;
    end
    return;
end
new_element                     = global_variedCells(id_global);
global_identifier               = app.id_class_to_VariedCellsTable{indices(2)};
if strcmpi(app.VariedCellsTable.ColumnName{indices(2)}, 'Name') && ~strcmp(base_cell_name,oldData)
    if strcmpi(underlyingType(convertCharsToStrings(newData)),app.vartypes_VariedCellsTable{indices(2)})
        if  ismember(newData,app.VariedCellsTable.RowName) || ismember(newData,global_cells_names)%Check if the new name already exists
            msgbox('The entered name already exists. Choose another one or delete the object with the same name.', 'Name change not possible', 'help');
            if isstring(oldData)
                oldData                                        = convertStringsToChars(oldData);
                app.VariedCellsTable.Data.(indices(2))(indices(1))  = {oldData};
            else
                app.VariedCellsTable.Data.(indices(2))(indices(1))  = oldData;
            end
            return;
        end
        new_element.(global_identifier)                     = newData;
        global_variedCells(id_global)                       = new_element;
        app.VariedCellsTable.Data(indices(1),indices(2))    = {newData};
    else
        if isstring(oldData)
            oldData                                        = convertStringsToChars(oldData);
        end
        app.VariedCellsTable.Data.(indices(2))(indices(1))     = {oldData};        
    end
else
    msgbox('The edited field is calculated based on the materials of the cells. Create a new dataset with different materials to obtain a different value.', 'Edit Field', 'info');
    if isstring(oldData)
        oldData                                        = convertStringsToChars(oldData);
        app.VariedCellsTable.Data.(indices(2))(indices(1))  = {oldData};
    else
        app.VariedCellsTable.Data.(indices(2))(indices(1))  = oldData;
    end
    addStyle(app.VariedCellsTable,uistyle('BackgroundColor', 'red'), 'cell', [indices(1), numel(app.VariedCellsTable.ColumnName)]);
end
end