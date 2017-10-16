df <- ToothGrowth
df$dose <- as.factor(df$dose)
data_summary <- function(data, varname, groupnames){
    require(plyr)
    
    summary_func <- function(x, col){
        c(mean = mean(x[[col]], na.rm=TRUE),
        sd = sd(x[[col]], na.rm=TRUE))
    }
    
    data_sum<-ddply(data, groupnames, .fun=summary_func,
    varname)
    data_sum <- rename(data_sum, c("mean" = varname))
    return(data_sum)
}

df2 <- data_summary(ToothGrowth, varname="len",
    groupnames=c("supp", "dose"))
head(df2)

p <- ggplot(df2, aes (x= dose, y=len, fill = supp)) +
    geom_bar(stat="identity", color="black", 
         position=position_dodge()) +
    geom_errorbar(aes(ymin=len-sd, ymax=len+sd), width=.2,
                  position=position_dodge(.5)) 
print(p)



