function [L, f, flags] = bfs_al(G, oracle, priority, budget)
% Wander-Focus Active Learning template for BFS algorithm.

n = size(G, 1);

L = []; flags = [];

f = zeros(n,1); % the queried labels (0 if unlabeled)

% whether the query occured in wander or focus phase
WANDER = 0;
FOCUS = 1;

while 1
    
    % wander phase, query by priority
    UL = setdiff(1:n,L);
    x = UL(randsample(length(UL),1,true,priority(UL)));
    flag = WANDER;
    
    while 1
        
        L = [L x];
        f(x) = oracle(x);
        flags = [flags flag];
        
        % stopping criterion
        if length(L) == budget
            f = labelCompletion(G, f);
            return;
        end
        
        % focus phase, query by BFS
        x = bfs(G, f);
        
        if x==0, break, end
        flag = FOCUS;
    end
end