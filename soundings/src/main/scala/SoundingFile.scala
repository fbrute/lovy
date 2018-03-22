import net.ruippeixotog.scalascraper.browser.JsoupBrowser
import java.text.SimpleDateFormat
import java.util.Calendar
import java.io._

class SoundingFile {
  private val region = "na"
  private val type_of_map = "TEXT"
  private val year = 2005
  private val months =  "Jan" :: "Feb" :: "Mar" :: "Apr" :: "May" :: "Jun" :: "Jul" :: "Aug" :: "Sep" :: "Oct" ::
    "Nov" :: "Dec" :: Nil
  private val from_day = 1
  private val from_time = 12
  private val to_day = 1
  private val to_time = 12
  private val station_number = 78954

  private val browser = JsoupBrowser()

  private val data = ""

  def mkUrl(region : String, type_of_map : String, year : Int , month : Int , from_day : Int, from_time : Int,
            to_day : Int, to_time : Int, station_number : Int) : String = {

    "http://weather.uwyo.edu/cgi-bin/sounding?region=" + region + "conf&TYPE=" + type_of_map +
    "%3ALIST&YEAR="+ year.toString() + "&MONTH=" + "%02d".format(month) + "&FROM="+
    "%02d".format(from_day) + "%02d".format(from_time) + "&TO=" + "%02d".format(to_day) + "%02d".format(to_time) +
    "&STNM=" + station_number
  }

  def getData(url : String) : String = {
    browser.get(url).toString()
  }

  def saveDataToFile(data : String, canonicalFilename: String) = {
    val file = new File(canonicalFilename)
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(data)
    bw.close
  }

  def maxDayofMonth(year : Int, month : Int) : Int = {
    val cal = Calendar.getInstance
    cal.set(Calendar.YEAR, year)
    cal.set(Calendar.MONTH, month-1)
    cal.set(Calendar.DAY_OF_MONTH, 1)
    cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DATE))

    cal.getTime.toString.substring(8,10).toInt
  }
}

object SoundingFile {

  val file1 = new SoundingFile
  val url1 = file1.mkUrl("na", "TEXT",2005,1,1,12,31,12,78954)

  assert(url1 ==
    "http://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR=2005&MONTH=01&FROM=0112&TO=3112&STNM=78954")

  val maxdt = file1.maxDayofMonth(2015,2)
  assert(maxdt == 28)


  val browser = JsoupBrowser()
  val data = browser.get(url1)
  val df = new SimpleDateFormat("yyyy-mm-dd")

  //println(data)

  val years = 2006 to 2016
  val months = 1 to 12
  val from_day = 1
  val time = 12
  val station_number = 78954

  for (year <- years) {
    for (month <- months) {
      val url = file1.mkUrl("na", "TEXT",year,month,1,12,file1.maxDayofMonth(year,month),12,78954)
      file1.saveDataToFile( file1.getData(url) ,s"${year}_{$month}_barbados.html")
    }
  }
}
