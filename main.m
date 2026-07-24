%% ============================================================
% Network-Based Systemic Risk Analysis
%
% Features:
%   1. Static Regime Analysis
%   2. Rolling Window Analysis
%   3. Graph Spectral Measures
%   4. Random Matrix Denoising
%% ============================================================

clear;
clc;
close all;

%% ------------------------------------------------------------
% Project Setup
%% ------------------------------------------------------------

projectRoot = fileparts(mfilename('fullpath'));
addpath(fullfile(projectRoot,'functions'));

%% ------------------------------------------------------------
% User Settings
%% ------------------------------------------------------------

INDEX = "SP500";
% INDEX = "NIFTY50";

CORR_THRESHOLD = 0.30;

WINDOW_SIZE = 252;
STEP_SIZE   = 5;

%% ------------------------------------------------------------
% Select Dataset
%% ------------------------------------------------------------

switch INDEX

    case "SP500"

        csvFile = fullfile(projectRoot,...
            'data','raw_data',...
            'SP500_prices_stable.csv');

    case "NIFTY50"

        csvFile = fullfile(projectRoot,...
            'data','raw_data',...
            'Nifty50_prices_stable.csv');

    otherwise

        error('Unknown dataset.');

end

%% ------------------------------------------------------------
% Load Data
%% ------------------------------------------------------------

[prices,dates,tickers] = load_index_data(csvFile);

fprintf('\n');
fprintf('=========================================\n');
fprintf('Financial Network Analysis\n');
fprintf('=========================================\n');
fprintf('Dataset          : %s\n',INDEX);
fprintf('Assets           : %d\n',length(tickers));
fprintf('Trading Days     : %d\n\n',length(dates));

%% ------------------------------------------------------------
% Define Market Regimes
%% ------------------------------------------------------------

regimes = {

'Pre_COVID'  datetime(2018,1,1)  datetime(2020,2,20);

'COVID_Era'  datetime(2020,2,21) datetime(2021,12,31);

'Post_COVID' datetime(2022,1,1)  datetime(2023,12,31);

};

results = struct();

%% ============================================================
% REGIME ANALYSIS
%% ============================================================

fprintf('=========================================\n');
fprintf('REGIME ANALYSIS\n');
fprintf('=========================================\n');

for k = 1:size(regimes,1)

    regimeName = regimes{k,1};
    startDate  = regimes{k,2};
    endDate    = regimes{k,3};

    idx = dates >= startDate & dates <= endDate;

    regimePrices = prices(idx,:);

    fprintf('\nProcessing %s ...\n',strrep(regimeName,'_',' '));

    %% --------------------------------------------------------
    % Analyse Network
    %% --------------------------------------------------------

    metrics = analyze_network(regimePrices,CORR_THRESHOLD);

    %% --------------------------------------------------------
    % Top Systemic Assets
    %% --------------------------------------------------------

    topTable = top_systemic_assets(...
        metrics.centrality,...
        tickers,...
        10);

    metrics.topAssets = topTable;

    metrics.topAsset = char(topTable.Ticker(1));

    %% --------------------------------------------------------
    % Store Results
    %% --------------------------------------------------------

    results.(regimeName) = metrics;

    %% --------------------------------------------------------
    % Figures
    %% --------------------------------------------------------

    plot_network(metrics.W,tickers,strrep(regimeName,'_',' '));

    plot_laplacian_spectrum(metrics,...
        strrep(regimeName,'_',' '));

    plot_eigenvalue_distribution(metrics.eigenvalues,...
        strrep(regimeName,'_',' '));

    %% --------------------------------------------------------
    % Console Output
    %% --------------------------------------------------------

    fprintf('Method                 : %s\n',metrics.method);

    if metrics.method == "Marchenko-Pastur Denoising"

        fprintf('MP Bounds              : [%.4f %.4f]\n',...
            metrics.lambda_mp(1),...
            metrics.lambda_mp(2));

    end

    fprintf('Spectral Radius        : %.4f\n',...
        metrics.spectral_radius);

    fprintf('Algebraic Connectivity : %.4f\n',...
        metrics.lambda2);

    fprintf('Absorption Ratio       : %.4f\n',...
        metrics.AR);

    fprintf('IPR                    : %.6f\n',...
        metrics.IPR);

    fprintf('Top Asset              : %s\n',...
        metrics.topAsset);

    disp(metrics.topAssets);

end

%% ============================================================
% SUMMARY
%% ============================================================

fprintf('\n');
fprintf('=========================================\n');
fprintf('SUMMARY\n');
fprintf('=========================================\n\n');

fields = fieldnames(results);

for i = 1:length(fields)

    m = results.(fields{i});

    fprintf('%-15s',fields{i});
    fprintf(' Radius = %8.3f',m.spectral_radius);
    fprintf('   λ2 = %8.4f',m.lambda2);
    fprintf('   AR = %6.4f',m.AR);
    fprintf('\n');

end

%% ============================================================
% ROLLING WINDOW ANALYSIS
%% ============================================================

fprintf('\n');
fprintf('=========================================\n');
fprintf('ROLLING WINDOW ANALYSIS\n');
fprintf('=========================================\n');

rollingResults = rolling_window_analysis(...
    prices,...
    dates,...
    WINDOW_SIZE,...
    STEP_SIZE,...
    CORR_THRESHOLD);

fprintf('\nRolling window analysis completed.\n');

%% ============================================================
% VISUALISATIONS
%% ============================================================

plot_regime_results(results);

plot_rolling_results(rollingResults);

%% ============================================================
% SAVE RESULTS
%% ============================================================

if ~exist(fullfile(projectRoot,'results'),'dir')

    mkdir(fullfile(projectRoot,'results'));

end

save(fullfile(projectRoot,...
    'results',...
    'systemic_risk_results.mat'),...
    'results',...
    'rollingResults');

fprintf('\nResults saved successfully.\n');