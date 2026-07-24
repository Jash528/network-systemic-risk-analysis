function v = eigenvector_centrality(W, maxIter)
    % W: Weighted Adjacency Matrix (N x N)
    % maxIter: Maximum number of iterations for convergence
    
    N = size(W, 1);
    
    % 1. Initialize the centrality vector with 1s
    v = ones(N, 1);
    
    % 2. Power Iteration Loop
    for i = 1:maxIter
        v_prev = v;
        
        % Multiply by adjacency matrix
        v = W * v;
        
        % Normalize the vector (to prevent values from exploding)
        v = v / norm(v);
        
        % Optional: Check for convergence to stop early
        if norm(v - v_prev, 1) < 1e-6
            break;
        end
    end
end