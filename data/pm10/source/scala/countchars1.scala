// read file
import scala.io.Source

if (args.length > 0) {
    for (line <- Source.fromFile(args(0)).getLines())
      if line.contains("Humacao")
        println(line.length + " " + line)
}
else
    Console.err.println("Please enter filename")
