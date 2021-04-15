
// Working directory
cd "E:\Assignments\ECO403\Final project"

cap log close _all // closes any previously opened log files

log using "Eco403_Final_project", replace text

set more off

clear	

use "Eco403_Final_project"

// Add labels to variables
label variable shortnam "3 letter country name" 
label variable africa "dummy=1 for Africa"
label variable lat_abst "Abs(latitude of capital)/90"
label variable rich4 "dummy=1 for neo-europes"
label variable avexpr "average protection against expropriation risk"
label variable logpgp95 "log PPP GDP pc in 1995, World Bank"
label variable logem4 "log settler mortality"
label variable asia "=1 for all of asia"
label variable loghjypl "log GDP per work, Hall&Jones"
label variable baseco "base sample Colonial Origins paper"
label variable x2019 "PPP GDP pc in 2019, World Bank"
label variable edu "average total years of education for adults"
label variable f_brit "British colony"
label variable f_french "French colony"

gen logx2019 = log(x2019)

**********
*OLS regression on GDP per capita 
**********
*-- Column 1 and 2 (Base Specification)

reg logpgp95 avexpr, robust
estimates store ols_1

reg logx2019 avexpr, robust
estimates store ols_2

* -- Column 3 and 4 (With Control)

reg logpgp95 avexpr africa rich4 asia f_brit f_french, robust
estimates store ols_3

reg logx2019 avexpr africa rich4 asia f_brit f_french, robust
estimates store ols_4

esttab ols_1 ols_2 ols_3 ols_4 using "OLS Regression Table on GDP", ///
	label ///
	rtf replace se ///
	mtitles("OLS 1995 GDP" "OLS 2019 GDP" "OLS 1995 GDP w/ dummy" "OLS 2019 GDP w/ dummy") ///
	stats(N r2 F, labels("Observations" "R-squared" "F-statistics")) ///

	
*********** 
*IV regression on GDP per capita
***********
*-- Column 1 (First stage)
reg avexpr logem4, robust
estimates store first_stage

*-- Column 2 and 3 (Base Specification)
ivreg logpgp95 (avexpr=logem4), robust
estimates store iv_1

ivreg logx2019 (avexpr=logem4), robust
estimates store iv_2

*-- Column 4 and 5 (With Control)
ivreg logpgp95 (avexpr=logem4) africa rich4 asia f_brit f_french, robust
estimates store iv_3

ivreg logx2019 (avexpr=logem4) africa rich4 asia f_brit f_french, robust
estimates store iv_4

esttab first_stage iv_1 iv_2 iv_3 iv_4 using "IV Regression Table on GDP", ///
	label ///
	rtf replace se ///
	mtitles("First Stage" "IV 1995 GDP" "IV 2019 GDP" "IV 1995 GDP w/ dummy" "IV 2019 GDP w/ dummy") ///
	stats(N, labels("Observations")) ///


************* 
*OLS regression on education 
*************
*-- Column 1 (Base)
reg edu avexpr, robust
estimates store ols_edu_1

*-- Column 3 (with dummy)
reg edu avexpr africa rich4 asia f_brit f_french, robust
estimates store ols_edu_2


*********** 
*IV regression on education
***********
*-- Column 2 (Base)
ivreg edu (avexpr=logem4), robust
estimates store iv_edu_1

*-- Column 4 (with dummy)
ivreg edu (avexpr=logem4) africa rich4 asia f_brit f_french, robust
estimates store iv_edu_2

esttab ols_edu_1 iv_edu_1 ols_edu_2 iv_edu_2 using "Regression Table on Education", ///
	label ///
	rtf replace se ///
	mtitles("OLS education" "IV education" "OLS education w/ dummy" "IV education w/ dummy") ///
	stats(N, labels("Observations")) ///




