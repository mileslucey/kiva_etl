# Kiva ETL
## Background Information
### Data Source
* Kaggle: https://www.kaggle.com/kiva/data-science-for-good-kiva-crowdfunding
### Data Files:
* One "kiva_loans.csv" file that contains information on several loans on the Kiva platform
* One "kiva_mpi_region_locations.csv" file that contains geographical information for the borrower as well as the MPI (Global Multidimensional Poverty Index) for the borrower's location
* One "loan_theme_ids.csv" file that contains information on each Kiva loan "theme" or the general purpose behind each loan
* One "loan_themes_by_region.csv" file that contains each lender's information
## Extract
* CSV files are taken from a [Kaggle](https://www.kaggle.com/kiva/data-science-for-good-kiva-crowdfunding) web page and saved in the "Resources" folder
* Data is extracted from the four CSV files in the "Resources" folder
* Python code to extract data from the CSV files is listed below:
1. kiva_loans.csv
  ~~~~python
  kiva_loans_csv = "Resources/kiva_loans.csv"
  kiva_loans_df = pd.read_csv(kiva_loans_csv)
  ~~~~
2. kiva_mpi_region_locations.csv
  ~~~~python
  regions_csv = "Resources/kiva_mpi_region_locations.csv"
  regions_df = pd.read_csv(regions_csv)
  ~~~~
3. loan_theme_ids.csv
  ~~~~python
  theme_csv = "Resources/loan_theme_ids.csv"
  theme_df = pd.read_csv(theme_csv)
  ~~~~
4. loan_themes_by_region.csv
  ~~~~python
  field_partner_csv = "Resources/loan_themes_by_region.csv"
  field_partner_df = pd.read_csv(field_partner_csv)
  ~~~~
