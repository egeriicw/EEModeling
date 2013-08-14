*** basic temp-savings analysis
clear all
set mem 1000m
**read in Chicago energy intensity data and reformat
clear all
local chicagoEnergy = "/Users/matthewgee/Data/Energy/Chicago/Energy_Usage_2010.csv"
local chicagoTemp2010 = "/Users/matthewgee/Data/Energy/Effortless/ChicagoTempData2010.csv"
local chicagoTemp20062013 = "/Users/matthewgee/Data/Energy/Effortless/ChicagoTempData19252010.csv"

local chicagoEnergyDTA = "/Users/matthewgee/Data/Energy/Chicago/Energy_Usage_2010.dta"
local chicagoEnergyThermsDTA = "/Users/matthewgee/Data/Energy/Chicago/Energy_Usage_Therms_2010.dta"
local chicagoEnergyKwhDTA = "/Users/matthewgee/Data/Energy/Chicago/Energy_Usage_kwh_2010.dta"
local chicagoTemp2010DTA = "/Users/matthewgee/Data/Energy/Effortless/ChicagoTempData2010.dta"
local chciagoTemp20062013DTA = "/Users/matthewgee/Data/Energy/Effortless/ChicagoTempData19252010.dta"

***prep temp data
*****
insheet using `chicagoTemp2010', comma
sort yearmonth
save chicagoTemp2010, replace
clear all

****Prep energy intensity data
insheet using `chicagoEnergy', comma
keep if buildingtype=="Residential" & building_subtype == "Single Family"
keep communityareaname censusblock buildingtype building_subtype kwhjanuary2010 kwhfebruary2010 kwhmarch2010 kwhapril2010 kwhmay2010 kwhjune2010 kwhjuly2010 kwhaugust2010 kwhseptember2010 kwhoctober2010 kwhnovember2010 kwhdecember2010 thermjanuary2010 thermfebruary2010 thermmarch2010 termapril2010 thermmay2010 thermjune2010 thermjuly2010 thermaugust2010 thermseptember2010 thermoctober2010 thermnovember2010 thermdecember2010
save chicagoEnergy, replace

keep communityareaname censusblock buildingtype building_subtype thermjanuary2010 thermfebruary2010 thermmarch2010 termapril2010 thermmay2010 thermjune2010 thermjuly2010 thermaugust2010 thermseptember2010 thermoctober2010 thermnovember2010 thermdecember2010
rename termapril2010 thermapril2010
format censusblock %22.0f

local i = 1
foreach month in "january" "february" "march" "april" "may" "june" "july" "august" "september" "october" "november" "december" {
	if `i'<= 9 {
		rename therm`month'2010 therm20100`i'
		}
	else {
		rename therm`month'2010 therm2010`i'
		}
	local i= `i' + 1
	}

**Drop non-unique blocks
duplicates drop censusblock, force

**reshape
reshape long therm, i(censusblock) j(yearmonth)
sort censusblock yearmonth
save chicagoEnergyTherms, replace

***Reformat KWH data
use chicagoEnergy, clear

keep communityareaname censusblock buildingtype building_subtype kwhjanuary2010 kwhfebruary2010 kwhmarch2010 kwhapril2010 kwhmay2010 kwhjune2010 kwhjuly2010 kwhaugust2010 kwhseptember2010 kwhoctober2010 kwhnovember2010 kwhdecember2010 

format censusblock %22.0f

local i = 1
foreach month in "january" "february" "march" "april" "may" "june" "july" "august" "september" "october" "november" "december" {
	if `i'<= 9 {
		rename kwh`month'2010 kwh20100`i'
		}
	else {
		rename kwh`month'2010 kwh2010`i'
		}
	local i= `i' + 1
	}

**Drop non-unique blocks
duplicates drop censusblock, force

**reshape
reshape long kwh, i(censusblock) j(yearmonth)
sort censusblock yearmonth
save chicagoEnergyKwh, replace

merge censusblock yearmonth using chicagoEnergyTherms
drop _merge
sort censusblock yearmonth
save chicagoEnergyKwhTherm, replace

merge m:1 yearmonth using chicagoTemp2010
drop _merge
***estimate relationship between temp and energy intensity
gen temp2 = temp * temp
reg therm temp temp2 
reg kwh temp temp2 therm

***use historic temp to estimate historic average energy intensity


***use historic average energy intensity to estimate historic energy savings by temp

*** outsheet results and send to Danny et al
