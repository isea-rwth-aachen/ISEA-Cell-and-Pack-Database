function [x_ps, RMSE] = FcnPatternSearch(Cell, LB_Anode_List, UB_Anode_List, LB_Cathode_List, UB_Cathode_List)

%   x: vector with optimization variables:
%       x(1): lower border for lithiation anode (A_0, Index: SOC Cell)
%       x(2): upper border for lithiation anode (A_100, Index: SOC Cell)
%       x(3): upper border for lithiation cathode (C_0)
%       x(4): lower border for lithiation cathode (C_100)

NrOfIterations = length(LB_Anode_List) * length(UB_Anode_List) * length(LB_Cathode_List) * length(UB_Cathode_List);
RMSE=NaN;
index = 1;
for index_LB_Anode=1:length(LB_Anode_List)
    for index_UB_Anode=1:length(UB_Anode_List)
        for index_LB_Cathode=1:length(LB_Cathode_List)
            for index_UB_Cathode=1:length(UB_Cathode_List)
                x_set=[LB_Anode_List(index_LB_Anode), UB_Anode_List(index_UB_Anode), UB_Cathode_List(index_UB_Cathode), LB_Cathode_List(index_LB_Cathode)];
                RMSE_set = FcnCalcDeviation(Cell, x_set);
                if isnan(RMSE)
                    RMSE=RMSE_set;
                    x_ps=x_set;
                end
                if RMSE_set < RMSE
                    RMSE=RMSE_set;
                    x_ps=x_set;
                end
                if round(index/NrOfIterations*100/2)~=round((index-1)/NrOfIterations*100/2)
                    fprintf([num2str(index), ' / ', num2str(NrOfIterations), ' -> ', num2str(round(index/NrOfIterations*100)), ' %% ',  '\n']);
                end
                index = index+1;
            end
        end
    end
end
end