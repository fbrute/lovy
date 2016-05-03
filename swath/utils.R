library(RMySQL)

getParams = function () {
    
    
    year = readline('Enter the year  : ')
    
    sat_origin = readline('Enter name of satelitte (T for TERRA or A for AQUA) : ')
    if ( sat_origin == 'T') { sat_origin = 'TERRA'}
    if ( sat_origin == 'A') { sat_origin = 'AQUA'}
    
    area = readline("Enter the area ('g' for gwada or 'd' for desirade or 'ge' for gwada_east ) :")
    if (area == 'g') { area = 'gwada'}
    if (area == 'd') { area = 'desirade'}
    if (area == 'ge') { area = 'gwada_east'}
    
    resolution <- readinteger(prompt="Enter the resolution in kms (1 for 100, 2 for 50, 3 for 150) : ")
    if (resolution == 1) { resolution = 100}
    if (resolution == 2) { resolution = 50}
    if (resolution == 3) { resolution = 150}
    
    aot_length <- readinteger(prompt="Enter the aot length (1 for 500, 2 for 870, 3 for 675, 4 for 1020, 5 for 440) : ")
    if (aot_length == 1) { aot_length = 500}
    if (aot_length == 2) { aot_length = 870}
    if (aot_length == 3) { aot_length = 650}
    if (aot_length == 4) { aot_length = 1020}
    if (aot_length == 5) { aot_length = 440}
    
    # offset is how minutes before or after satelitte overpass hour 
    offset <- readinteger(prompt="Enter the offset in minutes: ")
    
    #offset = sprintf( "%03d", offset)
    
    # delay is how long in minutes is the measurement
    delay <- readinteger(prompt="Enter the delay in minutes: ")
    
    last_julian_day <- readinteger(prompt="Enter the last julian day : ")
    
    #delay  = sprintf( "%03d", delay)
    lparams =  list(sat_origin = sat_origin, year = year, area = area, resolution = resolution, 
                    last_julian_day = last_julian_day, aot_length = aot_length, offset = offset, delay = delay)
    lparams
    
}
get_overpass_hour_from_csv = function (filename) {
    #hh:mm:ss
    vect_file_name = unlist(strsplit(filename,""))
    vect_hour = vect_file_name[(length(vect_file_name)-7): (length(vect_file_name)-6)]
    str_hour = paste(vect_hour, collapse="")
    vect_min = vect_file_name[(length(vect_file_name)-5): (length(vect_file_name)-4)]
    str_min = paste(vect_min, collapse="")
    paste(str_hour, ':', str_min, ':', '00', sep="")
}


get_overpass_hour_in_seconds = function (stOverpassHour) {
    #hh:mm:ss
    vectOverpass = unlist(strsplit(stOverpassHour,""))
    str_hour = paste(vectOverpass[1:2], collapse="")
    str_min = paste(vectOverpass[4:5], collapse="")
    paste(str_hour, ':', str_min, ':', '00', sep="")
    as.numeric(str_hour) * 3600 + as.numeric(str_min) * 60
}


get_overpass_hour_from_seconds = function (seconds) {
    hours = floor( seconds / 3600)
    st_hours = sprintf( "%02d", hours)
    min = (seconds - 3600 * hours)/60
    st_min = sprintf( "%02d", min)
    paste(st_hours, ':', st_min, ':', '00', sep="")
}

wrapWithQuotes = function (string) {
    sprintf("'%s'", string)
}

# Build a string to insert data into the database
createInsertSqlString  = function (table, fields, values) {
    queryString = paste("insert into ", 
                        table,
                       " (", paste(fields,collapse=","), ") ",
                       "values(", paste(values,collapse=","),")",
                       sep="")
}

createUpdateSqlString  = function (tableName, fields, values, wheres = c(), whereValues=c()) {
    queryString = paste("update ",  
                        tableName, sep="")
    
    if (length(fields) > 0) { 
        queryString = paste(queryString," set ",sep='')
        for (index in 1:length(fields)) {
            if (length(fields) > 1 && index > 1)   {
                queryString = paste(queryString, ", ", fields[index], "=", values[index], sep='')
            }
            else {
                queryString = paste(queryString, fields[index], "=", values[index],sep='')
            }
        }
    }
    if (length(wheres) > 0) { 
        queryString = paste(queryString," where ",sep='')
        for (index in 1:length(wheres)) {
            if (length(wheres) > 1 && index > 1)   {
                queryString = paste(queryString, " and ", wheres[index], "=", whereValues[index], sep='')
            }
            else {
                queryString = paste(queryString, wheres[index], "=", whereValues[index],sep='')
            }
        }
    }
    queryString
}

