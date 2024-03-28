function [color,marker] = fcn_get_plot_color(number)
%% function to get color codes for plotting
%define colors
color_def = vertcat([95 158 160],[16 78 139],[188 143 143],[165 42 42],[238 118 33],[47 79 79],[198 226 255],[0 100 0],[154 205 50],[139 62 47], [0, 226, 245],...
                        [0 0 66],[189 189 0], [255 126 0], [85 107 47], [244 164 96], [176 225 230], [138 43 226],[102 205 170], [120 120 120],[240 230 140],[255 20 147]);
if nargin == 1 && number < 22 && floor(number) == number
    color = color_def(1:number,:) ./ 255;
else
    color = color_def ./ 255;
end
%define style
marker_def          = {'o','h','^','d','s','x','.','*','p','<','>','+','v','_','|'};
if nargin == 1 && number < 15 && floor(number) == number
    marker = marker_def(1:number);
else
    marker = marker_def;
end
end