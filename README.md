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
### Cleaning
* All four dataframes are cleaned using the following commands:
    1. "drop_duplicates" to remove all duplicate entries in each dataframe
    2. "to_datetime" to convert columns to datetime format that are initially registered as strings
    3. "rename" to change column titles so that all column titles are lower case, contain zero spaces, and are overall clearly written
    4. "dropna" to drop rows that have N/As in critical columns (e.g. if rows do not have information listed in their primary key figure)
    5. "merge" in order to establish foreign key figures in tables where there is not a foreign key originally listed. The same command is also used to test if two tables can be linked together in a schema
    6. "assign" in order to establish primary keys in tables where primary keys are not originally listed
* Below is the Python code to clean each of the four dataframes:
  1. Loans dataframe:
    
    ~~~~python
    
    # Delete duplicates
    kiva_loans_df.drop_duplicates(keep="first",inplace=True)
    
    # Rename "id" column to "loan_id" for clarity 
    kiva_loans_df.rename(index=str, columns = {"id":"loan_id","sector":"loan_sector"},inplace=True)
    
    # Convert dates from string to datetime format
    kiva_loans_df["posted_time"]=pd.to_datetime(kiva_loans_df["posted_time"])
    kiva_loans_df["disbursed_time"]=pd.to_datetime(kiva_loans_df["disbursed_time"])
    kiva_loans_df["funded_time"]=pd.to_datetime(kiva_loans_df["funded_time"])
    kiva_loans_df["date"]=pd.to_datetime(kiva_loans_df["date"])
    
    # Create separate columns for the number of female, male, and total borrowers
    kiva_loans_df["num_fem_borrowers"] = kiva_loans_df["borrower_genders"].str.count("female")
    kiva_loans_df["num_m_borrowers"] = (kiva_loans_df["borrower_genders"].str.count("male")) - (kiva_loans_df["num_fem_borrowers"])
    kiva_loans_df["total_borrowers"] = kiva_loans_df["num_fem_borrowers"] + kiva_loans_df["num_m_borrowers"]
    
    # Merge the loans and regions DataFrames to make sure we have a way to link them together
    loans_regions_df = pd.merge(kiva_loans_df,regions_df,how="left",left_on=["country","region"],right_on=["country","region"])
    
    # Create a "cleaned" DataFrame for Kiva loans with only the columns we need
    cleaned_kiva_loans_df = loans_regions_df[["loan_id","funded_amount","loan_amount","activity","loan_sector","use","currency","partner_id","posted_time","disbursed_time","funded_time","term_in_months","lender_count", "repayment_interval","date","num_fem_borrowers","num_m_borrowers","total_borrowers","location_id"]].copy()
    cleaned_kiva_loans_df.drop_duplicates(keep="first",inplace=True)
    
    # Re-merge so to re-define the theme_id and ensure it will link
    loans_themes_df = pd.merge(cleaned_kiva_loans_df,cleaned_theme_df,how="left",left_on="theme_id_old",right_on="theme_id_old")
    
    # Redefine the cleaned Kiva loans DataFrame to include a theme ID to link two dataframes together 
    cleaned_kiva_loans_df = loans_themes_df[["loan_id","funded_amount","loan_amount","activity","loan_sector","purpose","currency","partner_id","posted_time","disbursed_time","funded_time","term_in_months","lender_count","repayment_interval","date","num_fem_borrowers","num_m_borrowers","total_borrowers","location_id","theme_id"]].copy()
    
    ~~~~
  
  2. Regions dataframe:
    ~~~~python
    # Delete duplicates
    regions_df.drop_duplicates(keep="first",inplace=True)
    
    # Create a location ID
    regions_df.sort_values(["country","region"], ascending = True, inplace = True)
    regions_df=regions_df.assign(location_id=(regions_df["country"]+"_"+regions_df["region"]).astype("category").cat.codes)
    
    # Rename columns with capital letters, spaces, or are otherwise unclear
    regions_df.rename(index=str, columns = {"ISO":"iso","LocationName":"location_name","MPI":"mpi","sector":"loan_sector"},inplace=True)
    
    # Create "cleaned_regions_df" with only the relevant columns from the "regions_df" and drop duplicates
    cleaned_regions_df = regions_df[["location_id","iso","country","region","world_region","mpi","lat","lon"]].copy()
    cleaned_regions_df.drop_duplicates(["location_id"],keep="first",inplace=True)
    ~~~~
    
  3. Loan theme dataframe:
    ~~~~python
    # Rename columns not to have spaces in their titles
    theme_df.rename(index=str, columns = {"id":"loan_id","Loan Theme ID":"theme_id_old","Loan Theme Type":"theme_type","Partner     ID":"partner_id"},inplace=True)
    
    # Define "cleaned_theme_df" as only the relevant columns and remove duplicates
    cleaned_theme_df = theme_df[["theme_id_old","theme_type"]].copy()
    cleaned_theme_df.sort_values("theme_id_old",inplace=True,ascending=True)
    cleaned_theme_df.drop_duplicates(["theme_id_old"],keep="first",inplace=True)
    
    # The old theme_id relies on case sensitivity. Recreating the theme_id
    cleaned_theme_df = cleaned_theme_df.assign(theme_id=(cleaned_theme_df["theme_id_old"]).astype("category").cat.codes)
    ~~~~
    
  4. Field partners dataframe:
    ~~~~python
    # Rename the columns that have spaces or capital letters
    field_partner_df.rename(index=str, columns = {"Partner ID":"partner_id","Field Partner Name":"field_partner_name","Loan Theme     ID":"theme_id","Loan Theme Type":"theme_type","ISO":"iso","LocationName":"location_name","sector":"partner_sector"},inplace=True)
    field_partner_df = field_partner_df[["partner_id","field_partner_name","partner_sector"]].copy()
    field_partner_df.drop_duplicates(keep="first",inplace=True)
    
    # Merge loans and partner dataframes to make sure there aren't partners not attached to loans
    loan_partner_df = pd.merge(cleaned_kiva_loans_df,field_partner_df,how="left",left_on="partner_id",right_on="partner_id")
    
    # Create cleaned dataframe with only the relevant columns and drop all duplicates
    cleaned_field_partner_df = loan_partner_df[["partner_id","field_partner_name","partner_sector"]].copy()
    cleaned_field_partner_df.drop_duplicates(subset=["partner_id"],keep="first",inplace=True)
    cleaned_field_partner_df.dropna(subset=["partner_id"],how="any",inplace=True)
    ~~~~
