#' Fit mixed effects spline model
#'
#' Fits a spline model to longitudinal data with random effects for individual baseline levels
#'
#' @param i factor denoting what individual the sample is from
#' @param t numeric denoting time of sampling
#' @param f numeric feature value
#' @param A design matrix for spline basis
#'
#' @return list containing mod (fittet model object), pval (p-value for test of significant spline) and coef (coefficients from fitted model)
fit_spline <- function(i, t, f, A){
	dat <- data.frame(ind=i, ga=t, fc=f)
	mod <- lme4::lmer(fc ~ A + (1 | ind), data = dat)

	coef <- try(lmerTest::summary(mod)$coef[,1], silent=TRUE)
	if(class(coef)=="try-error"){
		coef<- NA
	}
	ano_mdl <- lmerTest::anova(mod)
	pval <- ano_mdl$`Pr(>F)`
	if(is.null(pval)){
		pval <- NA
	}
	return(list(mod=mod, pval=pval, coef=coef))
}

