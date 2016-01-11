function B = boundary(G, oracle)
% Function B = boundary(G, oracle)
% Find the boundary nodes in G
% Input
%   G: n*n symmetric matrix for edges, Gij=1 if (i,j) in E, 0 otherwise.
%   oracle: n*1 true labels (-1 or +1)
% Output
%   B: the list of boundary nodes, |B|*1


n=size(G,1); % number of nodes in G

B=[];

for i=1:n,
  neighbors = find(G(i,:));
  if (find(oracle(i) ~= oracle(neighbors)))  % any neighbor has different label?
    B = [B; i];
  end
end
