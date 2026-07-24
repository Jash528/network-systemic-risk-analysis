function plot_network(W,tickers,titleText)

figure

G = graph(W,'upper');

p = plot(G,...
    'Layout','force',...
    'NodeLabel',[]);

p.MarkerSize = 3;
p.LineWidth = 0.2;

title(titleText)

end