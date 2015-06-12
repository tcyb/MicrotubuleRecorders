clear all
close all

%% Initialize calcium
% This stuff is arbitrary for now. Where we define whatever calcium signal 
% we want to measure.

% Generates a sine wave for a calcium stimulus
tca = 0:0.001:10;
hz = 0.5;
camax = 1e-6;

ca = (sin(tca*hz*(2*pi)) + 1)/2 * camax;

figure(2)
plot(tca, ca)
title('Input Ca^{2+}')
xlabel('Time (s)')
ylabel('[Ca^{2+}] (M)')

%% Define parameters

% Ka for CaM is ~ 10^6 (per K1 in (Park et al. 2007) and doi:10.1006/abio.2002.5661)
% Km for Tev is 0.065mM, Kcat for TEV is 0.3 1/s.

Ka_CaM = 1e6;
Km_TEV = 0.065e-3; % in M

k2 = 1e8; % arbitrary
k3 = k2 / Ka_CaM; % given k2 and K1 from the paper, k3 = k2/Ka
kcat = 0.3; % From lit
Ctrans = 5.4e-8; % M/s (i think) arbitrary, is a degradation/transit term. Assume 0th-order kinetics.


k = [k2, k3, Km_TEV, kcat, Ctrans];

%% Initialize, run ODE solver

% y = [[E], [EC], [I], [A]]'

% Initial conditions
y0 = [1e-6, 0, 1e-4, 0]';
timeBounds = [0, max(tca)];

f = defineCaTEVOde(ca, k);

[T, Y] = ode45(f, timeBounds, y0);

%% Plot

labels = {'E', 'EC', 'I', 'A'};

figure(3)
subplot(size(Y,2)+1,1,1)
plot(T, ca(round(T*1000)+1))
ylabel('[Ca^{2+}] (M)')
for i = 1:size(Y,2)
    subplot(size(Y,2)+1,1,i+1)
    plot(T, Y(:,i))
    ylabel(['[',labels{i},'] (M)'])
end
xlabel('Time (s)')