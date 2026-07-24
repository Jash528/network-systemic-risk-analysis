function metrics = analyze_network(prices, corrThreshold)
%==========================================================================
% ANALYZE_NETWORK
%
% Performs the complete systemic risk pipeline for one market regime.
%
% INPUTS
% ------
% prices          : T x N matrix of adjusted closing prices
% corrThreshold   : Correlation threshold (e.g. 0.30)
%
% OUTPUT
% -------
% metrics : structure containing all computed quantities
%
%==========================================================================

%% ------------------------------------------------------------------------
% 1. Compute standardized log returns
%% ------------------------------------------------------------------------

R = compute_log_returns(prices);
Rz = standardize_returns(R);

T = size(Rz,1);

%% ------------------------------------------------------------------------
% 2. Correlation Matrix
%% ------------------------------------------------------------------------

C = compute_correlation(Rz);

%% ------------------------------------------------------------------------
% 3. Random Matrix Denoising
%% ------------------------------------------------------------------------

[C_clean, lambda, lambda_mp] = mp_denoise_corr(C,T,Rz);

%% ------------------------------------------------------------------------
% 4. Build weighted adjacency matrix
%% ------------------------------------------------------------------------

W = abs(C_clean);

% Remove self-loops
W(1:size(W,1)+1:end) = 0;

% Threshold weak correlations
if corrThreshold > 0
    W(W < corrThreshold) = 0;
end

%% ------------------------------------------------------------------------
% 5. Graph Laplacian
%% ------------------------------------------------------------------------

L = compute_laplacian(W);

%% ------------------------------------------------------------------------
% 6. Spectral Metrics
%% ------------------------------------------------------------------------

spec = spectral_metrics(W,L);

%% ------------------------------------------------------------------------
% 7. Absorption Ratio
%% ------------------------------------------------------------------------

K = 5;

AR = absorption_ratio(C_clean,K);

%% ------------------------------------------------------------------------
% 8. Eigenvector Centrality
%% ------------------------------------------------------------------------

centrality = eigenvector_centrality(W,100);

%% ------------------------------------------------------------------------
% 9. Inverse Participation Ratio
%% ------------------------------------------------------------------------

IPR = inverse_participation_ratio(centrality);

%% ------------------------------------------------------------------------
% 10. Store Results
%% ------------------------------------------------------------------------

metrics = struct();

% Network matrices
metrics.C = C;
metrics.C_clean = C_clean;
metrics.W = W;
metrics.L = L;

% Eigenvalues
metrics.eigenvalues = lambda;
metrics.lambda_mp = lambda_mp;

% Spectral quantities
metrics.spectral_radius = spec.spectral_radius;
metrics.lambda2 = spec.lambda2;
metrics.laplacian_spectrum = spec.laplacian_spectrum;

% Systemic risk metrics
metrics.AR = AR;
metrics.IPR = IPR;

% Centrality
metrics.centrality = centrality;

%% ------------------------------------------------------------------------
% 11. Method Used
%% ------------------------------------------------------------------------

N = size(C,1);

if T < N
    metrics.method = "Ledoit-Wolf Shrinkage";
else
    metrics.method = "Marchenko-Pastur Denoising";
end

end