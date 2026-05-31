
cd "D:\project2025\cultural_trade\Global_Cultural_Trade_Network"

import delimited "D:\project2025\cultural_trade\Global_Cultural_Trade_Network\data\cleaned\panel_complete.csv"


// Summary statistics 
unique iso_o
unique iso_d
unique dyad
unique year

gen sum_gdp_pc = log_gdp_pc_d + log_gdp_pc
gen abs_gdp_pc =  abs(log_gdp_pc - log_gdp_pc_d)
gen sum_d_gdppc = d_log_gdp_pc + d_log_gdp_pc_d
gen abs_d_gdppc = abs(d_log_gdp_pc - d_log_gdp_pc_d)

// Landlocked
gen landlock = .
replace landlock = 1 if landlocked == 1 & landlocked_d == 1
replace landlock = 0 if landlock==.
tab landlock

// Development
gen dev=.
replace dev= 1 if development== 0 & development_d == 0
replace dev= 2 if development== 1 & development_d == 0
replace dev= 3 if development== 0 & development_d == 1
replace dev= 4 if development== 1 & development_d == 1
tab dev
label variable dev "1 developing-developing, 2 developed-developing, 3 developing-developed, 4 developed-developed"

*********************************************************Appendix C
// capture mkdir "data"
// capture mkdir "data/cleaned"

tab development
// unique country if development == 1
// unique country if development == 0
// preserve
//     keep if development == 1
//     keep country iso_o
//     duplicates drop
//     export delimited using "data/cleaned/advanced_economies.csv", replace
// restore
//
//
// preserve
//     keep if development == 0
//     keep country iso_o
//     duplicates drop
//     export delimited using "data/cleaned/emerging_economies.csv", replace
// restore

***********************************************************Table 4
encode dyad_id, gen(dyad)
xtset dyad year

xtsum unique reproducible noncultural_trade log_gdp_pc 
xtsum sum_gdp_pc abs_gdp_pc 
xtsum log_dist landlocked
xtsum contig comlang_off colony comcol rta
xtsum hysteresis_unique hysteresis_reproducible hysteresis_noncultural_trade development


//PPML 
ssc install reghdfe
ssc install ppmlhdfe, replace

**********************************************************Table 6 (year FE)

// baseline gravity/intensive-margin model//
//Model 1
ppmlhdfe unique sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(year) vce(cluster dyad) d
//Model 3
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(year) vce(cluster dyad) d
//Model 5
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(year) vce(cluster dyad) d


// persistence/consumption-capital extension//
//Model 2
ppmlhdfe unique sum_gdp_pc abs_gdp_pc hysteresis_unique rta contig comlang_off colony comcol log_dist landlock i.dev , a(year) vce(cluster dyad) d
//Model 4
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc hysteresis_reproducible rta contig comlang_off colony comcol log_dist landlock i.dev , a(year) vce(cluster dyad) d
//Model 6
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc hysteresis_noncultural_trade rta contig comlang_off colony comcol log_dist landlock i.dev , a(year) vce(cluster dyad) d


// Robustness checks//
****************************************************Table 7 (Bilateral FE)
//Model 1
ppmlhdfe unique sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad year) vce(cluster dyad) d

//Model 2
ppmlhdfe unique sum_gdp_pc abs_gdp_pc hysteresis_unique rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad year) vce(cluster dyad) d

//Model 3
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad year) vce(cluster dyad) d

//Model 4
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc hysteresis_reproducible rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad year) vce(cluster dyad) d

//Model 5
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad year) vce(cluster dyad) d

//Model 6
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc hysteresis_noncultural_trade rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad year) vce(cluster dyad) d



*********************************Table 8 (Exporter-year, Importer-year FE)
egen exp_year = group(iso_o year)
egen imp_year = group(iso_d year)

//Model 1
ppmlhdfe unique sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(exp_year imp_year) vce(cluster dyad) d

//Model 2
ppmlhdfe unique sum_gdp_pc abs_gdp_pc hysteresis_unique rta contig comlang_off colony comcol log_dist landlock i.dev , a(exp_year imp_year) vce(cluster dyad) d

//Model 3
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(exp_year imp_year) vce(cluster dyad) d

//Model 4
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc hysteresis_reproducible rta contig comlang_off colony comcol log_dist landlock i.dev, a(exp_year imp_year) vce(cluster dyad) d

//Model 5
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev, a(exp_year imp_year) vce(cluster dyad) d

//Model 6
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc hysteresis_noncultural_trade rta contig comlang_off colony comcol log_dist landlock i.dev, a(exp_year imp_year) vce(cluster dyad) d
	
****************Table 9 (Combined Dyad + Exporter-Year + Importer-Year FE)

//Model 1
ppmlhdfe unique sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad exp_year imp_year) vce(cluster dyad) d

//Model 2
ppmlhdfe unique sum_gdp_pc abs_gdp_pc hysteresis_unique rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad exp_year imp_year) vce(cluster dyad) d

//Model 3
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev , a(dyad exp_year imp_year) vce(cluster dyad) d

//Model 4
ppmlhdfe reproducible sum_gdp_pc abs_gdp_pc hysteresis_reproducible rta contig comlang_off colony comcol log_dist landlock i.dev, a(dyad exp_year imp_year) vce(cluster dyad) d

//Model 5
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc rta contig comlang_off colony comcol log_dist landlock i.dev, a(dyad exp_year imp_year) vce(cluster dyad) d

//Model 6
ppmlhdfe noncultural_trade sum_gdp_pc abs_gdp_pc hysteresis_noncultural_trade rta contig comlang_off colony comcol log_dist landlock i.dev, a(dyad exp_year imp_year) vce(cluster dyad) d



