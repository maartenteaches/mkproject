// remove_usuffix()
mata:
totest = boilerplate()
foo = "ä_Ü_ßö"
assert(totest.remove_usuffix(foo) == "ä_Ü")
foo = "äÜ_ßö"
assert(totest.remove_usuffix(foo) == "äÜ")
foo = "äÜßö"
assert(totest.remove_usuffix(foo) == "äÜßö")
end

//
mata:



end