classdef Element < Material

    properties
        OxidationStates double % list of oxidation states
    end
    %% Methods
    methods
        function obj = Element()
            if nargin==0
                return
            end
        end
    end
end