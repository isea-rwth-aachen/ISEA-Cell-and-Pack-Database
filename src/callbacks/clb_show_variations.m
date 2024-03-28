function clb_show_variations(app)
%% callback function for button show variations pushed at the parameter variation tab at the main tab
%% init
global global_variedCells;
fcn_busyLamp(app,'busy','BusyMainLamp');
if app.ShowvariationsButton.Value
    n_variations =  fcn_update_NVariation_label(app);
    if ~n_variations
        fcn_busyLamp(app,'ready','BusyMainLamp');
        return;
    end
    %% get variations
    global_variedCells            = fcn_get_cellVariations(app);
    if isempty(global_variedCells)
        app.ShowvariationsButton.Value       = false;
        fcn_busyLamp(app,'ready','BusyMainLamp');
        return;
    end
    %% get table
    fcn_update_variedCells_Table(app,global_variedCells);
    if isempty(app.VariedCellsTable.Data)
        fcn_busyLamp(app,'ready','BusyMainLamp');
        return;
    end
    app.ParametervariationPanel.Title           = 'Overview of the varied cells';
    app.ParaVarTable.Visible                    = false;
    app.VariedCellsTable.Visible                = true;
    % enable buttons
    app.PlotvariationsButton.Enable             = true;
    app.SaveVariationsButton.Enable             = true;
else
    app.ParametervariationPanel.Title           = 'Parameter variation';
    app.ParaVarTable.Visible                    = true;
    app.VariedCellsTable.Visible                = false;
    % disable buttons
    app.PlotvariationsButton.Enable             = false;
    app.SaveVariationsButton.Enable             = false;
end
fcn_busyLamp(app,'ready','BusyMainLamp');
end