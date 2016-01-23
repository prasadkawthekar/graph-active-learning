function result = cartProd(sets)
% Returns cartesian product of vectors in sets
    c = cell(1, numel(sets));
    [c{:}] = ndgrid( sets{:} );
    result = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
end