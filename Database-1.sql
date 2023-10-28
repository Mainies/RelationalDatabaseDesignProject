--Final SQL File for DB creation
--Samuel Mainwood

-- Creating Tables and Importing Data

CREATE TABLE Country(
Name TEXT NOT NULL,
CountryCode TEXT PRIMARY KEY NOT NULL) 
WITHOUT ROWID;


CREATE TABLE Source(
SourceName TEXT NOT NULL,
SourceURL TEXT NOT NULL,
PRIMARY KEY (SourceName, SourceURL)
)
WITHOUT ROWID;


CREATE TABLE Manufacturer(
ManufacturerName TEXT PRIMARY KEY NOT NULL
)WITHOUT ROWID;


CREATE TABLE State (
StateName TEXT NOT NULL,
CountryCode TEXT NOT NULL,
PRIMARY KEY (StateName, CountryCode),
FOREIGN KEY (CountryCode) REFERENCES Country (CountryCode)
)WITHOUT ROWID;



CREATE TABLE StatePopulation (
Date TEXT NOT NULL,
StateName TEXT NOT NULL,
CountryCode TEXT NOT NULL,
Population REAL, --Due to it being a calculated figure, it is kept at real to keep accuracy,
PRIMARY KEY (CountryCode, StateName, Date),
FOREIGN KEY (StateName, CountryCode) REFERENCES State (StateName, CountryCode)
) WITHOUT ROWID;


CREATE TABLE CountryPopulation (
    CountryCode TEXT NOT NULL,
    Date TEXT NOT NULL,
    Population REAL,
    PRIMARY KEY (CountryCode, Date),
    FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode)
) WITHOUT ROWID;


CREATE TABLE StateStats (
    Date TEXT NOT NULL,
    StateName TEXT NOT NULL,
    CountryCode TEXT NOT NULL,
    Statistic TEXT,
    Value REAL,
    PRIMARY KEY (Date, StateName, CountryCode, Statistic),
    FOREIGN KEY (StateName, CountryCode) REFERENCES State(StateName, CountryCode)
) WITHOUT ROWID;


CREATE TABLE CountryStats (
    CountryCode TEXT NOT NULL,
    Date TEXT NOT NULL,
    Statistic TEXT NOT NULL,
    Value REAL,
    PRIMARY KEY (Date, CountryCode, Statistic),
    FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode)
) WITHOUT ROWID;


CREATE TABLE VaccinesByAgeGroup (
    CountryCode TEXT NOT NULL,
    Date TEXT NOT NULL,
    AgeGroup TEXT NOT NULL,
    Statistic TEXT NOT NULL,
    Value REAL,
    PRIMARY KEY (Date, CountryCode, AgeGroup, Statistic),
    FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode)
) WITHOUT ROWID;

CREATE TABLE VaccinesByManufacturer (
    CountryCode TEXT NOT NULL,
    Date TEXT NOT NULL,
    ManufacturerName TEXT NOT NULL,
    TotalVaccinations INTEGER,
    PRIMARY KEY (Date, CountryCode, ManufacturerName),
    FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode),
    FOREIGN KEY (ManufacturerName) REFERENCES Manufacturer (ManufacturerName)
) WITHOUT ROWID;

CREATE TABLE CountryDataSource (
    CountryCode TEXT,
    LatestDate TEXT,
    SourceURL TEXT,
    SourceName TEXT,
    PRIMARY KEY (LatestDate, CountryCode, SourceUrl),
    FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode),
    FOREIGN KEY (SourceURL, SourceName) REFERENCES Source(SourceURL, SourceName)
) WITHOUT ROWID;
--Checking the Imported Data for Errors
PRAGMA integrity_check;
--Returns OK;
