function [prices, dates, tickers] = load_index_data(csvFile)

    % Read CSV
    T = readtable(csvFile,'VariableNamingRule','preserve');

    % Convert Date column
    T.Date = datetime(T.Date, 'InputFormat', 'yyyy-MM-dd');

    % Extract data
    dates   = T.Date;
    prices  = T{:, 2:end};
    tickers = T.Properties.VariableNames(2:end)';

    % Remove rows with any missing prices
    validRows = all(~isnan(prices), 2);
    prices = prices(validRows, :);
    dates  = dates(validRows);

end