## Transform
### SQL: Creating the Schema
* Data is organized into a schema four tables (kiva_loans, loan_regions, loan_themes, and field_partners)
* Complete the following in MySQL to create the schema:
    * Use a SQL script to establish the database:
    ~~~~SQL
    CREATE DATABASE IF NOT EXISTS kiva_db;
    USE kiva_db;
    ALTER DATABASE kiva_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    
    DROP TABLE IF EXISTS kiva_loans;
    DROP TABLE IF EXISTS loan_regions;
    DROP TABLE IF EXISTS loan_themes;
    DROP TABLE IF EXISTS field_partners;
    ~~~~
    * In the Kiva database, create the four separate tables:
    1. Field partners
    ~~~~SQL
    CREATE TABLE field_partners(
    	partner_id INT,
	field_partner_name VARCHAR(200),
	partner_sector VARCHAR(50),
	PRIMARY KEY(partner_id)
	);
    ~~~~
    2. Loan themes
    ~~~~SQL
    CREATE TABLE loan_themes(
    	theme_id VARCHAR(100),
	theme_type VARCHAR(100),
	PRIMARY KEY(theme_id)
	);
    ~~~~
    3. Loan regions
    ~~~~SQL
    CREATE TABLE loan_regions(
    	location_id INT,
	iso VARCHAR(5),
	country VARCHAR(50),
	region VARCHAR(100),
	world_region VARCHAR(50),
	mpi FLOAT,
	lat FLOAT,
	lon FLOAT,
	PRIMARY KEY(location_id)
	);
    ~~~~        
    4. Kiva loans
    ~~~~SQL
    CREATE TABLE kiva_loans(
    	loan_id INT,
	funded_amount FLOAT,
	loan_amount FLOAT,
	activity VARCHAR(100),
	loan_sector VARCHAR(100),
	purpose MEDIUMTEXT,
	currency VARCHAR(5),
	partner_id INT,
	posted_time DATETIME,
	disbursed_time DATETIME,
	funded_time DATETIME,
	term_in_months FLOAT,
	lender_count INT,
	repayment_interval VARCHAR(50),
	date DATE,
	num_fem_borrowers INT,
	num_m_borrowers INT,
	total_borrowers INT,
	location_id INT,
	theme_id VARCHAR(100),
	PRIMARY KEY(loan_id),
	FOREIGN KEY(partner_id) REFERENCES field_partners(partner_id) ON DELETE CASCADE,
	FOREIGN KEY(theme_id) REFERENCES loan_themes(theme_id) ON DELETE CASCADE,
	FOREIGN KEY(location_id) REFERENCES loan_regions(location_id) ON DELETE CASCADE
	);
    ~~~~    
