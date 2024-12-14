CREATE TABLE NYPD (
		NYPD_PID INTEGER,
    PATRL_BORO_NM_ID INTEGER,
    PATRL_BORO_NM CHAR(50),
    BORO_NM CHAR(20) CHECK (BORO_NM IN ('MANHATTAN','BRONX','QUEENS','BROOKLYN','STATEN ISLAND')),
    PRIMARY KEY (NYPD_PID)
);

CREATE TABLE Transit_Police(
	NYPD_PID INTEGER,
	TransitDistrict INTEGER,
	Officer_Name CHAR(50),
	Officer_Phone CHAR(40),
	Officer_Loc CHAR(200),
	PRIMARY KEY (NYPD_PID),
	FOREIGN KEY (NYPD_PID) REFERENCES NYPD (NYPD_PID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Precinct(
	NYPD_PID INTEGER,
	NYPD_PCT_CD INTEGER,
	PCT_Name CHAR(40),
	PCT_Address CHAR(50),
	PCT_Phone CHAR(20),
	PRIMARY KEY (NYPD_PID),
	FOREIGN KEY (NYPD_PID) REFERENCES NYPD (NYPD_PID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Without ASSERTIONs, we cannot map the model:
-- The constraints of Transit_Police and Precinct cover NYPD, and
-- The constraints of Transit_Police and Precinct do not overlap.

CREATE TABLE Victim_Who_Harmed (
    VicTypeID INTEGER,
    VIC_RACE CHAR(40),
    VIC_SEX CHAR(1),
    SusTypeID INTEGER,
    PRIMARY KEY (VicTypeID, SusTypeID),
    FOREIGN KEY (SusTypeID) REFERENCES Suspect_Type(SusTypeID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Suspect_Type(
	SusTypeID INTEGER,
	SUS_AGE_GROUP CHAR(20),
	SUS_RACE CHAR(40),
	SUS_SEX CHAR(1),
	PRIMARY KEY (SusTypeID)
);


CREATE TABLE Harm (
    VicTypeID INTEGER,
    SusTypeID INTEGER,
    PRIMARY KEY (VicTypeID, SusTypeID),
    FOREIGN KEY (VicTypeID, SusTypeID) REFERENCES Victim_Who_Harmed(VicTypeID, SusTypeID),
    FOREIGN KEY (SusTypeID) REFERENCES Suspect_Type(SusTypeID)
);

CREATE TABLE Court(
	COURT_PID INTEGER,
	COURT_TYPE CHAR(30),
	COURT_DESC VARCHAR(300),
	COURT_ADDRESS VARCHAR(70),
	COURT_PHONE CHAR(15),
	PRIMARY KEY (COURT_PID)
);
CREATE TABLE Judged_Incident(
	INCIDENT_PID INTEGER,
	CAD_EVNT_ID INTEGER,
  CIP_JOBS CHAR(20),
  LAW_CAT_CD CHAR(15),
  TYP_DESC VARCHAR(100), 
  COURT_PID INTEGER,
  PRIMARY KEY (INCIDENT_PID),
  FOREIGN KEY (COURT_PID) REFERENCES Court (COURT_PID)
);

CREATE TABLE Hospital(
	HospitalID INTEGER,
	H_NAME CHAR(80),
	H_TYPE CHAR(30),
	H_PHONE CHAR(25),
	H_BOROUGH CHAR(15),
	H_Location CHAR(100),
	CHECK (H_BOROUGH IN ('Manhattan','Bronx','Queens','Brooklyn','Staten Island')),
	PRIMARY KEY (HospitalID)
);

CREATE TABLE NEAR (
	CRIME_SCENE_PID INTEGER,
	HospitalID INTEGER,
	PRIMARY KEY (CRIME_SCENE_PID,HospitalID),
	FOREIGN KEY (CRIME_SCENE_PID) REFERENCES Crime_Scene (CRIME_SCENE_PID),
	FOREIGN KEY (HospitalID) REFERENCES Hospital (HospitalID)
);
-- Without Assertions, we cannot capture a participation constraint between Near and Hospital (yet) in SQL

CREATE TABLE Occured(
	INCIDENT_PID INTEGER,
	VicTypeID INTEGER,
	SusTypeID INTEGER,
	CRIME_SCENE_PID INTEGER NOT NULL,
	PRIMARY KEY (INCIDENT_PID, VicTypeID, SusTypeID, CRIME_SCENE_PID),
	FOREIGN KEY (INCIDENT_PID) REFERENCES Incident (INCIDENT_PID),
	FOREIGN KEY (VicTypeID,SusTypeID) REFERENCES Harm (VicTypeID,SusTypeID),
	FOREIGN KEY (CRIME_SCENE_PID) REFERENCES Crime_Scene (CRIME_SCENE_PID)
);

-- Cannot capture a participation constraint of Incident (yet) in SQL
CREATE TABLE Dispatch_Duration(
	DISPATCH_DURATION_PID INTEGER,
	DISP_TS TIMESTAMP,
	ARRIVD_TS TIMESTAMP,
	CHECK (DISP_TS<ARRIVD_TS),
	PRIMARY KEY (DISPATCH_DURATION_PID)
)
-- Without Assertions, we cannot capture a participation constraint between Near and Hospital (yet) in SQL
