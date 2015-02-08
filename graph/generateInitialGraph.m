function [ M, info ] = generateInitialGraph(filename)
%GENERATEINITIALGRAPH Loads adjacency matrix from file

graph = load(filename);
M = sparse(graph.M);
info = graph.info;

end
