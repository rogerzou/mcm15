%% MATHMODEL Script that runs the overall computation of our math model
% that combines ODE and network flow.


%% IMPORTANT PARAMETERS TO CHANGE

% edge capacities in flow network
sourceD2sources = 1000;             % dummy source -> source
sources2inter = 40;                 % source -> intermediate
inter2sinks = 20;                   % intermediate -> sink
sinks2sinks = 5;                    % sinks -> sinks

% initial and final time condition: 
t_initial = 0;
t_final = 10;

% number of ODE steps
n = 100;

% number of model iterations
N = 50;

% initial ODE conditions
r = 0.1;
d = 0.05;
totalpplS = 7371158;                % total people susceptible
totalpplI = 2998;                   % total people infected (light)
totalpplA = 4510;                   % total people doomed (incurable)


%% COMPUTATION

% compuote time step
t_step = (t_final-t_initial)/n;

% generate graph adjacency matrix (binary weights)
[B, info] = generateInitialGraph('data/graph1.mat');
B = full(B);

% get info about graph
T = info.T;
sD = info.sD;
tD = info.tD;

% find the relevant entries in adjacency matrix
M = B;
sD_edges = B(info.sD,:)==1;             % dummy source -> source
S_edges = B(info.S,:)==1;               % source -> intermediate
I_edges = B(info.intermediate,:)==1;    % intermediate -> sink
T_edges = B(info.T,:)==1;               % sinks -> sinks

% set initial capacities for each edge
M(info.sD, sD_edges) = sourceD2sources;
for i=1:length(info.S)
    M(info.S(i), S_edges(i,:)) = sources2inter;
end
for i=1:length(info.intermediate)
    M(info.intermediate(i), I_edges(i,:)) = inter2sinks;
end
for i=1:length(info.T)
    M(info.T(i), T_edges(i,:)) = sinks2sinks;
end

% defining ODE and set initial conditions on each sink node
SRIModel = cell(length(T), 1);
for j=1:length(T)
    mJ = struct;
    mJ.T = T;
    mJ.S = NaN(1, N+1);
    mJ.I = NaN(1, N+1);
    mJ.A = NaN(1, N+1);
    mJ.r = r;
    mJ.d = d;
    mJ.S(1) = totalpplS/length(T);
    mJ.I(1) = totalpplI/length(T);
    mJ.A(1) = totalpplA/length(T);
    SRIModel{j} = mJ;
end

% each iteration of model
medicineCount = 0;
for i=1:N-1
    
    % round values
    M = round(M);
    
    % compute ODE
    for j=1:length(T)
        mJ = SRIModel{j};
        [S, I, A, t] = SII_Euler(mJ.S(i), mJ.I(i), mJ.A(i), t_initial, t_final, n, mJ.r, mJ.d);
        mJ.S(i+1) = S(end);
        mJ.I(i+1) = I(end);
        mJ.A(i+1) = A(end);
        SRIModel{j} = mJ;
    end

    % update network flow capacities
    for j=1:length(T)
        mJ = SRIModel{j};
        % update capacities from sink to dummy sink
        M(T(j), tD) = mJ.I(i+1);
    end
    
    if uint32(floor(mJ.I(i+1)))==0
        disp('No one to save!');
        break;
    end
        
    % compute max flow
    M(M < 1) = 0;
    M = sparse(M);
    [flow, cut, R, F] = max_flow(M, sD, tD);
    M = full(M);
    
    % update ODE parameters
    F = full(F);
    for j=1:length(T)
        mJ = SRIModel{j};
        % get the computed flow along a particular edge, update I in ODE model
        mJ.I(i+1) = mJ.I(i+1)-F(T(j), tD);
        SRIModel{j} = mJ;
    end
    
    % count medicine consumed
    medicineCount = medicineCount + flow;
    
end


%% ANALYSIS

for j=1:length(T)
    mJ = SRIModel{j};
    S = mJ.S;
    S(isnan(S)) = [];
    fprintf('Total Sickened in discrete region %d: %d\n', j, round(S(1)-S(end)));
end

for j=1:length(T)
    mJ = SRIModel{j};
    S = mJ.S;
    S(isnan(S)) = [];
    I = mJ.I;
    I(isnan(I)) = [];
    A = mJ.A;
    A(isnan(A)) = [];
    initialCount = S(1) + I(1) + A(1);
    finalCount = S(end) + I(end) + A(end);
    fprintf('Total Dead in discrete region %d: %d\n', j, round(initialCount - finalCount));
end

fprintf('Total medicine consumed: %d \n', medicineCount);
