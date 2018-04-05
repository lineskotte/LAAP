#' Simulation of sample meta data
#'
#' Simulates m random sample timepoints for n individuals
#'
#' @param n integer number of individuals
#' @param m integer number of samples per individual
#' @param r1 integer(days) start of possible sampling period
#' @param r2 integer(days) end of possible sampling period
#'
#' @return Data-frame of meta (individual and timepoint) data for each sample
#'
#' @export
sim_meta_data <- function(n=20, m=30, r1=0, r2=40*7){
	# Timepoints
	t <- replicate(n = n, expr = sample(x = r1:r2, size = m, replace = FALSE))
	# Return data-frame
	ret <-data.frame(ind=as.character(rep(1:n, each=m)),t=c(t), stringsAsFactors = FALSE)
	return(ret)
}

#meta <- sim_meta_data()
#str(meta)
#i <- meta$ind


#' Simulate measurements of single analyte
#'
#' Simulate measurements of single analyte based on individual and timepoint for the sample
#'
#' @param i vector naming the individual to which the sample belongs
#' @param t vector timepoint sample was taken
#' @param v1 standard deviation for random effect in individual baseline level
#' @param v2 standard deviation for measurement noise
#' @param t1 start timepoint for increase in analyte level
#' @param t2 timepoint for return to baseline individual level
#' @param h max level for analyte (reached just prior to t2)
#'
#' @return Analyte levels (same order as input order)
#'
#' @export
sim_single_analyte <- function(i, t, v1=1, v2=1, t1=20*7, t2=25*7, h=6){
	# remember to add
	inds <- levels(as.factor(i))
	l <- rnorm(n = length(inds), mean = 0, sd = v1)
	names(l) <- inds
	# Value generating function (change here for other shapes)
	get_val <- function(ii,tt){
		(tt>t1)*(tt<t2)*(tt-t1)*h/(t2-t1) + l[ii]
	}
	# Analyte values
	v <- sapply(X = 1:length(i), FUN = function(k){get_val(i[k],t[k])})
	# Adding measurement noise
	a <- v + rnorm(n = length(i), mean = 0, sd = v2)
	return(a)
}

#' Simulate test dataset for longitudinal analysis of analyte patterns
#'
#' Simulate random sampling time and analyte level for set of analytes
#'
#' @param n integer number of individuals
#' @param m integer number of samples per individual
#' @param r1 integer(days) start of possible sampling period
#' @param r2 integer(days) end of possible sampling period
#' @param v1 standard deviation for random effect in individual baseline level
#' @param v2 standard deviation for measurement noise
#' @param t1 start timepoint for increase in analyte level
#' @param t2 timepoint for return to baseline individual level
#' @param h max level for analyte (reached just prior to t2)
#'
#' @return List with meta data (individual and timepoint) for each sample and analytes (analyte levels)
#'
#' @export
sim_test_data <- function(n=20, m=30, r1=0, r2=40*7, v1=1, v2=1, t1=rep(20*7, 500), t2=rep(25*7, 500), h=rep(c(0,6), each=250)){
	meta <- sim_meta_data(n=n, m=m, r1=r1, r2=r2)
	sims <- length(t1)
	as <- sapply(X = 1:sims, FUN = function(x){sim_single_analyte(meta$ind, meta$t, v1=v1, v2=v1, t1=t1[x], t2=t2[x], h=h[x])})
	return(list(meta=meta, analytes=as))
}


#tmp <- sim_test_data()
#str(tmp)

