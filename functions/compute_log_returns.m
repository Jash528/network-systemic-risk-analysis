function R = compute_log_returns(prices)
    if any(prices(:) <= 0)
        error('Prices must be strictly positive to compute log-returns.');
    end

    R = diff(log(prices), 1, 1);  % difference along time dimension
end