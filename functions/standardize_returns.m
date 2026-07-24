function Rz = standardize_returns(R)
    mu = mean(R,1);
    sigma = std(R,0,1);
    sigma(sigma == 0) = 1;   % prevent divide-by-zero
    Rz = (R - mu) ./ sigma;
end
