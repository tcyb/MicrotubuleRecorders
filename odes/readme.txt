Should be two files here (for now):

**defineCaTEVOde.m -**
Defines a function that will generate f(t,y) for any of the matlab ODE solvers. Represents a simplified version of the model Kettner and Namita proposed: E+C <-> EC + I --> EC + A. Parametrizes the model based on a vector of calcium values (in ms timesteps) and a vector of k's. Assumption list to come.

**tevODE_setup.m -**
Sets up for use of defineCaTEVOde.m. If you run this, it will simulate a 10s run with a 0.5 Hz oscillating calcium signal and plot the result.

-t
