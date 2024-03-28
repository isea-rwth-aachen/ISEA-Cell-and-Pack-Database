function parameter_vary_table = fcn_write_ParameterVaryTable(app,cell)
%% function for writing the parameter variation table
%% init
if ~exist('cell','var') || isempty(cell) || ~isa(cell,'Cell') || numel(cell) > 1
    parameter_vary_table = [];
    return;
end
%% init table
column_names                                = app.ParaVarTable.ColumnName;
vartypes                                    = app.vartypes_paraVarTable;
variable_units                              = app.units_vars_paraVarTable;
n_column                                    = length(column_names);
n_Cells                                     = 1;
row_names                                   = cellfun(@(x) x{1},app.id_para_to_listElement,'UniformOutput',false);
identifier_cell                             = cellfun(@(x) x{2},app.id_para_to_listElement,'UniformOutput',false);
n_rownames                                  = numel(row_names);
if numel(vartypes) ~= n_column && n_column ~= numel(variable_units)
   error('Check the name of the expected columns, the data types of the columns of the parameter variation table and the specified units of the columns of the parameter variation table!'); 
end
parameter_vary_table                                = table('Size', [n_rownames n_column], 'VariableTypes', vartypes);
parameter_vary_table.Properties.VariableNames       = column_names;
parameter_vary_table.Properties.RowNames            = row_names;
parameter_vary_table.Properties.Description         = 'This table contains all parameter to varify.';
parameter_vary_table.Properties.VariableUnits       = variable_units;
for i = 1: n_rownames
    parameter_vary_table                          = fcn_write_row_table(row_names{i},identifier_cell{i},cell,parameter_vary_table);
end
end

function table = fcn_write_row_table(rowname,identifier,cell,table)
base_value      = min(eval(strcat('cell.',identifier)));
table{rowname,"Init value"}        = base_value;
table{rowname,"min"}               = base_value;
table{rowname,"max"}               = base_value;
table{rowname,"# variations"}      = 0;
end