% This script reproduces the results from bit.ly/pk_a2s2
% It implements the driver code to run S2, BFS, and Accelerated S2 
% on different datasets and compare their query complexity and querying 
% time complexity.

%% Init

clc; clear; close all;
w = warning ('off','all');

%% Define Experiments

% algorithms and datasets to evaluate
algorithms = {'S2', 'BFS', 'A2S2'};
datasets = {'MNIST1v4', 'MNIST4v9', 'Grid'};

% number of times to run algorithm on dataset
num_iterations = 2;

%% Set Experiment Variables

grid_dim = 2;
side_length = 15;
core_length = 8;

%% Create Result Placeholders

% total queries required to find cut set
query_complexities = zeros(length(datasets), length(algorithms), num_iterations);
% total query time required to find cut
run_times = zeros(length(datasets), length(algorithms), num_iterations);

%% Run Experiments

for dataset_idx = 1:length(datasets)
    
    % load dataset
    dataset = datasets{dataset_idx};    
    switch dataset
        case 'TwitterCT', load data/twitter/trigrams
        case 'TwitterBoW', load data/twitter/words
        case 'TwitterTF', load data/twitter/days
        case 'MNIST1v4', load data/oddeven/1v2
        case 'MNIST4v9', load data/oddeven/4v9
        case 'CVR', load data/congressionalVoting/cvr
        case 'Grid', [G,oracle,~] = build_grid_graph(grid_dim, side_length, core_length);
    end

    num_nodes = size(G, 1);    
    
    % uniform priority for each node
    node_priority = ones(num_nodes, 1)./num_nodes;
    
    % max number of label queries
    max_queries = num_nodes;

    % cut set boundary of the graph defined by oracle
    graph_boundary = retrieve_boundary(G, oracle);
    
    % extract label boundary for graph
    print_graph_info(G, oracle, dataset);
    
    for iteration = 1:num_iterations
            
        for algorithm_idx = 1:length(algorithms)

            algorithm = algorithms{algorithm_idx};

            switch algorithm

                case 'S2'
                    start_time = tic;
                    [queries, ~, ~] = s2_active_learning(G, oracle, node_priority, max_queries);
                    time_delta = toc(start_time);

                case 'BFS'
                    start_time = tic;
                    [queries, ~, ~] = bfs_active_learning(G, oracle, node_priority, max_queries);
                    time_delta = toc(start_time);

                case 'A2S2'
                    ts = tic;
                    [queries, ~, ~] = a2s2_active_learning(G, oracle, node_priority, max_queries);
                    time_delta = toc(start_time);
            end
            
            % retrieve number of queries to exactly find cut set
            for valid_queries = 1:length(queries)
                if isempty(setdiff(graph_boundary, queries(1:valid_queries)))
                    break
                end
            end
            
            query_complexities(dataset_idx, algorithm_idx, iteration) = valid_queries;
            run_times(dataset_idx, algorithm_idx, iteration) = time_delta;

        end
        
    end
    
    % evaluate results
    average_query_complexities = mean(query_complexities(dataset_idx, :, :), 3);
    average_run_times = mean(run_times(dataset_idx, :, :) , 3);
    for algorithm_idx = 1:length(algorithms)
        algorithm = algorithms{algorithm_idx};
        average_query_complexity = average_query_complexities(algorithm_idx);
        average_run_time = average_run_times(algorithm_idx);
        fprintf('\nAlgorithm: %s', algorithm);
        fprintf('\n  Mean query complexity: %.2f', average_query_complexity);
        fprintf('\n  Mean querying time complexity: %.2f\n\n', average_run_time);
    end
    fprintf('--------------------------------------');
    
end