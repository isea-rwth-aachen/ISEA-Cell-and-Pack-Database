function n_variations_total =  fcn_update_NVariation_label(app)
%% function for updating the number of variation label at the parameter variation tab at the main tab
%% init
base_cell                   = app.CellParaVarDropDown.Value;
base_housing                = convertStringsToChars(GetProperty(base_cell.Housing,'Name'));
base_anode                  = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Anode.Coating.ActiveMaterial,'Name'));
base_cathode                = convertStringsToChars(GetProperty(base_cell.ElectrodeStack.Cathode.Coating.ActiveMaterial,'Name'));
%% parameter variation table
if ~isempty(app.ParaVarTable.Data)
    idx_is_selected             = app.ParaVarTable.Data.("Vary");
    n_variations_para           = sum(app.ParaVarTable.Data{idx_is_selected,'# variations'});
else
    n_variations_para           = 0;
end
%% housing variaton table
idx_is_selected             = app.HousingParaVarTable.Data.("Vary");
names_selected              = app.HousingParaVarTable.RowName(idx_is_selected);
is_base_selected            = ismember(base_housing,names_selected);
n_variations_housing        = nnz(idx_is_selected) - is_base_selected;
%% active material variaton table
idx_as_anode_selected       = app.ActiveMaterialParaVarTable.Data.("Is Anode");
names_anode_selected        = app.ActiveMaterialParaVarTable.RowName(idx_as_anode_selected);
is_base_anode_selected      = ismember(base_anode,names_anode_selected);
idx_as_cathode_selected     = app.ActiveMaterialParaVarTable.Data.("Is Cathode");
names_cathode_selected      = app.ActiveMaterialParaVarTable.RowName(idx_as_cathode_selected);
is_base_cathode_selected    = ismember(base_cathode,names_cathode_selected);
n_variations_Anode          = nnz(idx_as_anode_selected) - is_base_anode_selected;
n_variations_Cathode        = nnz(idx_as_cathode_selected) - is_base_cathode_selected;
%% total number of variations
n_variations_total              = n_variations_para + n_variations_housing + n_variations_Anode + n_variations_Cathode;
app.NVariationsLabel.Text       = ['Number of variations: ',num2str(n_variations_total)];
end