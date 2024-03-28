function clb_change_CreationMode_Cell(app,event)
%% callback function for changing the creation mode of a new cell
%% get radio buttons
source_buttons      = event.Source.Buttons;
target_tab          = event.Source.Tag;
names_buttons       = arrayfun(@(x) source_buttons(x).Text,(1:numel(source_buttons)),'UniformOutput',false);
idx_fitCapacity     = strcmpi('fit cell to capacity', names_buttons);
if ~source_buttons(idx_fitCapacity).Value
    mode             = 0;
else
    mode             = 1;
end
%% get edit fields
idx_editField           = cell2mat(cellfun(@(x) isa(app.(x),'matlab.ui.control.NumericEditField'), fieldnames(app),'UniformOutput',false));
name_Fields             = fieldnames(app);
name_editFields_all     = name_Fields(idx_editField);
name_TargetCapacity     = name_editFields_all(contains(name_editFields_all, strcat('TargetCapacity',target_tab)));
%% make edit field and label visible
app.(char(name_TargetCapacity)).Enable  = mode;
name_label                              = strrep(name_TargetCapacity,'Field','Label');
app.(char(name_label)).Enable           = mode;
end