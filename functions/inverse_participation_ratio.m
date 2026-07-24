function IPR = inverse_participation_ratio(v)
%==========================================================================
% INVERSE_PARTICIPATION_RATIO
%
% Computes the Inverse Participation Ratio (IPR) of a vector.
%
% The input vector is normalized before computation.
%
% INPUT
%   v : Eigenvector / centrality vector
%
% OUTPUT
%   IPR : Scalar localization measure
%
% Interpretation
%   High IPR  -> localized (few dominant stocks)
%   Low IPR   -> delocalized (many stocks contribute)
%==========================================================================

v = v(:);

nrm = norm(v);

if nrm == 0
    IPR = NaN;
    return;
end

v = v / nrm;

IPR = sum(v.^4);

end