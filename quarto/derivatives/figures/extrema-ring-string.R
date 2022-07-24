## Used to make ring figure. Redo in Julia??
plot.new()
plot.window(xlim=c(0,1), ylim=c(-5, 1.1))
x <- seq(.1, .9, length=9)
y <- c(-4.46262,-4.46866, -4.47268, -4.47469, -4.47468, -4.47267, -4.46864, -4.4626 , -4.45454)
lines(c(0, x[3], 1), c(0, y[3], 1))
points(c(0,1), c(0,1), pch=16, cex=2)
text(c(0,1), c(0,1), c("(0,0)", c("(a,b)")), pos=3)

lines(c(0, x[3], x[3]), c(0, 0, y[3]), cex=2, col="gray")
lines(c(1, x[3], x[3]), c(1, 1, y[3]), cex=2, col="gray")
text(x[3]/2, 0, "x", pos=1)
text(x[3], y[3]/2, "|y|", pos=2)
text(x[3], (1 + y[3])/2, "b-y", pos=4)
text((x[3] + 1)/2, 1, "a-x", pos=1)

text(x[3], y[3], "0", cex=4, col="gold")
