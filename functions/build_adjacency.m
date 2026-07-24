function W = build_adjacency(C, threshold)
% BUILD_ADJACENCY Constructs weighted adjacency matrix from correlations

    C = abs(C);                % <<< CRITICAL
    C(eye(size(C)) == 1) = 0;  % remove self-loops

    W = C .* (C >= threshold);
end
