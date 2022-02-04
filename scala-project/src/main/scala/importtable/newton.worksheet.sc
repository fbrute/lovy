def sqrtIter(guess: Double , x: Double) : Double =
	if isGoodEnough(guess,x) then guess
	else sqrtIter(improve(guess,x), x)

def improve(guess: Double, x: Double): Double =
	(guess + x/guess) / 2

def isGoodEnough(guess: Double, x: Double) =
	(guess*guess - x).abs < 0.001

def sqrt(x: Double) = sqrtIter(1.0, x)