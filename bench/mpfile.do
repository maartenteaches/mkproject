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


totest.mpfread(`"bench\totest.txt"')
assert(totest.fhs.get(totest.reading.fh) == "open")
assert(totest.mpfget()==`"    Denkend aan Holland"')
assert(totest.mpfget()==`"    zie ik breede rivieren"')
assert(totest.mpfget()==`"    traag door oneindig"')
assert(totest.mpfget()==`"    laagland gaan,"')
assert(totest.mpfget()==`"    rijen ondenkbaar"')
assert(totest.mpfget()==`"    ijle populieren"')
assert(totest.mpfget()==`"    als hooge pluimen"')
assert(totest.mpfget()==`"    aan den einder staan;"')
assert(totest.mpfget()==`"    en in de geweldige"')
assert(totest.mpfget()==`"    ruimte verzonken"')
assert(totest.mpfget()==`"    de boerderijen"')
assert(totest.mpfget()==`"    verspreid door het land,"')
assert(totest.mpfget()==`"    boomgroepen, dorpen,"')
assert(totest.mpfget()==`"    geknotte torens,"')
assert(totest.mpfget()==`"    kerken en olmen"')
assert(totest.mpfget()==`"    in een grootsch verband."')
assert(totest.mpfget()==`"    de lucht hangt er laag"')
assert(totest.mpfget()==`"    en de zon wordt er langzaam"')
assert(totest.mpfget()==`"    in grijze veelkleurige"')
assert(totest.mpfget()==`"    dampen gesmoord,"')
assert(totest.mpfget()==`"    en in alle gewesten"')
assert(totest.mpfget()==`"    wordt de stem van het water"')
assert(totest.mpfget()==`"    met zijn eeuwige rampen"')
assert(totest.mpfget()==`"    gevreesd en gehoord."')
assert(totest.mpfget()==J(0,0,""))
totest.mpfclose(totest.reading.fh)
assert(totest.fhs.get(totest.reading.fh) == "closed")
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

// mpfread()
mata:
totest = mpfile()
totest.mpfread("bench/test_header.txt")
assert(totest.reading.lnr == 0)
assert(totest.reading.fn == "bench/test_header.txt")
assert(totest.reading.label == "")
assert(totest.reading.fversion == J(1,3,.))
assert(totest.reading.type == "")
assert(totest.reading.open == 1)
end

rcof `"noisily mata: totest.mpfread("bench/test_header2.txt")"'==198

mata:
totest.mpfclose_all()
end
