mata:
mata set matastrict on

real rowvector mpversion::parse_version(string scalar toparse) 
{
	string rowvector verspl
	real rowvector result

  	verspl = tokens(toparse, ".")
	if (cols(verspl)!= 5){
		errprintf("{p}A version has the form #.#.#{p_end}")
		exit(198)
	}
	result = strtoreal(verspl[(1,3,5)])
	if (anyof(result, .)){
		errprintf("{p}A version has the form #.#.#{p_end}")
		exit(198)
	}	
	toonew(result)
	return(result)
}

void mpversion::proj_version(string scalar value)
{
	proj_version = parse_version(value)
}

real scalar mpversion::lt(real rowvector a, real rowvector b)
{
	real scalar i
	
	if (cols(a) != 3 | cols(b) != 3) {
		errprintf("{p}a and b need to have three columns{p_end}")
		exit(198)
	}
	for(i=1; i<=3; i++) {
		if (a[i] < b[i]) {
			return(1)
		}
		if (a[1] > b[i]) {
			return(0)
		}
	}
	return(0)
}

void mpversion::new()
{
	current_version = (2,0,0)
}

void mpversion::toonew(real rowvector val)
{
	string scalar rmsg
	if (cols(val)!=3) {
		errprintf("{p}val needs to have three columns{p_end}")
		exit(198)
	}
	if (lt(current_version,val)) {
		rmsg = "{p}current version of mkproject is " + 
		       invtokens(strofreal(current_version),".") +
			   " and it cannot handle versions larger than that{p_end}"
		errprintf(rmsg)
		exit(198)
	}
	
}

end