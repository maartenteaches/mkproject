// mpferror
mata:
totest = mpfile()
end
rcof "noisily mata totest.mpferror(-601)" == 601
rcof "noisily mata totest.mpferror(-602)" == 602
rcof "noisily mata totest.mpferror(-603)" == 603
rcof "noisily mata totest.mpferror(-608)" == 608

// mpfopen
mata:
totest = mpfile()
totest.mpfopen()