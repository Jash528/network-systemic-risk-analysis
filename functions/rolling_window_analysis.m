function results = rolling_window_analysis(prices, dates, windowSize, stepSize, corrThreshold)
%==========================================================================
% ROLLING_WINDOW_ANALYSIS
%
% Computes systemic risk metrics using a rolling window.
%
% INPUTS
% -------
% prices         : T x N adjusted closing prices
% dates          : T x 1 datetime vector
% windowSize     : Rolling window length
% stepSize       : Sliding step
% corrThreshold  : Correlation threshold
%
% OUTPUT
% -------
% results : Structure containing rolling metrics
%==========================================================================

T = size(prices,1);

numWindows = floor((T-windowSize)/stepSize) + 1;

results.time = NaT(numWindows,1);

results.spectralRadius = zeros(numWindows,1);

results.lambda2 = zeros(numWindows,1);

results.AR = zeros(numWindows,1);

results.IPR = NaN(numWindows,1);

results.method = strings(numWindows,1);

fprintf('\nRunning rolling window analysis...\n');

k = 1;

for startIdx = 1:stepSize:(T-windowSize+1)

    endIdx = startIdx + windowSize - 1;

    windowPrices = prices(startIdx:endIdx,:);

    % Run the complete pipeline
    metrics = analyze_network(windowPrices,corrThreshold);

    results.time(k) = dates(endIdx);

    results.spectralRadius(k) = metrics.spectral_radius;

    results.lambda2(k) = metrics.lambda2;

    results.AR(k) = metrics.AR;

    if isfield(metrics,'IPR')
        results.IPR(k) = metrics.IPR;
    end

    results.method(k) = metrics.method;

    k = k + 1;

end

fprintf('Completed %d rolling windows.\n',numWindows);

end