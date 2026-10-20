library(spp)

set.seed(1)
centers <- c(2000, 5000, 8000)
x <- sort(round(c(rnorm(300, centers - 60, 20), runif(100, 1, 10000))))
y <- sort(round(c(rnorm(300, centers + 60, 20), runif(100, 1, 10000))))
bg.x <- sort(round(runif(200, 1, 10000)))
bg.y <- sort(round(runif(200, 1, 10000)))

stopifnot(identical(
  spp:::lwcc(x, y, 1, 10000, bg.x = bg.x, bg.y = bg.y),
  spp:::lwcc(x, y, 1, 10000, bg.x = bg.x, bg.y = bg.y, bg.weight = 1)
))

# spp_lwcc and spp_wtd read bg.weight even without a control.
ns <- asNamespace("spp")
for (f in c("lwcc", "wtd")) {
  trace(f, exit = quote(stopifnot(length(bg.weight) == 1)), where = ns, print = FALSE)
}
for (method in list(spp:::tag.lwcc, spp:::tag.wtd)) {
  spp:::window.call.mirror.binding(list(chrT = c(x, -y)), debug = FALSE, method = method)
}
