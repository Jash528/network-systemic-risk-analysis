function L = compute_laplacian(W)
    % 1. Ensure W is symmetric and remove self-loops (diagonal)
    % Standardizes the adjacency matrix for graph operations
    W = (W + W') / 2;
    W = W - diag(diag(W));
    
    % 2. Compute the Degree vector (sum of weights for each node)
    d = sum(W, 2);
    
    % 3. Compute D^(-1/2)
    % Handles nodes with zero degrees (isolated assets) to avoid division by zero
    d_inv_sqrt = d.^(-0.5);
    d_inv_sqrt(isinf(d_inv_sqrt) | isnan(d_inv_sqrt)) = 0;
    D_inv_sqrt = diag(d_inv_sqrt);
    
    % 4. Compute the Symmetric Normalized Laplacian: L = I - D^-1/2 * W * D^-1/2
    % This normalizes the spectrum to the [0, 2] range for regime comparison
    n = size(W, 1);
    L = eye(n) - (D_inv_sqrt * W * D_inv_sqrt);
end
