function x = bfs(G, f)
% Select a random unlabeled neighbor of some positive node in G
% for querying.

fringe = find(sum(G(f==1,:), 1)); % neighbors of positive nodes

fringe = setdiff(fringe, find(f~=0)); % unlabeled neighbors of positive nodes

if isempty(fringe), x=0; return, end

x = fringe(randi(length(fringe))); 

end

