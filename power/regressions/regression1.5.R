mainreg = function (){
        dbg = 0
        
        library(RMySQL)
        library(ggplot2)
        
        load("~/Documents/Trafin/lovy/soundingbymonth/df.powers2k12.RData")
        
        
        QueryString = "select date(datetime) as date, avg(pmptp) as pm10 from pm10 where year(datetime) = 2012 and pmptp > 0 group by date(datetime) order by date(datetime)"
        df.pm10 = getMysqlData(QueryString)
        
        entropic = 19.4058
        #entropic = 22
        df.pm10$pm10 = ifelse((df.pm10$pm10 - entropic) >= 0,df.pm10$pm10 - entropic , 0)
        
        df.pm10 = subset(df.pm10, pm10>0)
        
        df.powers = subset(df.powers, as.character.factor(date) >= "2012-05-01"
                           & as.character.factor(date) <= "2012-08-31")
        
        df.pmpowers <- merge(df.powers, df.pm10, by=c("date"),all.x = T, all.y = T)
        # plot(df.pmpowers$power, df.pmpowers$pm10)
        # 
        # g <- ggplot(df.pmpowers)
        # #g + aes(power, pm10) + geom_point() + geom_smooth(method="lm")
        # g + aes(power, pm10) + geom_point(alpha = 1/3) + geom_smooth(method="lm")
        #lm( power ~ pm10, df.pmpowers)
        
        #cor(df.pmpowers$power, df.pmpowers$pm10, use = "complete.obs")
        
        #QueryString = "select distinct date, inversion from sounding2 where year(date) = 2012 and month(date) = 7  and time = '12:00:00' order by date"
        #df.inversions = getMysqlData(QueryString)
        
        if (dbg) browser()
        
        
        if (dbg) browser()
        df.pminvpowers <- within(na.omit(df.pmpowers), 
                                    inversion <- cut(power, quantile(power,
                                                                     na.rm = TRUE), 
                                                    include.lowest=TRUE, 
                                                    labels=c("weak","average","strong","very strong"))
                                    )
        
        if (dbg) browser()
        
        dfs <- split(df.pminvpowers, df.pminvpowers$inversion)
        
        cors = round(as.numeric(unlist(
                        lapply(dfs, function(elt) cor(x=elt$pm10, y=elt$power, use ="complete.obs"))
                        )
                        )
                ,2)
        df.cors <- data.frame(levels(df.pminvpowers$inversion), cors)
        colnames(df.cors) <- c("inversion", "cor")
        library(dplyr)
        df.cors <- mutate(df.cors, cor = paste("cor:", cor, sep="")) 
        row.names(df.cors) <- 1:4
        
        if (dbg) browser()
        
        g <- ggplot(df.pminvpowers)
        #g + aes(power, pm10) + geom_point() + geom_smooth(method="lm")
        #ginv = g + aes(power, pm10) + facet_wrap(~ inversion, scales = "free") + geom_point(alpha = 1/3) + geom_smooth(method="lm") 
        ginv = g + aes(power, pm10) + facet_wrap(~ inversion) + geom_point(alpha = 1/3) + geom_smooth(method="lm") 
        
        ginv = ginv + geom_text(data = df.cors, aes(x = 350, y = 90, label = cor, size = 7), color ="red" , inherit.aes = FALSE, parse = T)
        ginv = ginv + ggtitle("Regressions in 2012 (May @ August)")
        plot(ginv)
        ggsave(ginv, file='regressions2012_05_08_4_levels.pdf')
}

# testAddQuantiles <- function(df){
#         for (i in 1:nrow(df)) {
#            quantiles =  quantile(df$power)
#            q0 = quantile[1]
#            q1 = quantile[2]
#            power = df[i,3]
#            if power >= quantiles[1] & df
#    
#         }
# }
