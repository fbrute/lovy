package importtable

import java.io.File

object ImportTable:
  def main(args: Array[String]): Unit =
    val path = if args.length > 0 then args(0)
    else throw IllegalArgumentException("No path provided!!")

    val filesHere = File(path).listFiles

    def csvFiles =
      for file <- filesHere
        if file.getName.endsWith(".csv")
          yield file
    
    def fileLines(file: File): Array[String] =
      scala.io.Source.fromFile(file).getLines().toArray
    
    def getFirstLine(file: File): String =
      fileLines(file).head
    
    def getFirstFourFieldsFromLine(line: String): String =
      line.split(",").take(5).mkString(",")

    val headers = 
      for file <- csvFiles 
        yield getFirstLine(file)

    def getFields(line: String): String =
      line
    
    val firstFourFields =
      for header <- headers
        yield getFirstFourFieldsFromLine(header)
    
    firstFourFields.foreach(println)

    val firstFields =
      val nTake = 5
      headers.map( header => header.split(",").take(nTake).mkString(","))
    
    val fields = 
      for header <- headers
        yield header.split(",").mkString(",")

    val Header = Array("Date","Source","Site ID","POC","Daily Mean PM10 Concentration","UNITS","DAILY_AQI_VALUE","Site Name","DAILY_OBS_COUNT","PERCENT_COMPLETE","AQS_PARAMETER_CODE","AQS_PARAMETER_DESC","CBSA_CODE","CBSA_NAME","STATE_CODE","STATE","COUNTY_CODE","COUNTY","SITE_LATITUDE","SITE_LONGITUDE")

 