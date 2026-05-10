import delimited "D:\project2025\cultural_trade\Global_Cultural_Trade_Network\data\cleaned\attributes.csv"

// missing values in GDP per caita
br if gdp_pc==.

//sanity check
br if iso_o == "ERI"

//Log transformations
gen log_gdp_pc = log(gdp_pc)
mdesc log_gdp_pc gdp_pc

// IPS test
encode iso_o , gen(country_id)
tsset country_id year
xtunitroot ips gdp_pc , trend lags(aic)
xtunitroot ips log_gdp_pc , trend lags(aic)
gen D_log_gdp_pc = D.log_gdp_pc
xtunitroot ips D_log_gdp_pc, trend lags(aic)

**Log GDP and log GDP per capita are I(1)
export delimited using D:\project2025\cultural_trade\Global_Cultural_Trade_Network\data\cleaned\attributes.csv, replace
