function clb_reset_editField_style(event)
%% function to reset the style of the edit field
event.Source.FontColor                 = [0 0 0];
event.Source.FontWeight                = 'normal';
event.Source.FontSize                  = 12;
event.Source.FontName                  = 'Times New Roman';
end