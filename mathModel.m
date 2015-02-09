%% MATHMODEL Script that runs the overall computation of our math model
% that combines ODE and network flow.

% number of model iterations
N = 50;

% generate graph adjacency matrix (binary weights)
[B, info] = generateInitialGraph('data/graph1.mat');
B = full(B);

% get info about graph
T = info.T;
sD = info.sD;
tD = info.tD;

% add capacities to graph TODO
M = B;

%Initial time condition: 
t_initial = 0; 
t_final = 10;  

%Defining the time step: 
n = 1000;
t_step = (t_final-t_initial)/n;

% Defining ODE and initial conditions on each sink node
SRIModel = cell(length(T), 1);
for j=1:length(T)
    mJ = struct;
    mJ.T = T;
    mJ.S = NaN(1, N+1);
    mJ.I = NaN(1, N+1);
    mJ.A = NaN(1, N+1);
    mJ.r = 0.5;
    mJ.d = 0.8;
    mJ.S(1) = 7371158/length(T);
    mJ.I(1) = 2998/length(T);
    mJ.A(1) = 4510/length(T);
    SRIModel{j} = mJ;
end

% Each iteration of model
for i=1:N
    
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
        % get the index of the edge from each sink to dummy sink
        edges = B(T(j),:)==1;
        M(T(j),edges) = mJ.I(i+1);
    end
    
    % compute max flow
    M = sparse(M);
    [flow, cut, R, F] = max_flow(M, sD, tD);
    M = full(M);
    
    % update ODE parameters
    for j=1:length(T)
        mJ = SRIModel(j);
        % get the computed flow along a particular edge
        edges = B(T(j),:)==1;
        mJ.I(i+1) = mJ.I(i+1)-F(T(j), edges);
        SRIModel{j} = mJ;
    end
    
end