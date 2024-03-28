%% fcn_change_visibility_table
% Function to change the visibility of a table of the GUI
function fcn_change_visibility_table(app,table_name,type)
switch type
    case 'on'
        visible         = true;
    case 'off'
        visible         = false;
        app.(table_name).Data       = [];
end
app.(table_name).Visible    = visible;
if ~isempty(app.(table_name).Tag)
    app.(app.(table_name).Tag).Visible           = visible;
end
end