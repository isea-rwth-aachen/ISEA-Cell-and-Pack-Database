function fcn_plot_Housings_pdf(xmlstruct,ax0)
type= xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.HousingStyle.Text;
color = [161,16,53]./250;
%% get plot of the single housing
if strcmp(type, 'Cylindric')
    radius              = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.RadiusCylindric.Text);
    height              = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthCylindric.Text);
    theta               = 0 : pi / 100 : 2*pi;
    a                   = radius * cos(theta);
    b                   = radius * sin(theta);
    surf(ax0,[a; a],[b; b],[ones(1,size(theta,2)); zeros(1, size(theta,2))] * height,'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.6);
    patch(ax0, b, ones(1,size(theta,2))*height,[0 0 0], 'FaceAlpha',0.7);
    patch(ax0, b, zeros(1,size(theta,2)),[0 0 0], 'FaceAlpha',0.7);
elseif strcmp(type,'Pouch')
    width               = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPouch.Text);
    height              = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPouch.Text);
    thickness           = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPouch.Text);
    Vertices            = [0 0 0; 0 0 thickness; 0 height thickness;0 height 0; width height 0; width height thickness; width 0 thickness; width 0 0] + [0 0 0];
    Faces               = [1 2 3 4; 3 4 5 6; 5 6 7 8; 2 7 8 1; 1 4 5 8; 3 6 7 2];
    patch(ax0,'Faces', Faces, 'Vertices', Vertices, 'FaceColor',	color, 'FaceAlpha',0.7);
elseif strcmp(type,'Prismatic')
    width               = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.WidthPrismatic.Text);
    height              = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.LengthPrismatic.Text);
    thickness           = str2num(xmlstruct.BatteryID.GeneralInformation.MechanicalParameters.Dimensions.ThicknessPrismatic.Text);
    Vertices            = [0 0 0; 0 0 thickness; 0 height thickness;0 height 0; width height 0; width height thickness; width 0 thickness; width 0 0] + [0 0 0];
    Faces               = [1 2 3 4; 3 4 5 6; 5 6 7 8; 2 7 8 1; 1 4 5 8; 3 6 7 2];
    patch(ax0,'Faces', Faces, 'Vertices', Vertices, 'FaceColor',	color, 'FaceAlpha',0.7);
else
    radius              = 9;
    height              = 65;
    theta               = 0 : pi / 100 : 2*pi;
    a                   = radius * cos(theta);
    b                   = radius * sin(theta);
    surf(ax0,[a; a],[b; b],[ones(1,size(theta,2)); zeros(1, size(theta,2))] * height,'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.6);
    patch(ax0, b, ones(1,size(theta,2))*height,[0 0 0], 'FaceAlpha',0.7);
    patch(ax0, b, zeros(1,size(theta,2)),[0 0 0], 'FaceAlpha',0.7);
end
hold(ax0, 'off');
axis(ax0, 'equal');
view(ax0,-45,30);
set(ax0, 'FontSize', 14);
ax0.YLabel.String        = 'Y [mm]';
ax0.YLabel.FontSize      = 14;
ax0.XLabel.String        = 'X [mm]';
ax0.XLabel.FontSize      = 14;
ax0.ZLabel.String        = 'Z [mm]';
ax0.ZLabel.FontSize      = 14;
end