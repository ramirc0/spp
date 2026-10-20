library(spp)

set.seed(1)
centers <- c(2000, 5000, 8000)
x <- sort(round(c(rnorm(300, centers - 60, 20), runif(100, 1, 10000))))
y <- sort(round(c(rnorm(300, centers + 60, 20), runif(100, 1, 10000))))
bg.x <- sort(round(runif(200, 1, 10000)))
bg.y <- sort(round(runif(200, 1, 10000)))

calls <- list(
  lwcc = function(return.peaks) spp:::lwcc(x, y, 1, 10000, return.peaks = return.peaks, bg.x = bg.x, bg.y = bg.y, bg.weight = 1),
  wtd = function(return.peaks) spp:::wtd(x, y, 1, 10000, return.peaks = return.peaks, bg.x = bg.x, bg.y = bg.y)
)

for (name in names(calls)) {
  for (return.peaks in c(TRUE, FALSE)) {
    expected <- calls[[name]](return.peaks)
    gctorture(TRUE)
    observed <- calls[[name]](return.peaks)
    gctorture(FALSE)
    stopifnot(identical(observed, expected))
  }
}

# One leaked PROTECT per call overflows the default 50000-slot protect stack.
for (i in 1:60000) {
  .Call("spp_lwcc", 0L, 0L, 0L, 0L, 1L, 0L, 0, 1, 0L, 0L, 0L, 0L, 1, 0L, PACKAGE = "spp")
}
