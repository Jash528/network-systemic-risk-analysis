function AR = absorption_ratio(C, k)

    lambda = eig(C);
    lambda = real(lambda);

    % Numerical safety
    lambda(lambda < 0) = 0;

    lambda_sorted = sort(lambda, 'descend');

    % ---- CRITICAL FIX ----
    k = min(k, numel(lambda_sorted));

    AR = sum(lambda_sorted(1:k)) / sum(lambda_sorted);
end
