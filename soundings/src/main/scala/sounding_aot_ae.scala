import sys.process._

object concat_aot_ae_sounding {

  def fileExists(name : String) = Seq("test","-f", name).! == 0

  def stations = {
    "puerto_rico" :: "guadeloupe" :: Nil
  }

  def outputs(stations : List[String], action : String, suffix : String) = {
    val dir = "src/main/data/"
    val suffix = ".txt"
    stations.map(station => dir + station + "_" + action + suffix)
  }



  def sqls(stations : List[String], action : String, suffix : String) = {
    val dir = "src/main/sql/"
    val suffix = ".sql"
    stations.map(station => dir + station + "_" + action + suffix)
  }

  def parameters(stations : String*, actions : Strings*) =  {

  }


  def main( args : Array[String] ) = {
    println(sqls(stations, "aot_ae", ".sql"))
    println(outputs(stations, "aot_ae", ".txt"))
    for(sql <- sqls) {
      for(output <- outputs) {
    //"""mysql -u dbmeteodb -p dbmeteodb < ../sql/puerto_rico_aot_ae_sounding.sql > ../data/puerto_rico_aot_ae_sounding.txt""" !!
    //val results = "ls -ls" !
    //for(result : String <- results) println(result)

    //"mysql -u dbmeteodb --password=dbmeteodb dbmeteodb < ../sql/guadeloupe_aot_ae_sounding.sql  > ../data/guadeloupe_aot_ae_sounding.txt" !!
      }
    }
  }
}
