# Global_Cultural_Trade_Network
Reproduction of this project from this repository begins with `01_preparing` folder which takes data from the `raw` subfolder of the `data` folder, cleans, prepares and saves data in the 'cleaned' subfolder of the 'data' folder. Then `02_eda` folder conducts exploratory analysis, generates plots and adds network metric datasets in the `cleaned` subfolder of the `data` folder. `03_regressions` runs the STERGMs and PPML regression for gravity model in trade and stores results in the folder `results`. 

```mermaid
flowchart TD
    A((Start)) --> B[01_preparing]
    B -->|Uses data from| C[(data/raw)]
    B -->|Saves cleaned data to| D[(data/cleaned)]
    D --> |Uses data to conduct exploratory analysis|E[02_eda]
    E -->|generates network metric datasets| D
    D --> |data goes to|F[03_regressions]
    F -->|runs STERGMs, PPML regressions|H[\Results/]
    H -->|stores and displays results|I((End))
```
I have used Python packages ‘numpy’, ‘pandas’, and ‘matplotlib’ to prepare edge lists and to compute summary statistics. For calculating network centralities of weighted, directed networks, and for running STERGMs and PPML regressions, I utilized the RStudio packages ‘igraph’, ‘wdnet’, ‘tergm’, and ‘fixest’, respectively. Only unit root testing and differencing of the non-stationary variables were carried out using STATA.
