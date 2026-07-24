function topTable = top_systemic_assets(centrality, tickers, k)

if nargin < 3
    k = 10;
end

[vals, idx] = sort(centrality,'descend');

idx = idx(1:k);

topTable = table(...
    (1:k)',...
    string(tickers(idx)),...
    vals(1:k),...
    'VariableNames',{'Rank','Ticker','EigenvectorCentrality'});

disp(topTable)

end