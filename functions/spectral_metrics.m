function metrics = spectral_metrics(W, L)
    % W: Weighted Adjacency Matrix
    % L: Laplacian Matrix
    
    % 1. Calculate Spectral Radius from Adjacency Matrix W
    % The spectral radius is the maximum absolute eigenvalue
    W = (W + W')/2;

    metrics.spectral_radius = max(eig(full(W)));
    
    % 2. Calculate Laplacian Spectrum from L
    % We use 'full' because eig() is often more stable for the complete spectrum
    % unless the matrix is extremely large (thousands of nodes).
    lap_spectrum = sort(eig(full(L))); 
    metrics.laplacian_spectrum = lap_spectrum;
    
    % 3. Calculate lambda2 (Algebraic Connectivity)
    % This is the second smallest eigenvalue in the sorted spectrum.
    % In a Laplacian, the first eigenvalue is always 0.
    if length(lap_spectrum) >= 2
        metrics.lambda2 = lap_spectrum(2);
    else
        metrics.lambda2 = 0; % Case for a single-node graph
    end
end