clear all
close all

%% Literature/Sources
% (1) J.Betz: "Theoretical versus Practical Energy: A Plea for More Transparency in the Energy Calculation of Different Rechargeable Battery Systems"
% (2) M.Ender: A novel method for measuring the effective conductivity and the contact resistance of porous electrodes for lithium-ion batteries
% (3) M. Ecker: "Parameterization of a Physico-Chemical Model of a Lithium-Ion Battery - II. Model Validation"
% (4) Prof. Dr. habil. Wolfgang G. Bessler: "Physicochemical modeling and simulation of lithium-ion batteries"
% (5) B. Vikram Babu: "Structural and electrical properties of Li4Ti5O12anode material for lithium-ion batteries"
% (6) BatPac Tool
% (7) M. Wentker: A Bottom-Up Approach to Lithium-Ion Battery Cost Modeling with a Focus on Cathode Active Materials
% (8) https://www.americanelements.com/lithium-titanate-spinel-nanoparticles-nanopowder-12031-95-7
% (9) Gregory L. Plett - Battery Management Systems - Battery Modeling
% (10) C. Wang: Ionic/Electronic Conducting Cahracteristics of LiFePO4 Cathode Materials - The Determining FActors for High Rate Performance
% (11) Book "Lead-Acid Batteries for Future Automobiles" Chapter 2  - % Overview of batteries for future automobiles
% (12) N.Ding: Key parameters in design of lithium sulfur batteries
% (13) Qianfan Zhang: First-principles Approaches to Simulate Lithiation in Silicon Electrodes
% (14) Ke Pan: "Systematic electrochemical characterizations of Si and SiO anodes for highcapacity Li-Ion batteries"
% (15) MERCK Sicherheitsdatenblatt; Artikelnummer 107726; Artikelbezeichnung Siliciumkmonoxid Pulver unter 0.045mm (SiO)
% (16) https://www.emdgroup.com/content/dam/web/corporate/non-images/Products/PM/us/SiO_tcm2080-us.pdf
% (17) M. Doyle: Computer Simulations of a Lithium-Ion Polymer Battery andImplications for Higher Capacity Next-GenerationBattery Designs
% (18) R. Ahmin: Characterization of transport properties of LiNi0.8Co0.15Al0.05O2 (NCA)
% (19) R. E. Gerver: Three-Dimensional Modeling of Electrochemical Performance and Heat Generation of Lithium-Ion Batteries in Tabbed Planar Configurations
% (20) D. Andre: Future generations of cathode materials: an automotive industry perspective
% (21) M. Park: A review of conduction phenomena in Li-ion batteries
% (22) H. Noh: Comparison of the structural and electrochemical properties of layered Li[NixCoyMnz]O2 (x ¼ 1/3, 0.5, 0.6, 0.7, 0.8 and 0.85) cathode material for lithium-ion batteries
% (23) M. G. Lazarraga: Nanosize LiNiyMn2 2 yO4 (0 v y ¡ 0.5) spinels synthesized by a sucrose-aided combustion method. Characterization and electrochemical performance
% (24) E. J. Berg: Rechargeable Batteries: Grasping for the Limits of Chemistry
% (25) Beata Kurc: Properties of Li4Ti5O12 as an anode material in non-flammable electrolytes
% (26) I. A. Steninaa: Synthesis and Ionic Conductivity of Li4Ti5O12
% (27) Meng Xu: Two-dimensional electrochemicalethermal coupled modeling of cylindrical LiFePO4 batteries
% (28) Kazuma Gotoh: Properties of a novel hard-carbonoptimized to large size Lion secondarybattery studied by 7Li NMR
% (29) Xinwei Dou: Hard Carbon Anode Materials for Sodium-ion Battery
% (30) www.mrbigler.com; Abruf 09.11.2019

%% Density in g/cm³
% Anodes
Density_C6 = 2.2; % from (1), (24)
% Density_C6 = 2.24; % from (7)
% Density_C6 = 1.825; % from (6)
Density_HardCarbon = 1.5; % from (28), (29)
Density_LTO = 3.5; % from (8)
Density_Si = 1.66; % from (24)
Density_SiO = 2.13; % from (15)
Density_Li_Metal = 0.53; % from (1), (24)
Density_Mg_Metal = 1.74; % from (1)
Density_Na4C33 = 2; % from (24)
Density_Na31Sn = 7.29; % from (24)

