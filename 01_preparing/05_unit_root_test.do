import delimited "D:\project2025\Cultural_trade_2025\Global_Cultural_Trade_Network\data\cleaned\attributes2000_2023.csv"

// missing values in GDP per caita
mdesc gdp gdp_pct population
br if gdp_pct==.
replace gdp_pct = gdp/ population if gdp_pct==.

//sanity check
br if iso_o == "ERI"

//Log transformations
gen log_gdp_pct = log( gdp_pct)
gen log_population = log( population )
mdesc log_gdp_pct log_population log_gdp


// IPS test
encode iso_o , gen(country_id)
tsset country_id time
xtunitroot ips gdp_pct , trend lags(aic)
xtunitroot ips log_gdp_pct , trend lags(aic)
gen D_log_gdp_pct = D.log_gdp_pct
xtunitroot ips D_log_gdp_pct, trend lags(aic)

xtunitroot ips log_gdp , trend lags(aic)
gen D_log_gdp = D.log_gdp
xtunitroot ips D_log_gdp, trend lags(aic)

xtunitroot ips population, trend lags(aic)

**Log GDP and log GDP per capita are I(1)
**Log population is I(0)

export delimited using "D:\project2025\Cultural_trade_2025\Global_Cultural_Trade_Network\data\cleaned\attributes2000_2023.csv", replace