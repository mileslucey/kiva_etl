CREATE DATABASE IF NOT EXISTS kiva_db;
USE kiva_db;
ALTER DATABASE kiva_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS kiva_loans;
DROP TABLE IF EXISTS loan_regions;
DROP TABLE IF EXISTS loan_themes;
DROP TABLE IF EXISTS field_partners;

CREATE TABLE field_partners(
	partner_id INT,
    field_partner_name VARCHAR(200),
    partner_sector VARCHAR(50),
    PRIMARY KEY(partner_id)
);

CREATE TABLE loan_themes(
	theme_id VARCHAR(100),
    theme_type VARCHAR(100),
	PRIMARY KEY(theme_id)
);

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