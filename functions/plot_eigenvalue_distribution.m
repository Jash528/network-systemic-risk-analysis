function plot_eigenvalue_distribution(lambda,titleText)

figure

histogram(lambda,40)

xlabel('Eigenvalue')

ylabel('Frequency')

title(['Eigenvalue Distribution : ' titleText])

grid on

end