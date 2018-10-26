function print_graph_info(G, oracle, dataset)
% Returns relevant graph parameters of G for comparing performance of S2,
% BFS, and Approximate S2

n=size(G,1);

Vp=find(oracle==1);
Vn=find(oracle==-1);

C=find(G(Vp, Vn));

deltaC = retrieve_boundary(G, oracle);

deltaCn = deltaC(oracle(deltaC)==-1);

fprintf('\nGraph : %s\n', dataset);
fprintf('  Total nodes  : %d\n', n);
fprintf('  Positive nodes : %d\n', length(Vp));
fprintf('  Cut-edges : %d\n', length(C));
fprintf('  Cut-nodes : %d\n', length(deltaC));
fprintf('  Negative cut-nodes : %d\n', length(deltaCn));

end