#' Fit mixed effects spline models for all analytes
#'
#' Fits a spline model to longitudinal data with random effects for individual baseline levels for all analytes in dataframe
#'
#' @param i factor denoting what individual the sample is from
#' @param t numeric denoting time of sampling
#' @param L numeric matrix of feature values / analyte levels
#' @param k number of knots in spline basis
#'
#' @return list containing pval (p-values for test of significant spline) and coef (coefficients from fitted model)
#'
#' @export
laap <- function(i, t, L, k){
	# Ordering according to gestational age for assignment of knots for the spline base
	i <- i[order(t)]
	t <- t[order(t)]

	# Getting design matrix for spline basis
	kts <- seq(min(t), max(t), length = k+2)[2:(k+1)]
	A <- fda::bs(t, knots = kts, intercept = FALSE) # Note: lmer includes intercept

	nanalyte <- dim(L)[2]
	analytes <- colnames(L)

	system.time(
		fits <- mclapply(X = 1:nanalyte, FUN = function(j){fit_spline(i=i, t=t, f=L[,j], A=A)},
										 mc.cores = 9, mc.set.seed = 1, mc.cleanup = TRUE)
	)

	return(fits)
	}



#save(fits, file = "mods_and_pvals_and_coef_server_run.Rdata")
