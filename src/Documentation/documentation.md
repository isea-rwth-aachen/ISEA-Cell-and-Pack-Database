## Physico-chemical model export

With the ICPD’s calculations, the battery cells’ static parameters can be determined. Easy simulations that can contribute to rough estimations if an investigated battery cell fits a specific application can be conducted with this initial set of parameters. However, to simulate the battery cells in a physico-chemical DFN model, it is necessary to add several parameters for the dynamic behaviour. Doing the following steps with any cell with physically reasonable parameters is possible.

Therefore, properties like reaction rate or double-layer capacitances are introduced to the parameter set, resulting from the virtual cell design process. Those additional properties can get their values from measurements in the lab or literature, or if no exact parameters can be found, an initial guess with the later tuning of the parameters can lead to sufficient precise results.

The Arrhenius class objects are introduced to the database to enable the simulation of the DFN model with the ICPD parameters of a virtual cell model. Starting with the static parameters, on the active material level, the following parameters have to be added to the initial parameter set:

+ Exchange current density
+ Reaction rate
+ Double-layer capacitance density
+ Particle radius
+ Arrhenius object conductivity
+ Arrhenius object reaction rate
+ Arrhenius object diffusion

The Arrhenius object has three main properties: the reference temperature in K, the activation energy in kJ/mol and the expression. The expression is implemented with various types. It can be a scalar, a function, a two-dimensional look-up table, an exponential-based two-dimensional look-up table or a spline. The particle radius of anode and cathode and the exchange current densities are scalar parameters of the active materials in the ICPD. With these parameters, in addition to the static parameters already present in the ICPD, all 29 parameters describing the DFN model are provided. The simulations calculating the electrochemical behaviour of the battery at different operating points can be started. The creation of the files required for the simulation model is fully automated.
