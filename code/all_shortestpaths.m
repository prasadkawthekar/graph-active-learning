function [dist, pred] = all_shortestpaths(G, s, opp_nodes)
% Finds all shortest paths in G from source node s to all nodes
% in opp_nodes using breadth first search.

n = size(G,1);
dist = Inf(1, n);
pred = zeros(1, n);

opp_count = length(find(opp_nodes==1));
count = 0;

q(1) = s;
dist(s)=0;

while ~isempty(q) && count < opp_count
    u = q(1); q(1)=[];
    conn = find(G(u,:)==1);   
    for j=1:size(conn,2)
        v = conn(j);
        if dist(v)==Inf
            dist(v)=dist(u)+1;
            pred(v)=u;
            q(end+1)=v;
            if opp_nodes(v) == 1, count = count + 1; end
        end
    end
end

end