mainreg = function (){
        dbg = 0
        
        library(RMySQL)
        library(ggplot2)
        source("~/Documents/Trafin/lovy/utils.R")
        if (dbg) browser()
        
        input = list()
        input$year1 = 2008
        input$year2 = 2012
        input$years <- "2008-2012"
        
        input$start_date = paste(input$year,"-01-01",sep="")
        input$end_date = paste(input$year,"-12-31",sep="")
        
        input$entropic_start_date = paste(input$year,"-01-01",sep="")
        input$entropic_end_date = paste(input$year,"-02-28",sep="")
        
        #input$exclude_date = paste(input$year,"-08-02",sep="")
        #input$exclude_date = paste(input$year,"-02-07",sep="")
        load(paste("~/Documents/Trafin/fouyol/recherche/dvpt/aerosol/data/df.power",
                   substr(input$year,3,4),
                   ".rda",sep="")
             )
        
        QueryString = paste("select date(datetime) as date, avg(pmptp) as pm10 from pm10", 
                            "where year(datetime) between", input$year1 ,"and", input$year2,
                            "and pmptp > 0 group by date(datetime) order by date(datetime)")
        #QueryString = "select date(datetime) as date, avg(pmptp) as pm10 from pm10 where year(datetime) = 2012 and pmptp > 0 and hour(datetime) between 8 and 9 group by date(datetime) order by date(datetime)"
        
        entropicQueryString = paste("select avg(pmptp) as pm10 from pm10",
                                        "where date(datetime)",
                                                "between", "'",input$entropic_start_date,"'" , 
                                                        "and", "'", input$entropic_end_date,"'",  
                                        "and jour != 'Dimanche'")
        
        df.pm10 = getMysqlData(QueryString)
        entropic.df = getMysqlData(entropicQueryString)
        entropic = entropic.df$pm10
        
        #if (dbg) browser()
        
        #entropic = 22
        df.pm10$pm10 = ifelse((df.pm10$pm10 - entropic) >= 0,df.pm10$pm10 - entropic , 0)
        
        df.pm10 = subset(df.pm10, pm10>0)
        
        #df.powers = subset(df.powers, as.character.factor(date) != input$exclude_date)
        
        #df.pmpowers <- merge(df.powers, df.pm10, by=c("date"),all.x = T, all.y = T)
        # plot(df.pmpowers$power, df.pmpowers$pm10)
        # 
        # g <- ggplot(df.pmpowers)
        # #g + aes(power, pm10) + geom_point() + geom_smooth(method="lm")
        # g + aes(power, pm10) + geom_point(alpha = 1/3) + geom_smooth(method="lm")
        #lm( power ~ pm10, df.pmpowers)
        
        cork <- cor(df.power$power, df.power$pm10, use = "complete.obs")
        
        if (dbg) browser()
        
        #QueryString = "select avg(pmptp) as pm10 from pm10 where date(datetime) between "2012-01-01" and "2012-03-31" and jour <=> "dimanche""
        #df.inversions = getMysqlData(QueryString)
        
        if (dbg) browser()
        
        
        if (dbg) browser()
#         df.pminvpowers <- within(na.omit(df.pmpowers), 
#                                     inversion <- cut(power, quantile(power,
#                                                                      probs =c(0, 0.5, 1),
#                                                                      na.rm = TRUE), 
#                                                     include.lowest=TRUE, 
#                                                     labels=c("weak","strong"))
#                                     )
        
        if (dbg) browser()
        
#         dfs <- split(df.pminvpowers, df.pminvpowers$inversion)
#         
#         cors = round(as.numeric(unlist(
#                         lapply(dfs, function(elt) cor(x=elt$pm10, y=elt$power, use ="complete.obs"))
#                         )
#                         )
#                 ,2)
#         df.cors <- data.frame(levels(df.pminvpowers$inversion), cors)
#         colnames(df.cors) <- c("inversion", "cor")
#         library(dplyr)
#         df.cors <- mutate(df.cors, cor = paste("cor:", cor, sep="")) 
#         row.names(df.cors) <- 1:2
        
        if (dbg) browser()
        df.cor = data.frame(round(cork,2))
        colnames(df.cor) <- c("cor")
        minpower <- quantile(df.power$power, probs = c(0.05))
        maxpower <- quantile(df.power$power, probs = c(0.95))
        
        minpm10 <- quantile(df.power$pm10, probs = c(0.05))
        maxpm10 <- quantile(df.power$pm10, probs = c(0.95))
        
        df.power <- subset(df.power, power > minpower & power < maxpower & pm10 > minpm10 & pm10 < maxpm10)
 
        #df.cors$cor = cor(df.pminvpowers$pm10, df.pminvpowers$powers, use ="complete.obs")
        if (dbg) browser()
        g <- ggplot(df.power)
        #g + aes(power, pm10) + geom_point() + geom_smooth(method="lm")
        #ginv = g + aes(power, pm10) + facet_wrap(~ inversion, scales = "free") + geom_point(alpha = 1/3) + geom_smooth(method="lm") 
        #ginv = g + aes(power, pm10) + facet_wrap(~ inversion) + geom_point(alpha = 1/3) + geom_smooth(method="lm") 
        ginv = g + aes(power, pm10) + geom_point(aes(colour = factor(year))) + geom_smooth(method="lm") + guides(color = guide_legend(title="Year "))
        title = paste("Regressions in", input$years)
        #ginv = ginv + geom_text(data = df.cor, aes(x = 900, y = 90, label = cor, size = 7), color ="red" , inherit.aes = FALSE, parse = FALSE)
        ginv = ginv + ggtitle(title)
        plot(ginv)
        
        fname = paste("regressions",as.character(input$years),".pdf",sep="")
        if (dbg) browser()
        ggsave(ginv, file=fname, scale = 1.8)
}

getMysqlData <- function(queryString=""){
        #   View(queryString)
        browser()
        con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                        password="dbmeteodb",
                        dbname="dbmeteodb",
                        host="localhost")
        
        # send the query
        #                 if (dbg) browser()
        queryResultsData <- dbSendQuery(con, queryString)
        
        
        #get the data
        data <- fetch(queryResultsData, n=-1)
        # freeing resources
        dbClearResult(queryResultsData) 
        dbDisconnect(con)
        #View(data)  
        data
        
        
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
