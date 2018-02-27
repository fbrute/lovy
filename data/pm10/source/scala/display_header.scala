import scala.io.Source

if (args.length > 0) {
  var idx = 1
  for (line <- Source.fromFile(args(0)).getLines())
    if(line.contains("Humacao")) {
      val dataString = line.split(",")
      val dataLine = List(idx,dataString(11), dataString(16), dataString(25)).mkString(",")
      println(dataLine)
      idx += 1
    }
}
