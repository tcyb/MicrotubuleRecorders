clear all
close all

%% Initialize calcium
% This stuff is arbitrary for now. Where we define whatever calcium signal 
% we want to measure.

tca = 0:0.001:20;
hz = 0.5;
camax = 1e-6;

ca = (sin(tca*hz*(2*pi)) + 1)/2 * camax;

figure(2)
plot(tca, ca)

%% Define parameters

% Ka = kon/koff
% Km = (kr + kcat)/kf

% Ka for k2/k3 is ~ 10^6 (per K1 in (Park et al. 2007) and doi:10.1006/abio.2002.5661)
% Km for Tev is ~0.065, Kcat for TEV is 0.3?

Ka_CaM = 1e6;
Km_TEV = 0.065e-3; % in M

k2 = 1e8; % arbitrary
k3 = k2 / Ka_CaM; % given k2 and K1 from the paper, this is k3
kcat = 0.3; % From lit
Ctrans = 1e-8; % arbitrary

k = [k2, k3, Km_TEV, kcat, Ctrans];

%% Initialize, run ODE solver

% y = [[E], [EC], [I], [ECI], [A]]'

% Initial conditions
% y0 = [1e-6, 0, 1e-4, 0, 0]'; % concentrations in M
y0 = [1e-6, 0, 1e-4, 0]';
timeBounds = [0, 10];

f = defineCaTEVOde(ca, k);

% ode23 is less accurate than ode45, but faster.
[T, Y] = ode45(f, timeBounds, y0);
% [T, Y] = ode23(f, timeBounds, y0);
% [T, Y] = ode113(f, timeBounds, y0);

%% Plot

labels = {'E', 'EC', 'I', 'A'};

figure(3)
subplot(size(Y,2)+1,1,1)
plot(T, ca(round(T*1000)+1))
title('Ca^{2+}')
for i = 1:size(Y,2)
    subplot(size(Y,2)+1,1,i+1)
    plot(T, Y(:,i))
    title(labels{i})
end