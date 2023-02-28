clear all
close all

load('Databases\icpd_publication_data\ActiveMaterials\NMC811.mat');
load('Databases\icpd_publication_data\Blends\Si0035_C6.mat');
load('Databases\icpd_publication_data\ConductiveAdditives\CarbonBlack.mat');
load('Databases\icpd_publication_data\Binders\PVdF.mat');
load('Databases\icpd_publication_data\ActiveMaterials\NCO.mat');
load('Databases\icpd_publication_data\ActiveMaterials\Graphite_Kokam.mat');

%% Literature
% (1) - dissertation from Marcel Wilka: Untersuchung von Polarisationseffekten an Lithium-Ionen-Batterien
% (2) J.Betz: "Theoretical versus Practical Energy: A Plea for More Transparency in the Energy Calculation of Different Rechargeable Battery Systems"

Coatings = [];

%% Future Technologies
%% Anode
Name = 'Coating_SiC6';
ActiveMaterial = Si0035_C6;
MassFractionActiveMaterial = 0.91;
ConductiveAdditive = CarbonBlack;
MassFractionConductiveAdditive = 0.045;
Binder = PVdF;
MassFractionBinder = 0.045;

obj = Coating(Name, ActiveMaterial, MassFractionActiveMaterial, ConductiveAdditive, MassFractionConductiveAdditive, Binder, MassFractionBinder);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
Coatings.(Name) = obj;

Name = 'Coating_C6_Kokam';
ActiveMaterial = Graphite_Kokam;
MassFractionActiveMaterial = 0.5963;
ConductiveAdditive = CarbonBlack;
MassFractionConductiveAdditive = 0.20185;
Binder = PVdF;
MassFractionBinder = 0.20185;
obj = Coating(Name, ActiveMaterial, MassFractionActiveMaterial, ConductiveAdditive, MassFractionConductiveAdditive, Binder, MassFractionBinder);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Coatings.(Name) = obj;

Name = 'Coating_C6_Kokam2';
ActiveMaterial = Graphite_Kokam;
MassFractionActiveMaterial = 0.6;
ConductiveAdditive = CarbonBlack;
MassFractionConductiveAdditive = 0.2;
Binder = PVdF;
MassFractionBinder = 0.2;
obj = Coating(Name, ActiveMaterial, MassFractionActiveMaterial, ConductiveAdditive, MassFractionConductiveAdditive, Binder, MassFractionBinder);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Coatings.(Name) = obj;


%% Cathode
Name = 'Coating_NMC811';
ActiveMaterial = NMC811;
MassFractionActiveMaterial = 0.96;
ConductiveAdditive = CarbonBlack;
MassFractionConductiveAdditive = 0.02;
Binder = PVdF;
MassFractionBinder = 0.02;
obj = Coating(Name, ActiveMaterial, MassFractionActiveMaterial, ConductiveAdditive, MassFractionConductiveAdditive, Binder, MassFractionBinder);
obj = SetProperty(obj, 'Source', '10.1016/j.jpowsour.2018.11.043');
obj = SetProperty(obj, 'Confidential', 'No');
Coatings.(Name) = obj;

Name = 'Coating_NCO';
ActiveMaterial = NCO;
MassFractionActiveMaterial = 0.6083;
ConductiveAdditive = CarbonBlack;
MassFractionConductiveAdditive = 0.19585;
Binder = PVdF;
MassFractionBinder = 0.19585;
obj = Coating(Name, ActiveMaterial, MassFractionActiveMaterial, ConductiveAdditive, MassFractionConductiveAdditive, Binder, MassFractionBinder);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Coatings.(Name) = obj;

Name = 'Coating_NCO2';
ActiveMaterial = NCO;
MassFractionActiveMaterial = 0.66;
ConductiveAdditive = CarbonBlack;
MassFractionConductiveAdditive = 0.17;
Binder = PVdF;
MassFractionBinder = 0.17;
obj = Coating(Name, ActiveMaterial, MassFractionActiveMaterial, ConductiveAdditive, MassFractionConductiveAdditive, Binder, MassFractionBinder);
obj = SetProperty(obj, 'Source', '10.1149/2.0551509jes');
obj = SetProperty(obj, 'Confidential', 'No');
Coatings.(Name) = obj;

%%Save elements
outputStruct = Coatings;
folder = 'Databases\icpd_publication_data\Coatings\';

fn = fieldnames(outputStruct);
for el = 1:numel(fn)
    saveVar.(fn{el}) = outputStruct.(fn{el});
    save([folder convertStringsToChars(saveVar.(fn{el}).Name) '.mat'], '-struct', 'saveVar');
    disp([ convertStringsToChars(saveVar.(fn{el}).Name) ' created']);
    clear saveVar
end

save('Databases\icpd_publication_data\Coatings\Coatings.mat', 'Coatings');
clear all
close all