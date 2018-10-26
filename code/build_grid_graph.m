function [G,oracle,points] = build_grid_graph(dim,clength,elength)
% Construct a dim-dimensional grid of clength length with same labels,
% except a core of elength length of different label.

% points in grid
sets = repmat({1:clength}, 1, dim);

% cartesian product of sets
c = cell(1, numel(sets));
[c{:}] = ndgrid( sets{:} );
points = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
points = fliplr(points);

% graph to represent grid
G=squareform(pdist(points));
G(G>1)=0;

% label graph
num = clength^dim;
dist = max(abs(points-repmat(1+(clength)/2,num,dim)),[],2);
oracle = ones(size(points,1), 1);   % positive core
oracle(dist>elength/2) = -1;    % rest is negative

end