% Cathode
Density_LCO = 4.678; % from (17)
% Density_LCO = 5.05; % from (24)
Density_LMO = 4.31; % from (7), (24)
Density_LFP = 3.65; % from (7), (24)
% Density_LFP = 3.6; % from (19)
Density_NMC_1_1_1 = 4.75; % from (7), (24)
Density_NMC_4_4_2 = 4.75; % from (7)
Density_NMC_5_3_2 = 4.75; % from (7)
Density_NMC_6_2_2 = 4.75; % from (7)
Density_NMC_8_1_1 = 4.75; % from (7)
% Density_NCA_80_15_05 = 4.79; % from (1)
Density_NCA_80_15_05 = 4.78; % from (7)
% Density_NCA_80_15_05 = 4.6; % from (24)
Density_LNMO = 4.4; % from (7)
Density_LNMO_05_15 = 4.4; % from (24)
Density_LNMO_04_16 = Density_LNMO_05_15;
Density_S = 2.07; % from (1)
% Density_S = 1.66; % from (24)

%% Electrode Conductivity in S/m; 
% Anodes
% ElecCond_C6 = 2203.8; % from (2)
ElecCond_C6 = 14; %in S/m; from (3)
% ElecCond_C6 = 11.1; %in S/m; from (3)
% ElecCond_C6 = 0.4; % in S/m; from (4)
% ElecCond_C6 = 1; %in S/m; from (19)
ElecCond_HardCarbon = ElecCond_C6; % expert guess
% ElecCond_LTO = 5.96e-7; % in S/m; from (5)
ElecCond_LTO = 1e-11; % in S/m; from (25), (26)
ElecCond_Si = 2.52e-04; % from PT
ElecCond_SiO = 1e-09; % from (16); 10-7 bis 10-12 S/m
ElecCond_Li_Metal = 1.08e7; % from PT

% Cathode
% ElecCond_LCO = 1; % from (17)
ElecCond_LCO = 1e-2; % from (21)
% ElecCond_LCO = 9.66; % from (2)
% ElecCond_LMO = 7.86; % from (2)
ElecCond_LMO = 1e-4; % from (21)
ElecCond_NMC = 100; % from (4)
ElecCond_NMC_1_1_1 = 5.2e-6; % from (20), (22)
ElecCond_NMC_5_2_3 = 4.9e-5; % from (22)
ElecCond_NMC_6_2_2 = 1.6e-4; % from (22)
ElecCond_NMC_70_15_15 = 9.3e-4; % from (22)
ElecCond_NMC_8_1_1 = 2.8e-3; % from (20)
% ElecCond_NMC_8_1_1 = 1.7e-3; % from (22)
ElecCond_NMC_85_075_075 = 2.8e-3; % from (22)
ElecCond_NCA = 1e-3; % from (18)
% ElecCond_LFP = 6.75; % from (2) - most likely this is already including conductive additives and binder
ElecCond_LFP = 3.7e-7; % from (10)
% ElecCond_LFP = 5e-3; % from (19)
% ElecCond_LFP = 1e-7; % from (20), (21)
% ElecCond_S = 5e-28; % from (11)
ElecCond_LNMO_04_16 = 3.6e-3; % from (23)
ElecCond_LNMO_05_15 = 1.9e-5; % from (23)
ElecCond_S = 1e-15; % from (12)

%% Diffusivity in cm²/s
% Anode
Diffusivity_LTO = 5e-10; % from (25)

% Cathode
Diffusivity_LCO = 1e-9; % from (21)
Diffusivity_LMO = 1e-10; % from (21)
Diffusivity_LFP = 5e-15; % from (21)
Diffusivity_NMC_1_1_1 = 5e-12; % from (20)
Diffusivity_NMC_8_1_1 = 5e-9; % from (20)

%% Volume Expansion in a.u.
% Anode
Expansion_C6 = 0.1; % from (11)
% Expansion_C6 = 0.12; % from (19)
Expansion_LTO = 0.0; % from (11)
% Expansion_Si = 3.12; % from (11); it is mentioned together with the 10% for LiC6 therefore it is most likely not supposed to be 212% but really 312%
Expansion_Si = 3.34; % from (13); up to Li4.33Si
% Expansion_Si = 2.8; % from (14)
Expansion_SiO = 1.18; % from (14)

% Cathode
Expansion_LMO = 0.0; % from (11); "The volume change during cycling is the lower than that of layered structures"
Expansion_NMC_1_1_1 = 0.015; % from (11); from 1% to 2% for NMC; they are most likely talking about NMC 111
Expansion_LFP = 0.3;
Expansion_S = 0.81; % from (1)

%% Electrolyte to active material ratio
% Anode
% Cathode
ElectrolyteToAmRatio_S = 3; % in ml/g from (1); can be as high as 10 for longer lifetime and as low as 2 for high energy density

%% Exchange current density
% Anode
% Cathode
ExchangeCurrentDensity_LCO = 2.6; % in mA/cm² from (17)

%% charge transfer kinetic coefficient
% Anode
% Cathode
ChargeTransferKineticCoefficient_LCO = 0.5; % from (17)

save('Databases\icpd_publication_data\00_InputData\ActiveMaterials\MaterialPropsFromLit\MaterialPropertiesFromLiterature.mat')
clear all
close all
