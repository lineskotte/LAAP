# laap
Longitudinal Analysis of Analyte Patterns

# What is laap

laap is an R package for longitudinal analysis of densely sampled high-troughput data, such as RNA-sequencing transcriptomics or mass spectrometry metabolomics.

# Installation

The package can be installed with

    devtools::install_github("lineskotte/laap")

After installation, the package can be loaded into R.

    library(laap)

# Using laap

The main function in the **laap** package is `laap()`.

```
# Simulate test data
sim <- sim_test_data()
i <- sim[["meta"]]$ind
t <- sim[["meta"]]$t
L <- sim[["analytes"]]
# Fit and return models, pvalues and coefficients
results <- laap(i = i, t = t, L = L, k = 8)
```

# Bug reports
Report bugs as issues on the [GitHub repository](https://github.com/lineskotte/laap)

# Contributors

* [Line Skotte](https://github.com/lineskotte)

# Acknowledgements

The development of this software was supported by the Carlsberg Foundation.
