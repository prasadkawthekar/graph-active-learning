function [x, sp, G] = a2s2_focus(G, L, f, sp)
% Selects node to query in focus phase of Approximate-S2
% algorithm. Selects the median node of a shortest path if one exists, or
% finds a new shortest path between opposite labeled nodes and returns it's
% median node.

if isempty(sp)
    
    sp = some_shortestpath(G, f); % some shortest path between opposite labeled nodes, if any
    
end

if ~isempty(sp)
    
    while 1
        
        % truncates sp if necessary to ensure that end-nodes are opposite
        % labeled and none of the other nodes are labeled
        sp_int = sp(2:end-1);
        lsp = intersect(L, sp_int);
        while ~isempty(lsp)
            idx = find(sp==lsp(1));
            if f(lsp(1)) == f(sp(1))
                sp = sp(idx:end);
            else
                sp = sp(1:idx);
            end
            sp_int = sp(2:end-1);
            lsp = intersect(L, sp_int);
        end
        
        if length(sp) == 2  % found a cut edge
            
            % remove cut edge(s)
            p = sp(f(sp) == 1);
            n = sp(f(sp) == -1);
            
            P = find(f==1);
            N = find(f==-1);
            
            pcuts = N(G(p,N)>0);
            if ~isempty(pcuts)
                G(pcuts, p) = 0; G(p, pcuts)=0;
            end
            
            ncuts = P(G(n,P)>0);
            if ~isempty(ncuts)
                G(ncuts, n) = 0; G(n, ncuts)=0;
            end
            
            % find some path from positive to negative node
            for i=1:length(pcuts)
                [~, sp, ~] = graphshortestpath(sparse(G), p, pcuts(i));
                if ~isempty(sp)
                    break
                end
            end
            
            % find some path from negative to positive node
            if isempty(sp)
                for i=1:length(ncuts)
                    [~, sp, ~] = graphshortestpath(sparse(G), n, ncuts(i));
                    if ~isempty(sp)
                        break
                    end
                end
            end
            
            if isempty(sp)
                x = 0;
                return
            end
            
        else
            break
        end
        
    end
    
    % return median of new shortest path
    x = sp(floor(median(1:length(sp))));
    
else
    
    x = 0;
    
end

end