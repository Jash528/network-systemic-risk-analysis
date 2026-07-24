function chunk_results = analyze_market_regimes(Rz, dates)
    % dates: a datetime array corresponding to the rows of Rz
    
    % 1. Define the Regimes
    regimes = {
        'Pre-COVID',   datetime(2018,1,1),   datetime(2020,2,20);
        'COVID-Era',   datetime(2020,2,21),  datetime(2021,12,31);
        'Post-COVID',  datetime(2022,1,1),   datetime(2023,12,31)
    };
    
    numRegimes = size(regimes, 1);
    numStocks = size(Rz, 2);
    k_ar = max(1, round(numStocks * 0.1)); % Top 10%
    
    % Initialize results structure
    chunk_results = struct();

    for i = 1:numRegimes
        % Extract indices for this regime
        name = regimes{i, 1};
        mask = (dates >= regimes{i, 2}) & (dates <= regimes{i, 3});
        chunkData = Rz(mask, :);
        T_chunk = size(chunkData, 1);
        
        fprintf('Processing %s: %d days...\n', name, T_chunk);
        
        % A. Compute Correlation
        C = (chunkData' * chunkData) ./ (T_chunk - 1);
        C(1:numStocks+1:end) = 1; % Ensure diagonal is 1
        
        % B. Denoise with MP Law
        % The iterative MP function will find a unique sigma for each regime
        [C_clean, lambda, lambda_mp] = mp_denoise_corr(C, T_chunk);
        
        % C. Calculate Metrics
        W = build_adjacency(C_clean, 0.5); 
        L = compute_laplacian(W);
        spec = spectral_metrics(W, L);
        
        % D. Store Results
        chunk_results.(genvarname(name)).name = name;
        chunk_results.(genvarname(name)).absorption_ratio = absorption_ratio(C_clean, k_ar);
        chunk_results.(genvarname(name)).spectral_radius = spec.spectral_radius;
        chunk_results.(genvarname(name)).lambda2 = spec.lambda2;
        chunk_results.(genvarname(name)).sigma_sq_noise = (lambda_mp(2) / (1 + sqrt(numStocks/T_chunk))^2);
    end
end