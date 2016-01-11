% Driver code to run S2, BFS, and Accelerated S2 on different datasets and
% compare their query complexity and querying time complexity

%% set environment

clc; clear; close all;
w = warning ('off','all');

tasks = 1:7;

iters = 10;
fprintf('Total iterations : %d\n', iters);

L = {}; f = {}; flags = {}; Time = {}; B = {};
algs = {'S2', 'BFS', 'Accelerated S2'};
graphs = {'Twitter-character trigrams', 'Twitter-Bag of words', 'Twitter-Temporal frequency', 'Digits-1v4', 'Digits-4v9', 'CVR', 'Grid'};
for i=1:length(algs),
    for j=1:length(graphs)
        L{i, j} = {}; f{i, j} = {}; flags{i, j} = {}; Time{i, j} = []; B{j} = [];
    end
end

%% run experiments

for i=1:length(tasks)
    task = tasks(i);
    fprintf('\nGraph : %s\n', graphs{task});
    
    switch task
        
        case 1,
            load data/twitter/trigrams
            
        case 2,
            load data/twitter/words
            
        case 3,
            load data/twitter/days
            
        case 4,
            load data/oddeven/1v2
            
        case 5,
            load data/oddeven/4v9
            
        case 6,
            load data/congressionalVoting/cvr
            
        case 7,
            dim=2;
            clength=15;
            elength=8;
            [G,oracle,~]=grid_graph(dim,clength,elength);
            
    end
    
    num = size(G, 1);
    budget = num;
    priority = ones(num,1)./num;
    
    B{task} =  boundary(G, oracle);
    
    Info = graphinfo(G, oracle);
    
    fprintf('\tTotal nodes  : %d\n', Info(1));
    fprintf('\tPositive nodes : %d\n', Info(2));
    fprintf('\tCut-edges : %d\n', Info(3));
    fprintf('\tCut-nodes : %d\n', Info(4));
    fprintf('\tNegative cut-nodes : %d\n', Info(5));
    
    fprintf('\nRunning S2\nIter : ')
    ts = tic;
    for iter=1:iters,
        fprintf('%d,', iter)
        [L{1, task}{iter}, f{1, task}{iter}, flags{1, task}{iter}] = s2_al(G, oracle, priority, budget);
    end
    te = toc(ts);
    Time{1,task} = [Time{1, i} te];
    
    fprintf('\n\nRunning BFS\nIter : ');
    ts = tic;
    for iter=1:iters,
        fprintf('%d,', iter)
        [L{2, task}{iter}, f{2, task}{iter}, flags{2, task}{iter}] = bfs_al(G, oracle, priority, budget);
    end
    te = toc(ts);
    Time{2,task} = [Time{2, task} te];
    
    fprintf('\n\nRunning Accelerated S2\nIter : ')
    ts = tic;
    for iter=1:iters,
        fprintf('%d,', iter)
        [L{3, task}{iter}, f{3, task}{iter}, flags{3, task}{iter}] = accelerated_s2_al(G, oracle, priority, budget);
    end
    te = toc(ts);
    Time{3,task} = [Time{3, task} te];
    
    fprintf('\n');
end

%% compare performance

fprintf('\nAnalyzing Performance');

query_complexity = {}; time_complexity = {};

FOCUS = 1;
for alg=1:3,
    for i=1:length(tasks),
        task = tasks(i);
        
        query_complexity{alg, task} = 0; focus_queries{alg, task} = 0;
        
        for iter=1:iters,
            
            for k=1:length(L{alg, task}{iter}),
                if isempty(setdiff(B{task}, L{alg, task}{iter}(1:k))); break, end;
            end
            
            query_complexity{alg, task} = query_complexity{alg, task} + k;
            focus_queries{alg, task} = focus_queries{alg, task} + length(find(flags{alg, task}{iter}));
        end
        
    end
end

for alg=1:3,
    fprintf('\nAlgorithm : %s\nGraph : \n', algs{alg});
    for i=1:length(tasks),
        task = tasks(i);
        fprintf('\t%s : \n', graphs{task});
        query_complexity{alg, task} = query_complexity{alg, task}/iters;
        fprintf('\t\tAverage query complexity : %.3f\n', query_complexity{alg, task})
        focus_queries{alg, task} = focus_queries{alg, task}/iters;
        fprintf('\t\tAverage number of focus queries : %.3f\n', focus_queries{alg, task})
        time_complexity{alg, task} = Time{alg, task}/iters;
        fprintf('\t\tAverage querying time complexity : %.3f\n\n', time_complexity{alg, task});
    end
end