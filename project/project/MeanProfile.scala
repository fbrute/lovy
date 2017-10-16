package object

class MeanProfile {
  // Aggregate vertical profiles
  private var pressures     =   1025 :: 1024 :: 1023 :: 1000 :: 970 :: 850 :: 700 :: 600 :: 500 :: 300 :: Nil
  private var temperatures  =   1024 :: 1023 :: 1000 :: 970 :: 850 :: 700 :: 600 :: 500 :: 300 :: Nil


  def canvas (x:Int, step:Int) : Int = x/step

}

object ProfileMeans {
  val profMean = new ProfileMeans
  assert(profMean.canvas(x = 1000,step = 5) == 200)
  println(profMean.pressures.length)


}
