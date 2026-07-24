function plot_laplacian_spectrum(metrics,titleText)

figure

plot(metrics.laplacian_spectrum,...
    'LineWidth',2)

xlabel('Eigenvalue Index')

ylabel('\lambda')

title(['Laplacian Spectrum : ' titleText])

grid on

end