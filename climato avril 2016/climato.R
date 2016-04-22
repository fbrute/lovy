setwd("~/Documents/lovy/climato avril 2016")

mainClimato <- function () {
    clima.df = read.csv2("climato.csv")
    x_string = "year"
    y_string = "nb_events"
    colnames(clima.df) <- c(y_string, x_string)
    library("ggplot2")
    g <- ggplot(clima.df, aes_string(x_string ,y_string))  
    #     scale_x_discrete("year",labels = c(2005,2006,2007,2008,2009,2010,2011,2012,2015)) 
    
    #+ labs(x="années", y= "nombre d'événements" )
    
    g <- g + geom_point()
    print(g)
}

