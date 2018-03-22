import FileMatcher._
import java.io._
import sys.process._

object ExecSql extends App {
  val reg_ex = """.*\.(\w+)""".r

 val file = new File("ruse.sh")
    val bw = new BufferedWriter(new FileWriter(file))
 
  for (file <- filesEnding(".sql")) {

    val reg_ex = """.*\.(\w+)""".r
    //val ext = ".sql"
    //file match {
     // case reg_ex(ext) =>s"$ext is extension"
      //case _ => println("file_reg_ex none"); ""
    //}

    //println(file)
    val st1 = s"mysql -u dbmeteodb --password=dbmeteodb dbmeteodb < $file > ${file.toString slice(0, file.toString.length -4)}.txt && "

    println(st1)
    //st1.!

    //val outputFileName = file slice(0, file.toString.length -4)
    //val outputFileName = file slice(0, 4)
    //val st1 = s"mysql -u dbmeteodb --password=dbmeteodb dbmeteodb < $file > ${file.toString slice(0, file.toString.length -4)}.txt"
    //val st1 = s"mysql -u dbmeteodb --password=dbmeteodb dbmeteodb < $file > ${file.toString slice(0, file.toString.length -4)}.txt"
    //println(st1)
    // Execute sql query
    //val output =   s"${file.toString slice(0, file.toString.length -4)}.txt"
    //println(output)
    //val seq = Seq("mysql","-u","dbmeteodb", "--password=dbmeteodb", "dbmeteodb", "#<", file, "#>", output)
    //seq.!
    //Seq. !
    //println(file)
    
    bw.write(st1)

  }
    bw.close
}
