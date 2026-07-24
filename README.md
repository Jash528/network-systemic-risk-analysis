# Network-Based Systemic Risk Analysis Using Graph Spectral Measures
This project models financial markets as weighted correlation networks and studies systemic risk using graph spectral methods.
The analysis compares multiple market regimes (Pre-COVID, COVID Era, and Post-COVID) using network topology, Random Matrix Theory, and spectral graph analysis.
The implementation is entirely in MATLAB and focuses on transparent linear algebra rather than high-level graph toolboxes.

## Features
- Log-return transformation
- Z-score standardization
- Correlation network construction
- Marchenko-Pastur denoising
- Ledoit-Wolf shrinkage
- Minimum Spanning Tree
- Spectral Radius
- Algebraic Connectivity
- Eigenvector Centrality
- Absorption Ratio
- Inverse Participation Ratio
- Rolling Window Analysis

## Mathematical Methods
### Correlation Matrix
\[
C = corr(R)
\]

### Graph Laplacian
\[
L = I-D^{-1/2}WD^{-1/2}
\]

### Spectral Radius
Largest eigenvalue of the weighted adjacency matrix.

### Algebraic Connectivity
Second-smallest eigenvalue of the normalized Laplacian.

### Absorption Ratio
Fraction of variance explained by the leading eigenvectors.

### Inverse Participation Ratio
Measures localization of the dominant eigenvector.

### Marchenko-Pastur Filtering
Separates signal eigenvalues from random noise using Random Matrix Theory.

## Repository Structure

main.m

functions/

data/

figures/

results/

## Dataset
- S&P 500 (2018–2023)
- NIFTY 50 (2018–2023)
Source: Yahoo Finance

