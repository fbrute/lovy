#!/usr/bin/Rscript --vanilla
#
# Copyright 2021
# France-Nor Brute
#
# Written for KaruSphere
# All rights reserved
# 
# Import sounding from wyoming (csv files) to a dataframe (instead of database, very slow, more than seven hours)

library(stringr)
library(tidyverse)
library(XML)
library(profvis)
library(foreach)
library(stringr)

mainSoundingsForAllFiles <- function(station=NULL, nb = 0) {
# (dataframe_with_3_columns(data_string, context_string, head_string)) : dfOf19Columns
    getDfForOneMonthOfSounding <- function(fileurl) {
        # (doc_with_headstrings) : list(char)
        getDfHeadDataContext <- function() {
            # (file_url: char): list(char, char) =
            # length of result is ~ 60 (2 * n_days_in_month)
            getHtmlDocAndHeaders <- function() {
                doc <- htmlTreeParse(fileurl, useInternal=TRUE)
                head_strings <- xpathSApply(doc,"//h2", xmlValue)
                list(doc=doc, head_strings=head_strings)
            }
            
            doc_with_headstrings <- getHtmlDocAndHeaders()
            doc <- doc_with_headstrings$doc
            head_strings <- doc_with_headstrings$head_strings
            df_head_data_context <- tibble()
            
            timeIsGood <- function(head_string) {
                grepl(pattern="12Z", x= head_string )
            }
            
            for (i in 1:length(head_strings)){
                # pre contains the data (odd values) or the context (even values) 
                # of the soundings
                head_string <- xpathSApply(doc,"//h2", xmlValue)[i]
                if ((!is.null(head_string)) && timeIsGood(head_string)) {
                    data_string <- xpathSApply(doc,"//pre", xmlValue)[2*i-1]
                    context_string <- xpathSApply(doc,"//pre", xmlValue)[2*i]
                    
                    df_head_data_context <-  bind_rows(df_head_data_context, list(head_string= head_string, 
                                                                                  data_string=data_string,
                                                                                  context_string=context_string)
                    )
                }
            }
            df_head_data_context
        }
        
        buildDfOfSounding <- function(row_of_data){
            getHeadStrings <- function(head_string) {
                getDate  <- function(text) {
                    # example in text : 01 Aug 2012
                    # get date of sounding, 2012-08-01 (yy-mm-dd by default) 
                    posDate <- regexpr("[0-9]{2} [a-yA-Y]* [0-9]{4}$",text)
                    strDate <- substr(text, posDate[1],
                                      posDate[1] + attr(posDate,"match.length") -1)
                    
                    # fix NAs with default local system
                    Sys.setlocale("LC_TIME", "C")
                    as.Date(strDate,"%d %b %Y")
                }
                
                getTime  <- function(text) {
                    # example in text : at 12Z 01 Aug 2012
                    # get time of sounding : 12 
                    posDate <- regexpr("[0-9]{2}Z",text)
                    datestr <- substr(text, posDate[1],
                                      posDate[1] + attr(posDate,"match.length") -2) # - 2 to get rid of "Z"
                    paste(datestr,":00:00", sep="")
                }
                
                getStationNumber  <- function(text) {
                    # example in text : at 12Z 01 Aug 2012
                    # get time of sounding : 12 
                    str <- substr(text, 1, 5)
                }
                
                getStationName  <- function(text) {
                    # example in text : at 12Z 01 Aug 2012
                    # get time of sounding : 12 
                    pos <- regexpr("^.*Observations",text)
                    str <- substr(text, 7 , 7 + attr(pos,"match.length") -1 -12 -7)
                }
                
                station_number <- getStationNumber(head_string)
                station_name <- getStationName(head_string)
                dateofsounding <- getDate(head_string)
                timeofsounding <- getTime(head_string)
                # Keep only soundings done at 12 UTC
                #if (timeofsounding == "00:00:00") return(accumulator)
                list_of_head_string_values <- list( station_number=station_number, station_name=station_name, 
                                                    dateofsounding = dateofsounding, timeofsounding=timeofsounding)
            }#!/usr/bin/env Rscript --vanilla

            
            getContextStrings <- function(context_string) {
                headerFactory  <- function(header, nErrValue = -9999999.99) {
                    function(text) {
                        regValue <- regexpr(paste0(header, "(-?[0-9.]+)"),text)
                        posValue <- regValue[1]   + nchar(header)
                        #lenCape <- attr(regCape, "match.length") - nchar(header) -1 # -1 because of final /n
                        lenValue <- attr(regValue, "match.length") - nchar(header)
                        strValue <- substr(text, posValue, posValue + lenValue - 1)
                        nValue <-   as.numeric((strValue))
                        if (is.na(nValue)) {
                            nErrValue
                        }
                        else {
                            nValue
                        }       
                    } 
                }
                
                getCape <- headerFactory("Convective Available Potential Energy: ", -9999999.99)
                getVirtualCape <- headerFactory("CAPE using virtual temperature: ", -9999999.99)
                
                getConv_inhib  <- headerFactory("Convective Inhibition: ", 9999999.99)
                getVirtualCins <- headerFactory("CINS using virtual temperature: ", 9999999.99)
                
                cape <- getCape(context_string)
                cape_virt <- getVirtualCape(context_string)
                conv_inhib <- getConv_inhib(context_string)
                cins <- getVirtualCins(context_string)
                line_of_context_string <- list(cape=cape, cape_virt=cape_virt, conv_inhib=conv_inhib, cins=cins)
                line_of_context_string   
            }
            
            # (data_string: df[Strings], head_strings: list(4), context_strings:)
            getSoundingValues <- function(data_string, head_strings, context_strings) {
                getStartRowOfData <- function(strings) {
                    for (i in 5:10) {
                        rowdata <- as.numeric(unlist(strsplit(unlist(strings)[i]," ")))
                        if (length(rowdata[!is.na(rowdata)])) {
                            #print("indice:")
                            #print(i)
                            return(i)
                            }
                    }
                }# getStartRowOfData()
                
                getRowsDfOfSounding <- function(df_of_all_pressures) {
                    
                    getRowOfSounding <- function(df.row) {
                        getSoundingValues <- function(df.row) {
                            fixMissingValuesForFirstRow <- function(row_of_data) {
                                row_of_data[11] = row_of_data[9]
                                row_of_data[10] = row_of_data[8]
                                row_of_data[9] = row_of_data[7]
                                row_of_data[7] = -9999999 
                                row_of_data[8] = -9999999 
                                row_of_data
                            }
                            
                            splitted_row <- as.numeric(unlist((strsplit(as.character(df.row), " "))))
                            splitted_row <- splitted_row[!is.na(splitted_row)]
                            splitted_row <- if (length(splitted_row) == 9) fixMissingValuesForFirstRow(splitted_row)
                            else splitted_row
                            if (length(splitted_row) == 11) {
                                names(splitted_row) <- c("pressure","height","temp", "dwpt",
                                                         "relhumidity", "mixr", "drct", "snkt", "thta", "thte", "thtv") 
                                # head_strings and context_strings are already named
                                sounding_row <- c(splitted_row, head_strings, context_strings)
                            } else NULL
                        }# getSoundingValues()
                        
                        row_of_sounding <- getSoundingValues(df.row)
                        #if (length(row_of_sounding) == 11) {
                        #    df_of_11 <- bind_rows(df_of_11, row_of_sounding)
                        #} 
                    }# getRowOfSounding() 
                    
                    df_of_sounding <- tibble()
                    for( i in 1:nrow(df_of_all_pressures)) {
                        row_of_sounding_for_i <- getRowOfSounding(df_of_all_pressures[i,])
                        df_of_sounding <- bind_rows(df_of_sounding, row_of_sounding_for_i)
                    }
                    #by(df_of_all_pressures, seq_len(nrow(df_of_all_pressures)), FUN = getRowOfSounding )    
                    df_of_sounding
                    
                }# getRowsDfOfSounding()
                
                # each line of data_sring is an observation at a different pressure
                # for a same sounding
                rows_of_data <- strsplit(unlist(data_string),"\n")
                rows_of_data <- rows_of_data[[1]]
                nIndexStartOfValues <- getStartRowOfData(rows_of_data) 
                rows_of_data <- rows_of_data[nIndexStartOfValues:length(rows_of_data)]
                # remove NAs
                rows_of_data <- rows_of_data[!is.na(rows_of_data)] 
                df.row_of_data <- as.data.frame(rows_of_data)
                
                rows_of_11 <- getRowsDfOfSounding(df.row_of_data)
            } # getSoundingValues() 
            
            head_strings_for_one_sounding <- getHeadStrings(row_of_data$head_string)
            context_strings_for_one_sounding <- getContextStrings(row_of_data$context_string)
            rows_for_one_sounding <- getSoundingValues(row_of_data$data_string, 
                                                                        head_strings_for_one_sounding,
                                                                        context_strings_for_one_sounding)
            # line_of_sounding <- list(rows_of_data=rows_of_data_string_for_one_sounding, 
            #                       head_strings = head_strings_for_one_sounding, 
            #                       context_strings=context_strings_for_one_sounding) 
            #df_of_one_sounding <- bind_rows(df_of_one_sounding, rows_for_one_sounding)
        } #buildDfOfSounding()
        
        
        df_head_data_context <- getDfHeadDataContext()
        if (nrow(df_head_data_context))
        df_of_one_month_of_sounding <- tibble()
        #by(df_head_data_context, seq_len(nrow(df_head_data_context)), FUN = buildDfOfSounding )
        for(i in 1:nrow(df_head_data_context)) { 
            rows_for_one_sounding <- buildDfOfSounding(df_head_data_context[i,])
            df_of_one_month_of_sounding <- merge(df_of_one_month_of_sounding, rows_for_one_sounding, all = TRUE)
            # second time to actually merge the first day of sounding
            if (i == 1) df_of_one_month_of_sounding <- merge(df_of_one_month_of_sounding, rows_for_one_sounding, all = TRUE)
        }
        df_of_one_month_of_sounding
    } # getDfForOneMonthOfSounding
    
    # select *.html files to get soundings from
    # () : vector =
    getFiles <-function() {
        if (file.exists(path_to_data)) {
            setwd(path_to_data) 
            files <- Sys.glob("*.html")
            if (nb == 0) files  else head(files,nb)
        } else c() 
    }
    # Which station to get data from?
    if (is.null(station)) {
        station = (readline("Name of station (pr, tenerife,... "))
        stopifnot(station %in% c("pr","tenerife","barbade","dakhla","santodomingo","saintmarteen"))
    }
    path_to_data <- str_glue("/home/kwabena/Documents/trafin/lovy/soundings/src/main/data/{station}")
    files <- if (file.exists(path_to_data)) getFiles()
    stopifnot(length(files) > 0)
    
    df_of_all_files <- tibble()
     for (file in files) {
         df_for_one_month <- getDfForOneMonthOfSounding(file)
         print(str_glue("***** computing {file}*****"))
         df_of_all_files <- rbind(df_of_all_files, df_for_one_month)
         #df_of_all_files <- merge(df_of_all_files, df_for_one_month, all=TRUE)
         #if (head(files,1) == file) df_of_all_files <- merge(df_of_all_files, df_for_one_month, all=TRUE)
         #if (head(files,1) == file) df_of_all_files <- rbind(df_of_all_files, df_for_one_month, all=TRUE)
     }
    
    # df_of_all_files <-  foreach (file=files) %dopar% {
    #     df_for_one_month <- getDfForOneMonthOfSounding(file)
    #     print(str_glue("***** computing {file}*****"))
    #     df_of_all_files <- rbind(df_of_all_files, df_for_one_month)
    #     #df_of_all_files <- merge(df_of_all_files, df_for_one_month, all=TRUE)
    #     #if (head(files,1) == file) df_of_all_files <- merge(df_of_all_files, df_for_one_month, all=TRUE)
    #     #if (head(files,1) == file) df_of_all_files <- rbind(df_of_all_files, df_for_one_month, all=TRUE)
    # }

    df_of_all_files
    #df_name <- str_glue("df{str_to_title(station)}Sounding")

} # mainSoundingsForAllFiles 

# run main program
mainSoundingsForAllFiles(station="barbade")