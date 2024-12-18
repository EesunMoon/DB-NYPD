-- [Entity] NYPD
CREATE TABLE NYPD (
    PATRL_BORO_NM_ID INTEGER,
    PATRL_BORO_NM CHAR(3),
    BORO_NM CHAR(20),
    CHECK BORO_NM IN ("MANHATTAN","BRONX","QUEENS","BROOKLYN","STATEN ISLAND"),
    PRIMARY KEY (PATRL_BORO_NM_ID)
);

CREATE TABLE Crime_Location (
    CRIME_SCENE_ID INTEGER,
    LOC_OF_OCCUR_DESC CHAR(10),
    PREM_TYP_DESC CHAR(20),
    GEO_CD_X INTEGER,
    GEO_CD_Y INTEGER,
    Longitude REAL,
    Latitude REAL,
    CHECK (GEO_CD_X>0),
    CHECK (GEO_CD_Y>0),
    CHECK (Longitude>=-75 AND Longitude<=-73),
    CHECK (Latitude>=40 AND Latitude<=41),
    PRIMARY KEY (CRIME_SCENE_ID)
);

-- [Entity] Incident
CREATE TABLE Incident (
    CAD_EVNT_ID INTEGER,
    CIP_JOBS CHAR(20),
    LAW_CAT_CD CHAR(15),
    TYP_DESC VARCHAR(100), -- [Modification] CHAR(100) -> VARCHAR(100)
    PRIMARY KEY (CAD_EVNT_ID)
);

CREATE TABLE Radio_Code (
    RADIO_CODE_ID INTEGER,
    RADIO_CODE CHAR(5),
    PRIMARY KEY (RADIO_CODE_ID)
);

CREATE TABLE Send (
		CAD_EVNT_ID INTEGER,
    PATRL_BORO_NM_ID INTEGER,
    RADIO_CODE_ID INTEGER,
    PRIMARY KEY (CAD_EVNT_ID, PATRL_BORO_NM_ID, RADIO_CODE_ID),
    FOREIGN KEY (CAD_EVNT_ID) REFERENCES Incident (CAD_EVNT_ID),
    FOREIGN KEY (PATRL_BORO_NM_ID) REFERENCES NYPD (PATRL_BORO_NM_ID),
    FOREIGN KEY (RADIO_CODE_ID) REFERENCES Radio_Code (RADIO_CODE_ID)
);

-- [Relationship] Monitor
CREATE TABLE Monitor (
    CAD_EVNT_ID INTEGER,
    PATRL_BORO_NM_ID INTEGER,
    JURIS_DESC CHAR(20),
    CHECK (JURIS_DESC IN ("N.Y. POLICE DEPT","N.Y. TRANSIT POLICE")),
    PRIMARY KEY (CAD_EVNT_ID, PATRL_BORO_NM_ID),
    FOREIGN KEY (CAD_EVNT_ID) REFERENCES Incident (CAD_EVNT_ID),
    FOREIGN KEY (PATRL_BORO_NM_ID) REFERENCES NYPD (PATRL_BORO_NM_ID)
);
-- We cannot capture such participation constraints (yet) in SQL

-- [Relationship] Happended_at
CREATE TABLE Outbreak_Time (
    CMPLNT_FR_DT DATE,
    CMPLNT_FR_TM TIME,
    CMPLNT_TO_DT DATE,
    CMPLNT_TO_TM TIME,
    CHECK (CMPLNT_FR_DT<=CMPLNT_TO_DT),
    PRIMARY KEY (CMPLNT_FR_DT, CMPLNT_FR_TM, CMPLNT_TO_DT, CMPLNT_TO_TM)
);

-- [Relationship] Arrive
CREATE TABLE Dispatch_Duration (
    DISP_TS TIMESTAMP,
    ARRIVD_TS TIMESTAMP,
    CHECK (DISP_TS <= ARRIVD_TS),
    PRIMARY KEY (DISP_TS, ARRIVD_TS)
);

