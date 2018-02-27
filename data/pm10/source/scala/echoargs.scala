// print hello to the first argument
println("Hello World! " + args(0) + "!")

var i = 0
while (i < args.length) {
    if (i != 0) print(" ")
    print(args(i))
    i+=1
}
