library(ncdf4)
library(ncdf4)
ncin <- nc_open("~/Downloads/GEOS.fp.asm.tavg3_2d_aer_Nx.20150815_1330.V01.nc4")

# get lon
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)

# get lat
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)

# get time
time <- ncvar_get(ncin,"time")
time