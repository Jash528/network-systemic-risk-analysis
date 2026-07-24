function C = compute_correlation(Rz)
 [t,N] = size(Rz);
 C = (Rz' * Rz) ./ (t - 1);
 C(1:N+1:end) = 1;
end