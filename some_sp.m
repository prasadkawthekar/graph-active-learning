function sp = some_sp(G, f)
% Finds some shortest path between opposite labeled nodes, if one exists.

n = size(G,1);

sp = [];

N_idx=(f==-1);
P=find(f==1);

if ~isempty(find(N_idx,1)) && ~isempty(P)
    
    seen = false(1, n);
    
    for idx=1:length(P) % loop over positive nodes by default, consider changing to less frequent label if necessary
        
        s = P(idx);
        
        if ~seen(s)
            
            dist = Inf(1, n);
            pred = zeros(1, n);
            
            q(1) = s;
            seen(s) = true;
            dist(s)=0;
            
            while ~isempty(q)
                
                u = q(1); q(1)=[];
                conn = find(G(u,:)==1);
                
                for j=1:size(conn,2)
                    
                    v = conn(j);
                    
                    if dist(v)==Inf
                        
                        seen(v) = true;
                        dist(v)=dist(u)+1;
                        pred(v)=u;
                        
                        q(end+1)=v;
                        if N_idx(v) == 1
                            while 1, sp(end+1)=v; if v==s, sp=fliplr(sp); return, end, v=pred(v); end; % shortest shortest path
                        end
                        
                    end
                end
            end
        end
    end
end

end