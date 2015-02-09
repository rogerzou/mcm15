%% RUNME Wrapper over all analysis

% Computes mathModel for different parameters

%% PARAMETERS 1
params1 = struct;
params1.filename = 'data/graph1.mat';
% edge capacities in flow network
params1.sourceD2sources = 0;             % dummy source -> source
params1.sources2inter = 400;                 % source -> intermediate
params1.inter2sinks = 200;                   % intermediate -> sink
params1.sinks2sinks = 50;                    % sinks -> sinks
% initial and final time condition: 
params1.t_initial = 0;
params1.t_final = 10;
% number of ODE steps
params1.n = 10;
% number of model iterations
params1.N = 50;
% initial ODE conditions
params1.r = 0.05;
params1.d = 0.0;
params1.totalpplS = 7371158;                % total people susceptible
params1.totalpplI = 2998;                   % total people infected (light)
params1.totalpplA = 4510;                   % total people doomed (incurable)

[SRIModel1, data1] = mathModel(params1);

%% PARAMETERS 2
params2 = params1;
params2.sourceD2sources = 50;

[SRIModel2, data2] = mathModel(params2);

%% PARAMETERS 2
params2 = params1;
params2.sourceD2sources = 500;

[SRIModel3, data3] = mathModel(params2);


%% PLOTTING
mJ1 = SRIModel1{1};
mJ2 = SRIModel2{1};
mJ3 = SRIModel3{1};

f1 = figure;
title('Susceptible people over time with varying medicine delivered');
hold on;
plot(1:length(mJ1.S), mJ1.S);
plot(1:length(mJ2.S), mJ2.S);
plot(1:length(mJ3.S), mJ3.S);
legend('0 medicine', '100 medicine', '1000 medicine');
legend boxoff 

f2 = figure;
title('Infected people over time with varying medicine delivered');
hold on;
plot(1:length(mJ1.I), mJ1.I);
plot(1:length(mJ2.I), mJ2.I);
plot(1:length(mJ3.I), mJ3.I);
legend('0 medicine', '100 medicine', '1000 medicine');
legend boxoff 

f3 = figure;
title('Advanced-Plase Infected people over time with varying medicine delivered');
hold on;
plot(1:length(mJ1.A), mJ1.A);
plot(1:length(mJ2.A), mJ2.A);
plot(1:length(mJ3.A), mJ3.A);
legend('0 medicine', '100 medicine', '1000 medicine');
legend boxoff 

set(f1, 'PaperUnits', 'inches');
x_width=12 ;y_width=6;
set(f1, 'PaperPosition', [0 0 x_width y_width]);
saveas(f1,'susceptible.png')

set(f2, 'PaperUnits', 'inches');
x_width=12 ;y_width=6;
set(f2, 'PaperPosition', [0 0 x_width y_width]);
saveas(f2,'infected.png')

set(f3, 'PaperUnits', 'inches');
x_width=12 ;y_width=6;
set(f3, 'PaperPosition', [0 0 x_width y_width]);
saveas(f3,'advanced.png')

