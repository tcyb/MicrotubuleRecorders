function f = defineCaTEVOde(ca, k, varargin)
% defineCaTEVOde(ca, k, ...)
%
% Generates a f(t,y) for the matlab ODE solvers, parametrized by Ca and the
% k's. Assumes the simple kinetics model proposed by Namita, tracks the
% quantities y = [E, EC, I, A].
%
% Inputs:
% ca - N-length vector, in 1ms increments, representing [Ca2+]
% k - vector of parameters. Should be in order:
%       [k2, k3, Km, kcat, Ctrans]
%       Where: k2 and k3 are kon, koff of CaM
%              Km is the Km of TEV
%              kcat is kcat of TEV
%              Ctrans is a degradation/diffusion/etc. term for A
%             
% Outputs:
% f - a function of form f(t,y) that represents the kinetic model for use
%     in matlab ODE solvers
% 

%% Parse Inputs
p = inputParser();
addRequired(p, 'ca', @isnumeric)
addRequired(p, 'k', @isnumeric)
p.parse(ca, k, varargin{:})

%% Define parameters, etc.

k2 = k(1);
k3 = k(2);
Km = k(3);
kcat = k(4);
Ctrans = k(5);

ttos = 1000; % ca is given in 1ms increments

%% Define ODE function
    function yp = calciumTEVOdeFun(t, y)
    % y = [[E], [EC], [I], [ECI], [A]]'
    % yp is a vector that contains the derivatives.

    E = y(1);
    EC = y(2);
    C = ca(round(t*ttos) + 1);
    I = y(3);
    A = y(4);

    yp = zeros(size(y));

    % Equations
    yp(1) = -k2*E*C + k3*EC;
    yp(2) = k2*E*C - k3*EC;
    yp(3) = -kcat*EC*I/(Km + I);
    yp(4) = kcat*EC*I/(Km + I) - Ctrans;
    end

%% Return function

f = @calciumTEVOdeFun;

end