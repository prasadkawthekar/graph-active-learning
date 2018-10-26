function [L, f, flags] = a2s2_active_learning(G, oracle, priority, budget)
% Wander-Focus Active Learning template for Approximate-S2 algorithm.

n = size(G, 1);

L = []; % queried nodes
flags = []; % flag of queried node (wander or focus)

f = zeros(n,1); % the queried labels (0 if unlabeled)

sp = []; % the shortest path between oppositely labeled nodes

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
            f = label_completion(G, f);
            return;
        end
        
        % focus phase, query by approximate-s2
        [x, sp, G] = a2s2_focus(G, L, f, sp);
        
        if x==0, break, end
        flag = FOCUS;
    end
end