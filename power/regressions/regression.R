mainreg = function (){
        dbg = 0
        
        library(RMySQL)
        library(ggplot2)
        
        load("~/Documents/Trafin/lovy/soundingbymonth/df.powers2k12.RData")
        
        
        QueryString = "select date(datetime) as date, avg(pmptp) as pm10 from pm10 where year(datetime) = 2012 and pmptp > 0 group by date(datetime) order by date(datetime)"
        df.pm10 = getMysqlData(QueryString)
        
        df.pmpowers <- merge(df.powers, df.pm10, by=c("date"),all.x = T, all.y = T)
        # plot(df.pmpowers$power, df.pmpowers$pm10)
        # 
        # g <- ggplot(df.pmpowers)
        # #g + aes(power, pm10) + geom_point() + geom_smooth(method="lm")
        # g + aes(power, pm10) + geom_point(alpha = 1/3) + geom_smooth(method="lm")
        lm( power ~ pm10, df.pmpowers)
        
        cor(df.pmpowers$power, df.pmpowers$pm10, use = "complete.obs")
        
        QueryString = "select distinct date, inversion from sounding2 where year(date) = 2012 and month(date) = 7  and time = '12:00:00' order by date"
        df.inversions = getMysqlData(QueryString)
        
        
        
        df.pminvpowers <- merge(df.pmpowers, df.inversions, by=c("date"),all.x = T, all.y = T)
        #df.pminvpowers <- merge(df.pmpowers, df.inversions, by=c("date"))
        if (dbg) browser()
        
        dfs <- split(df.pminvpowers, factor(df.pminvpowers$inversion))
        
        #cors = lapply(dfs, function(elt) cor(x=elt$pm10, y=elt$power, use ="complete.obs"))
        #df.cors <- data.frame(factor(df.pminvpowers$inversion), cors)
        #colnames(df.cors) <- c("inversion", "cor")
        library(dplyr)
        #df.cors <- mutate(df.cors, cor = paste("cor:", cor, sep="")) 
        #row.names(df.cors) <- 1:4
        g <- ggplot(df.pminvpowers)
        #g + aes(power, pm10) + geom_point() + geom_smooth(method="lm")
        ginv = g + aes(power, pm10) + facet_wrap(~ inversion, scales = "free") + geom_point(alpha = 1/3) + geom_smooth(method="lm") 
        #ginv = ginv + geom_text(data = df.cors, aes(x = 600, y = 50, label = cor), color ="red" , inherit.aes = FALSE, parse = T)
        plot(ginv)
        ggsave(ginv, file='regressions.pdf')
}

