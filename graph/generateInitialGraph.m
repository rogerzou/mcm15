function [ B, info ] = generateInitialGraph(filename)
%GENERATEINITIALGRAPH Loads adjacency matrix from file

graph = load(filename);
B = sparse(graph.B);
info = graph.info;

end
