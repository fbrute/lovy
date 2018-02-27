import java.text.SimpleDateFormat
import java.util.Calendar

import org.joda.time.DateTime

2005 to 2016
val df = new SimpleDateFormat("yyyy-MM-dd")
//val dt1 = new java.util.Date("2005-02-01")
//println(dt1)
//val dt2 = new java.util.GregorianCalendar("AST",)

val dt1 = df.parse("2005-02-02")


val cal = Calendar.getInstance
cal.set(Calendar.YEAR, 2016)
cal.set(Calendar.MONTH, 1)
cal.set(Calendar.DAY_OF_MONTH, 1)
cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DATE))

cal.getTime.toString.substring(8,10).toInt
//val dt2 = new DateTime(2005,2,1)
//dt2.toString()


