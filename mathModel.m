function [SRIModel, data] = mathModel(params)
%% MATHMODEL Function that runs the overall computation of our math model
% that combines ODE and network flow.

%% COMPUTATION

% generate graph adjacency matrix (binary weights)
[B, info] = generateInitialGraph(params.filename);
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
M(info.sD, sD_edges) = params.sourceD2sources;
for i=1:length(info.S)
    M(info.S(i), S_edges(i,:)) = params.sources2inter;
end
for i=1:length(info.intermediate)
    M(info.intermediate(i), I_edges(i,:)) = params.inter2sinks;
end
for i=1:length(info.T)
    M(info.T(i), T_edges(i,:)) = params.sinks2sinks;
end

% defining ODE and set initial conditions on each sink node
SRIModel = cell(length(T), 1);
for j=1:length(T)
    mJ = struct;
    mJ.T = T;
    mJ.S = NaN(1, params.N+1);
    mJ.I = NaN(1, params.N+1);
    mJ.A = NaN(1, params.N+1);
    mJ.r = params.r;
    mJ.d = params.d;
    mJ.S(1) = params.totalpplS/length(T);
    mJ.I(1) = params.totalpplI/length(T);
    mJ.A(1) = params.totalpplA/length(T);
    SRIModel{j} = mJ;
end

% each iteration of model
medicineCount = 0;
for i=1:params.N-1
    
    % round values
    M = round(M);
    
    % compute ODE
    for j=1:length(T)
        mJ = SRIModel{j};
        [S, I, A, t] = SII_Euler(mJ.S(i), mJ.I(i), mJ.A(i), params.t_initial, params.t_final, params.n, mJ.r, mJ.d);
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
        disp('Simulation completed early.');
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

% remove NaNs
for j=1:length(T)
    mJ = SRIModel{j};
    S = mJ.S;
    S(isnan(S)) = [];
    mJ.S = S;
    I = mJ.I;
    I(isnan(I)) = [];
    mJ.I = I;
    A = mJ.A;
    A(isnan(A)) = [];
    mJ.A = A;
    SRIModel{j} = mJ;
end

%% ANALYSIS

% compute total sickened at each location
for j=1:length(T)
    mJ = SRIModel{j};
    S = mJ.S;
    mJ.sickened = round(S(1)-S(end));
    SRIModel{j} = mJ;
%     fprintf('Total Sickened in discrete region %d: %d\n', j, mJ.sickened);
end

% compute total dead at each location
for j=1:length(T)
    mJ = SRIModel{j};
    S = mJ.S;
    I = mJ.I;
    A = mJ.A;
    initialCount = S(1) + I(1) + A(1);
    finalCount = S(end) + I(end) + A(end);
    mJ.dead = round(initialCount - finalCount);
    SRIModel{j} = mJ;
%     fprintf('Total Dead in discrete region %d: %d\n', j, mJ.dead);
end

% struct of results data
data = struct;

% total medicine consumed
data.medicineCount = medicineCount;
% fprintf('Total medicine consumed: %d \n', medicineCount);


end
