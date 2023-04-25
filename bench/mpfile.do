// mpferror
mata:
totest = mpfile()
end
rcof "noisily mata totest.mpferror(-601)" == 601
rcof "noisily mata totest.mpferror(-602)" == 602
rcof "noisily mata totest.mpferror(-603)" == 603
rcof "noisily mata totest.mpferror(-608)" == 608

// mpfopen, mpfclose, mpfput, mpfget
mata:
unlink("bench/totest.txt")
totest = mpfile()
fh = totest.mpfopen("bench/totest.txt", "w")
assert(totest.fhs.get(fh)=="open")
totest.mpfput(fh, "    Denkend aan Holland")
totest.mpfput(fh, "    zie ik breede rivieren")
totest.mpfput(fh, "    traag door oneindig")
totest.mpfput(fh, "    laagland gaan,")
totest.mpfput(fh, "    rijen ondenkbaar")
totest.mpfput(fh, "    ijle populieren")
totest.mpfput(fh, "    als hooge pluimen")
totest.mpfput(fh, "    aan den einder staan;")
totest.mpfput(fh, "    en in de geweldige")
totest.mpfput(fh, "    ruimte verzonken")
totest.mpfput(fh, "    de boerderijen")
totest.mpfput(fh, "    verspreid door het land,")
totest.mpfput(fh, "    boomgroepen, dorpen,")
totest.mpfput(fh, "    geknotte torens,")
totest.mpfput(fh, "    kerken en olmen")
totest.mpfput(fh, "    in een grootsch verband.")
totest.mpfput(fh, "    de lucht hangt er laag")
totest.mpfput(fh, "    en de zon wordt er langzaam")
totest.mpfput(fh, "    in grijze veelkleurige")
totest.mpfput(fh, "    dampen gesmoord,")
totest.mpfput(fh, "    en in alle gewesten")
totest.mpfput(fh, "    wordt de stem van het water")
totest.mpfput(fh, "    met zijn eeuwige rampen")
totest.mpfput(fh, "    gevreesd en gehoord.")
totest.mpfclose(fh)
assert(totest.fhs.get(fh)=="closed")


fh = totest.mpfopen(`"bench\totest.txt"', "r")
assert(totest.fhs.get(fh) == "open")
assert(totest.mpfget(fh)==`"    Denkend aan Holland"')
assert(totest.mpfget(fh)==`"    zie ik breede rivieren"')
assert(totest.mpfget(fh)==`"    traag door oneindig"')
assert(totest.mpfget(fh)==`"    laagland gaan,"')
assert(totest.mpfget(fh)==`"    rijen ondenkbaar"')
assert(totest.mpfget(fh)==`"    ijle populieren"')
assert(totest.mpfget(fh)==`"    als hooge pluimen"')
assert(totest.mpfget(fh)==`"    aan den einder staan;"')
assert(totest.mpfget(fh)==`"    en in de geweldige"')
assert(totest.mpfget(fh)==`"    ruimte verzonken"')
assert(totest.mpfget(fh)==`"    de boerderijen"')
assert(totest.mpfget(fh)==`"    verspreid door het land,"')
assert(totest.mpfget(fh)==`"    boomgroepen, dorpen,"')
assert(totest.mpfget(fh)==`"    geknotte torens,"')
assert(totest.mpfget(fh)==`"    kerken en olmen"')
assert(totest.mpfget(fh)==`"    in een grootsch verband."')
assert(totest.mpfget(fh)==`"    de lucht hangt er laag"')
assert(totest.mpfget(fh)==`"    en de zon wordt er langzaam"')
assert(totest.mpfget(fh)==`"    in grijze veelkleurige"')
assert(totest.mpfget(fh)==`"    dampen gesmoord,"')
assert(totest.mpfget(fh)==`"    en in alle gewesten"')
assert(totest.mpfget(fh)==`"    wordt de stem van het water"')
assert(totest.mpfget(fh)==`"    met zijn eeuwige rampen"')
assert(totest.mpfget(fh)==`"    gevreesd en gehoord."')
assert(totest.mpfget(fh)==J(0,0,""))
totest.mpfclose(fh)
assert(totest.fhs.get(fh) == "closed")
unlink("bench\totest.txt")
end

// mpfclose_all
mata:
totest = mpfile()
fh1 = totest.mpfopen(`"bench/test1.txt"', "w")
fh2 = totest.mpfopen(`"bench/test2.txt"', "w")
fh3 = totest.mpfopen(`"bench/test3.txt"', "w")

assert(totest.fhs.get(fh1) == "open")
assert(totest.fhs.get(fh2) == "open")
assert(totest.fhs.get(fh3) == "open")

totest.mpfclose_all()
assert(totest.fhs.get(fh1) == "closed")
assert(totest.fhs.get(fh2) == "closed")
assert(totest.fhs.get(fh3) == "closed")
unlink("bench/test1.txt")
unlink("bench/test2.txt")
unlink("bench/test3.txt")
end