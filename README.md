# Kiva ETL
## Background Information
### Data Source
* Kaggle: https://www.kaggle.com/kiva/data-science-for-good-kiva-crowdfunding
### Data Files:
* One "kiva_loans.csv" file that contains information on several loans on the Kiva platform
* One "kiva_mpi_region_locations.csv" file that contains geographical information for the borrower as well as the MPI (Global Multidimensional Poverty Index) for the borrower's location
* One "loan_theme_ids.csv" file that contains information on each Kiva loan "theme" or the general purpose behind each loan
* One "loan_themes_by_region.csv" file that contains each lender's (field partner's) information
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
## Transform
* Python is used to create tables using only the relevant columns:
    1. Loans table:
    ~~~~python
    cleaned_kiva_loans_df = loans_themes_df[["loan_id","funded_amount","loan_amount","activity","loan_sector","purpose","currency","partner_id","posted_time","disbursed_time","funded_time","term_in_months","lender_count","repayment_interval","date","num_fem_borrowers","num_m_borrowers","total_borrowers","location_id","theme_id"]].copy()
    ~~~~
    2. Regions table:
    ~~~~python
    cleaned_regions_df = regions_df[["location_id","iso","country","region","world_region","mpi","lat","lon"]].copy()
    cleaned_regions_df.drop_duplicates(["location_id"],keep="first",inplace=True)
    ~~~~
    3. Loan theme table:
    ~~~~python
    cleaned_theme_df = cleaned_theme_df[["theme_id","theme_type"]].copy()
    ~~~~
    4. Field partners table:
    ~~~~python
    cleaned_field_partner_df = loan_partner_df[["partner_id","field_partner_name","partner_sector"]].copy()
    cleaned_field_partner_df.drop_duplicates(subset=["partner_id"],keep="first",inplace=True)
    cleaned_field_partner_df.dropna(subset=["partner_id"],how="any",inplace=True)
    ~~~~
    
