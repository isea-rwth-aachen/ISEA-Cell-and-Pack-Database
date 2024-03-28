classdef Arrhenius
    %Includes all parameters to form a complete Arrhenius function
    properties
        ReferenceTemperature double     %in °K
        ActivationEnergy double         %in kJ/mol
        Expression
        Type string = ''
        Name string = ''
    end
    %% Methods
    methods
        function obj = Arrhenius(Name,Expression,Type,ActivationEnergy,ReferenceTemperature)
            if exist('Name','var') && ~isempty(Name) && ischar(Name)
                obj.Name                    = Name;
            else
                obj.Name                    = 'Temp';
            end
            if ~exist('ActivationEnergy','var')
                ActivationEnergy        = 0;
            end
            if ~exist('ReferenceTemperature', 'var')
                ReferenceTemperature    = 298.15;
            end
            if ~exist('Type','var')
                Type                    = 'none';
            end
            switch Type
                case 'Scalar'
                    if ~isnumeric(Expression)
                        if ~isnan(str2double(Expression))
                            obj.Expression              = str2double(Expression);
                        else
                            return;
                        end
                    elseif isnumeric(Expression)
                            obj.Expression              = Expression;
                    else
                        return;
                    end
                    obj.Type                    = 'Scalar';
                    obj.ActivationEnergy        = ActivationEnergy;
                    obj.ReferenceTemperature    = 298.15; %25°C
                case 'Function'
                    obj.Expression              = Expression;
                    obj.Type                    = 'Function';
                    obj.ActivationEnergy        = ActivationEnergy;
                    obj.ReferenceTemperature    = ReferenceTemperature;
                case 'Interpolation-2D'
                    if isstruct(Expression) && isfield(Expression, 'X_Value') && isfield(Expression, 'Y_Value')
                        if length(Expression.X_Value) ~= length(Expression.Y_Value)
                            return;
                        end
                        obj.Expression              = Expression;
                    else
                        return;
                    end
                    obj.Type                    = 'Interpolation-2D';
                    obj.ActivationEnergy        = ActivationEnergy;
                    obj.ReferenceTemperature    = ReferenceTemperature;
                case 'Interpolation-ExpBase'
                    if isstruct(Expression) && isfield(Expression, 'X_Value') && isfield(Expression, 'Y_Value') && isfield(Expression, 'Base')
                        if length(Expression.X_Value) ~= length(Expression.Y_Value) || isempty(Expression.Base) 
                            return;
                        end
                        obj.Expression              = Expression;
                    else
                        return;
                    end
                    obj.Type                    = 'Interpolation-ExpBase';
                    obj.ActivationEnergy        = ActivationEnergy;
                    obj.ReferenceTemperature    = ReferenceTemperature;
                case 'Spline'
                    if isstruct(Expression) && isfield(Expression, 'X_Value') && isfield(Expression, 'Coefs')
                        if length(Expression.X_Value) ~= length(Expression.Coefs)
                            return;
                        end
                        obj.Expression              = Expression;
                    else
                        return;
                    end
                    obj.Type                    = 'Spline';
                    obj.ActivationEnergy        = ActivationEnergy;
                    obj.ReferenceTemperature    = ReferenceTemperature;
                otherwise
                    obj.Expression              = [];
                    obj.Type                    = 'none';
                    obj.ActivationEnergy        = [];
                    obj.ReferenceTemperature    = [];
            end
        end
        % get function
        function output = GetProperty(obj, property)
            if isprop(obj,property)
                output = obj.(property);
            else
               warning([property,' is not a Property of class Arrhenius return 0']);
               output = 0;
            end
        end
        % set function
        function obj = SetProperty(obj,property,value)
            if isprop(obj,property)
                obj.(property) = value; 
            else
               error([property,' is not a Property of class Arrhenius']); 
            end
        end
        % function to generate parameter file (yml) of DFN parameters
        function output_struct = GetYMLOutputStruct(obj)
            output_struct   = [];
           switch obj.Type
               case 'Spline'
                   output_struct.Spline.X_Value         = obj.Expression.X_Value;
                   output_struct.Spline.Coefs           = obj.Expression.Coefs;
               case 'Interpolation-ExpBase'
                   output_struct.Interpolation.X_Value              = obj.Expression.X_Value;
                   output_struct.Interpolation.Y_Value              = obj.Expression.Y_Value;
                   output_struct.Interpolation.ExponentialBase      = obj.Expression.Base;
               case 'Interpolation-2D'
                   output_struct.Interpolation.X_Value  = obj.Expression.X_Value;
                   output_struct.Interpolation.Y_Value  = obj.Expression.Y_Value;
               case 'Scalar'
                   output_struct.Expression             = obj.Expression;
               case 'Function'
                   %case sensitive due to older version
                   if isstruct(obj.Expression)
                        output_struct.Expression             = obj.Expression.function;
                   else
                       output_struct.Expression             = obj.Expression;
                   end
               otherwise
                   return;
           end
           output_struct.ActivationEnergy       = obj.ActivationEnergy * 1000; % in J/mol
           output_struct.ReferenceTemperature   = obj.ReferenceTemperature;
        end
        % function to vary Arrhenius object properties in parameter
        % variations
        function [obj,nominale_value] = VarieArrheniusObject(obj,new_value)
            switch obj.Type
                case 'Spline'
                   output_struct.Spline.X_Value         = obj.Expression.X_Value;
                   output_struct.Spline.Coefs           = obj.Expression.Coefs;
                case 'Interpolation-ExpBase'
                   x_values                             = obj.Expression.X_Value;
                   y_values                             = obj.Expression.Y_Value;
                   exp_base                             = obj.Expression.Base;
                   nominale_value                       = exp_base^(interp1(x_values,y_values,median(x_values)));
                   relative_change                      = new_value / nominale_value;
                   new_y_values                         = log10(exp_base.^(y_values) .* relative_change) ./ log10(exp_base);
                   obj.Expression.Y_Value               = new_y_values;
                case 'Interpolation-2D'
                   x_values                             = obj.Expression.X_Value;
                   y_values                             = obj.Expression.Y_Value;
                   nominale_value                       = interp1(x_values,y_values,median(x_values));
                   relative_change                      = new_value / nominale_value;
                   new_y_values                         = y_values * relative_change;
                   obj.Expression.Y_Value               = new_y_values;
                case 'Scalar'
                   nominale_value                       = obj.Expression;
                   obj.Expression                       = new_value;
                case 'Function'
                    if isfield(obj.Expression,'create_function') && isfield(obj.Expression,'y') && isfield(obj.Expression,'x') && isfield(obj.Expression,'exponents')
                        f_handel                            = obj.Expression.create_function;
                        nominale_value                      = interp1(obj.Expression.y,obj.Expression.x,median(obj.Expression.y),'spline');
                        relative_change                     = new_value / nominale_value;
                        new_x_values                        = obj.Expression.x * relative_change;
                        new_function                        = f_handel(obj.Expression.y,new_x_values,obj.Expression.exponents);
                        obj.Expression.function             = strjoin(arrayfun(@(x) [num2str(new_function(x)) '*x^' num2str(numel(obj.Expression.exponents)-x)],(1:numel(new_function)), 'UniformOutput',false),'+');
                        obj.Expression.x                    = new_x_values;
                    else
                        warning('Now x,y,creation function and exponents specified at the Expression of the arrhenius object. Can not varie the arrhenius object of type function.');
                        nominale_value                      = NaN;
                    end
                otherwise
                   return;
            end
        end
        % overload compare operator
        function logical = eq(A,B) 
           name_A           = GetProperty(A,'Name');
           name_B           = arrayfun(@(x) convertStringsToChars(GetProperty(B(x),'Name')),(1:numel(B)),'UniformOutput', false);
           logical          = strcmp(name_A,name_B);
        end
    end
end