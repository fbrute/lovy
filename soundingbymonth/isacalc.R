library(RMySQL)

calcisalelt <- function (z,thtv) {
    thtv1 = rep(thtv[1], length(thtv) -1)
    thtvn = head(thtv, length(thtv) -1)
    thtvnplus1 = tail(thtv, length(thtv) -1)
    zn = head(z, length(z) -1)
    znplus1 = tail(z, length(z) -1)
    
   (znplus1 - zn)/2 * ( (thtv1 - thtvnplus1) / thtvnplus1 +  (thtv1 - thtvn) / thtvn)
}

calcisal <- function (isalvector) {
    sum(isalvector) * 9.81
}