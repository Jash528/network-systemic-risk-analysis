function [C_clean, lambda, lambda_mp] = mp_denoise_corr(C, T, returns)
%==========================================================================
% MP_DENOISE_CORR
%
% Cleans an empirical correlation matrix using:
%   1. Marchenko-Pastur eigenvalue filtering (Q >= 1)
%   2. Ledoit-Wolf shrinkage (Q < 1)
%
% INPUTS
% -------
% C        : Empirical correlation matrix (N x N)
% T        : Number of observations
% returns  : Standardized return matrix (T x N)
%
% OUTPUTS
% --------
% C_clean   : Cleaned correlation matrix
% lambda    : Eigenvalues of cleaned matrix
% lambda_mp : [lambda_minus lambda_plus]
%==========================================================================

%% Ensure symmetry

C = (C + C') / 2;

N = size(C,1);

Q = T / N;

%% =======================================================================
% CASE 1 : Insufficient observations
% Use Ledoit-Wolf shrinkage
%% =======================================================================

if Q < 1

    Target = eye(N);

    X2 = returns.^2;

    phi_mat = (X2' * X2)/T - C.^2;

    phi = sum(phi_mat(:));

    gamma = norm(C - Target,'fro')^2;

    gamma = max(gamma,eps);

    delta = max(0,min(1,(phi/gamma)/T));

    C_clean = delta*Target + (1-delta)*C;

    C_clean = (C_clean + C_clean')/2;

    d = sqrt(diag(C_clean));

    C_clean = C_clean ./ (d*d');

    [~,D] = eig(C_clean);

    lambda = sort(diag(D),'descend');

    lambda_mp = [0 0];

    return;

end

%% =======================================================================
% CASE 2 : Marchenko-Pastur filtering
%% =======================================================================

[V,D] = eig(C);

lambda = diag(D);

[lambda,idx] = sort(lambda,'descend');

V = V(:,idx);

invQ = 1/Q;

sigma2 = 1;

while true

    lambda_plus = sigma2*(1+sqrt(invQ))^2;

    signal = lambda > lambda_plus;

    nSignal = sum(signal);

    if nSignal==0

        break;

    end

    if nSignal==N

        break;

    end

    sigma_new = mean(lambda(~signal));

    if abs(sigma_new-sigma2) < 1e-8

        sigma2 = sigma_new;

        break;

    end

    sigma2 = sigma_new;

end

lambda_plus  = sigma2*(1+sqrt(invQ))^2;

lambda_minus = sigma2*(1-sqrt(invQ))^2;

lambda_mp = [lambda_minus lambda_plus];

lambda_clean = lambda;

noise = lambda <= lambda_plus;

if any(noise)

    lambda_clean(noise) = mean(lambda(noise));

end

C_clean = V*diag(lambda_clean)*V';

C_clean = (C_clean+C_clean')/2;

d = sqrt(diag(C_clean));

C_clean = C_clean./(d*d');

C_clean = (C_clean+C_clean')/2;

[~,D] = eig(C_clean);

lambda = sort(diag(D),'descend');

end