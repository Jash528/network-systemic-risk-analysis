function plot_regime_results(results)
%==========================================================================
% PLOT_REGIME_RESULTS
%
% Visualizes the systemic risk metrics for each market regime.
%
% INPUT
% -----
% results : structure returned by main.m
%
%==========================================================================
%
% Example:
%
%   plot_regime_results(results)
%
%==========================================================================

fields = fieldnames(results);

n = length(fields);

names = strings(n,1);

spectralRadius = zeros(n,1);
lambda2 = zeros(n,1);
AR = zeros(n,1);
IPR = zeros(n,1);

for i = 1:n

    names(i) = strrep(fields{i},'_',' ');

    spectralRadius(i) = results.(fields{i}).spectral_radius;

    lambda2(i) = results.(fields{i}).lambda2;

    AR(i) = results.(fields{i}).AR;

    if isfield(results.(fields{i}),'IPR')
        IPR(i) = results.(fields{i}).IPR;
    else
        IPR(i) = NaN;
    end

end

%% ==========================================================
% Spectral Radius
%% ==========================================================

figure;

bar(spectralRadius);

xticks(1:n);
xticklabels(names);

ylabel('Spectral Radius');

title('Spectral Radius Across Market Regimes');

grid on;

%% ==========================================================
% Algebraic Connectivity
%% ==========================================================

figure;

bar(lambda2);

xticks(1:n);
xticklabels(names);

ylabel('\lambda_2');

title('Algebraic Connectivity');

grid on;

%% ==========================================================
% Absorption Ratio
%% ==========================================================

figure;

bar(AR);

xticks(1:n);
xticklabels(names);

ylabel('Absorption Ratio');

title('Absorption Ratio');

grid on;

%% ==========================================================
% IPR
%% ==========================================================

if ~all(isnan(IPR))

    figure;

    bar(IPR);

    xticks(1:n);
    xticklabels(names);

    ylabel('Inverse Participation Ratio');

    title('Eigenvector Localization');

    grid on;

end

end