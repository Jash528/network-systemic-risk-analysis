function plot_rolling_results(results)
%==========================================================================
% PLOT_ROLLING_RESULTS
%
% Visualizes rolling systemic risk metrics.
%
% INPUT
% -----
% results : structure returned by rolling_window_analysis()
%
%==========================================================================

%% -----------------------------
% Spectral Radius
%% -----------------------------

figure;

plot(results.time,...
     results.spectralRadius,...
     'LineWidth',1.8);

grid on;

xlabel('Date');

ylabel('Spectral Radius');

title('Rolling Spectral Radius');

%% -----------------------------
% Algebraic Connectivity
%% -----------------------------

figure;

plot(results.time,...
     results.lambda2,...
     'LineWidth',1.8);

grid on;

xlabel('Date');

ylabel('\lambda_2');

title('Rolling Algebraic Connectivity');

%% -----------------------------
% Absorption Ratio
%% -----------------------------

figure;

plot(results.time,...
     results.AR,...
     'LineWidth',1.8);

grid on;

xlabel('Date');

ylabel('Absorption Ratio');

title('Rolling Absorption Ratio');

%% -----------------------------
% IPR
%% -----------------------------

if isfield(results,'IPR')

    figure;

    plot(results.time,...
         results.IPR,...
         'LineWidth',1.8);

    grid on;

    xlabel('Date');

    ylabel('IPR');

    title('Rolling Inverse Participation Ratio');

end

hold on

xline(datetime(2020,3,11),...
    '--r',...
    'WHO Pandemic',...
    'LineWidth',1.5);

xline(datetime(2022,1,1),...
    '--k',...
    'Recovery',...
    'LineWidth',1.5);

grid on

end