createSelectSqlString  = function (table, fields, wheres = c(), whereValues=c()) {
    queryString = paste("select ", 
                         paste(fields,collapse=", "), 
                        " from ",table, sep="")
    
    if (length(wheres) > 0) { 
        queryString = paste(queryString," where ",sep='')
        for (index in 1:length(wheres)) {
           if (length(wheres) > 1 && index > 1)   {
                queryString = paste(queryString, " and ", wheres[index], "=", whereValues[index], sep='')
           }
           else {
            queryString = paste(queryString, wheres[index], "=", whereValues[index],sep='')
           }
        }
    }
    queryString
}

selectSql = function (table, fields, wheres=c(), whereValues=c()) {
    queryString = createSelectSqlString(table, fields , wheres, whereValues)
    dbConnexion = getDbConnexion() 
    query = dbSendQuery(dbConnexion, queryString)
    results = fetch(query, -1)
    #dbHasCompleted(query)
    dbClearResult(dbListResults(dbConnexion)[[1]])
    endDbConnexion(dbConnexion)
    results
}

updateSql = function (tableName, fields, values, wheres=c(), whereValues=c()) {
    queryString = createUpdateSqlString(tableName, fields , values, wheres, whereValues)
    dbConnexion = getDbConnexion() 
    dbSendQuery(dbConnexion, queryString)
    dbClearResult(dbListResults(dbConnexion)[[1]])
    endDbConnexion(dbConnexion)
}

insertSql = function(table, fields, values) {
    dbConnexion = getDbConnexion() 
    queryString = createInsertSqlString(table, fields,values)
    dbSendQuery(dbConnexion, queryString)
    dbClearResult(dbListResults(dbConnexion)[[1]])
    endDbConnexion(dbConnexion)
}

getDbConnexion = function() {
    if (!exists(modeDb)) {
        modeDb <- 'test'
    }
    
    print(sprintf ("modedB=%s", modeDb) )
    
    if (toupper(modeDb) == 'TEST') {
        dbConnexion = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                            password="dbmeteodb",
                            dbname="dbmeteodbtest",
                            host="localhost")
    }
    
     if (toupper(modeDb) == 'PROD') {
        dbConnexion = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                            password="dbmeteodb",
                            dbname="dbmeteodb",
                            host="localhost")
    }
    
    dbConnexion 
}

endDbConnexion = function(connexion) {
    dbDisconnect(connexion)
}

sendQuery = function (queryString) {
    dbConnexion = getDbConnexion()
    dbSendQuery(dbConnexion, queryString)
    dbClearResult(dbListResults(dbConnexion)[[1]]) 
    endDbConnexion(dbConnexion)
}

GetDay = function (dateAsString) {
    as.numeric(substring(as.character(dateAsString), 9, 10))
}

library(RMySQL)  

killDbConnections <- function () {
    
    all_cons <- dbListConnections(MySQL())
    
    print(all_cons)
    
    for(con in all_cons)
        +  dbDisconnect(con)
    
    print(paste(length(all_cons), " connections killed."))
    
}

readinteger <- function(prompt = "Enter a integer")
{ 
    n <- readline(prompt)
    if(!grepl("^[0-9]+$",n))
    {
        return(readinteger())
    }
    
    return(as.integer(n))
}

createPrimaryKey  = function () {
    return('AAAAA') 
}

getMean <- function (vect) {
    #browser()
    #vect = as.numeric(unname(unlist(df.vector)))
    size = length(vect)
    clean_data = na.omit(vect)
    nmean_aot = mean(clean_data)
}

get_csv_filename = function (data_path, sds_name, julian_day) {
    
    setwd(data_path)
    files = list.files()
    search_pattern = paste( sds_name , "_" , sprintf( "%03d", julian_day) ,"*.csv", sep ="")
    files = files[grep(glob2rx(search_pattern), files)]
    file_number = 1 
    if (length(files) > 1) { file_number = length(files) }
    
    return(files[file_number])
}

get_df_from_csv = function (filename, na.strings = "-9.999000000000000000e+03") {
    
    return(read.csv(filename, header = FALSE, na.strings = na.strings))
}