CREATE TABLE Arrive (
		CRIME_SCENE_ID INTEGER,
    PATRL_BORO_NM_ID INTEGER,
    DISP_TS TIMESTAMP,
    ARRIVD_TS TIMESTAMP,
    CHECK (DISP_TS<=ARRIVD_TS),
    PRIMARY KEY (CRIME_SCENE_ID, PATRL_BORO_NM_ID, DISP_TS, ARRIVD_TS),
    FOREIGN KEY (CRIME_SCENE_ID) REFERENCES Crime_Location (CRIME_SCENE_ID),
    FOREIGN KEY (PATRL_BORO_NM_ID) REFERENCES NYPD (PATRL_BORO_NM_ID),
    FOREIGN KEY (DISP_TS, ARRIVD_TS) REFERENCES Dispatch_Duration (DISP_TS, ARRIVD_TS)
);

-- [Call + Incident]
CREATE TABLE Incident_Caller(
	CAD_EVNT_ID INTEGER,
	CIP_JOBS CHAR(20),
	LAW_CAT_CD CHAR(15),
	TYP_DESC VARCHAR(100), -- [Modification] CHAR(100) -> VARCHAR(100)
	PATRL_BORO_NM_ID INTEGER NOT NULL,
	CREATE_DATE TIMESTAMP NOT NULL,
	PRIMARY KEY (CAD_EVNT_ID),
	FOREIGN KEY (PATRL_BORO_NM_ID) REFERENCES NYPD (PATRL_BORO_NM_ID)
)

-- [Add System + Incident]
CREATE TABLE Incident_Adder(
	CAD_EVNT_ID INTEGER,
	CIP_JOBS CHAR(20),
	LAW_CAT_CD CHAR(20),
	TYP_DESC VARCHAR(100),-- [Modification] CHAR(100) -> VARCHAR(100)
	PATRL_BORO_NM_ID INTEGER NOT NULL,
	ADDED_TIME TIMESTAMP NOT NULL,
	PRIMARY KEY (CAD_EVNT_ID),
	FOREIGN KEY (PATRL_BORO_NM_ID) REFERENCES NYPD (PATRL_BORO_NM_ID)
)

-- [Close + Incident]
CREATE TABLE Incident_Closer(
	CAD_EVNT_ID INTEGER,
	CIP_JOBS CHAR(20),
  LAW_CAT_CD CHAR(15),
  TYP_DESC VARCHAR(100), -- [Modification] CHAR(100) -> VARCHAR(100)
  PATRL_BORO_NM_ID INTEGER NOT NULL,
  CLOSING_TS TIMESTAMP NOT NULL,
  PRIMARY KEY (CAD_EVNT_ID), -- [Modification] ,
  FOREIGN KEY (PATRL_BORO_NM_ID) REFERENCES NYPD (PATRL_BORO_NM_ID)
)

-- [Located at + Crime Location]
CREATE TABLE Incident_Location(
	CAD_EVNT_ID INTEGER,
	CIP_JOBS CHAR(20), --
  LAW_CAT_CD CHAR(15), --
  TYP_DESC CHAR(100), --
  CRIME_SCENE_ID INTEGER NOT NULL,
  PRIMARY KEY (CAD_EVNT_ID),
  FOREIGN KEY (CRIME_SCENE_ID) REFERENCES Crime_Location (CRIME_SCENE_ID)
)

-- [Happened at + Crime Location]
CREATE TABLE Incident_Happened_Time(
	CAD_EVNT_ID INTEGER,
	CIP_JOBS CHAR(20), --
  LAW_CAT_CD CHAR(15), --
  TYP_DESC CHAR(100), --
	CRIME_SCENE_ID INTEGER NOT NULL,
  PRIMARY KEY (CAD_EVNT_ID),
  FOREIGN KEY (CRIME_SCENE_ID) REFERENCES Crime_Location (CRIME_SCENE_ID)
)
