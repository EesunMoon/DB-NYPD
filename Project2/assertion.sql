ALTER TABLE court
ADD COLUMN review TEXT[];

ALTER TABLE transit_police
ADD COLUMN sub_officers_info text[][];

CREATE OR REPLACE FUNCTION enforce_hospital_participation()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Near
        WHERE Near.HospitalID = NEW.HospitalID
    ) THEN
        RAISE EXCEPTION 'Participation constraint violated: HospitalID % must exist in the Near relationship.', NEW.HospitalID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TotalPartHostCrim
AFTER INSERT ON Hospital
FOR EACH ROW
EXECUTE FUNCTION enforce_hospital_participation();

CREATE OR REPLACE FUNCTION enforce_incident_participation()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Monitor
        WHERE Monitor.INCIDENT_PID = NEW.INCIDENT_PID
    ) THEN
        RAISE EXCEPTION 'Participation constraint violated: INCIDENT_PID % must exist in the Monitor relationship.', NEW.INCIDENT_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TotalPartInciNYPD
BEFORE INSERT ON Incident
FOR EACH ROW
EXECUTE FUNCTION enforce_incident_participation();


CREATE OR REPLACE FUNCTION enforce_dispatch_arrive_participation()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Arrive
        WHERE Arrive.DISPATCH_DURATION_PID = NEW.DISPATCH_DURATION_PID
    ) THEN
        RAISE EXCEPTION 'Participation constraint violated: DISPATCH_DURATION_PID % must exist in the Arrive table.', NEW.DISPATCH_DURATION_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TotalPartDispArri
BEFORE INSERT OR UPDATE ON Dispatch_Duration
FOR EACH ROW
EXECUTE FUNCTION enforce_dispatch_arrive_participation();


CREATE OR REPLACE FUNCTION enforce_crime_arrive_participation()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Arrive
        WHERE Arrive.CRIME_SCENE_PID = NEW.CRIME_SCENE_PID
    ) THEN
        RAISE EXCEPTION 'Participation constraint violated: CRIME_SCENE_PID % must exist in the Arrive table.', NEW.CRIME_SCENE_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TotalPartCrimArri
BEFORE INSERT OR UPDATE ON Crime_Scene
FOR EACH ROW
EXECUTE FUNCTION enforce_crime_arrive_participation();

CREATE OR REPLACE FUNCTION enforce_incident_send_participation()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Send
        WHERE Send.INCIDENT_PID = NEW.INCIDENT_PID
    ) THEN
        RAISE EXCEPTION 'Participation constraint violated: INCIDENT_PID % must exist in the Send relationship.', NEW.INCIDENT_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TotalPartInciSend
BEFORE INSERT OR UPDATE ON Incident
FOR EACH ROW
EXECUTE FUNCTION enforce_incident_send_participation();

CREATE OR REPLACE FUNCTION enforce_incident_occurred_participation()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Occurred
        WHERE Occurred.INCIDENT_PID = NEW.INCIDENT_PID
    ) THEN
        RAISE EXCEPTION 'Participation constraint violated: INCIDENT_PID % must exist in the Occurred relationship.', NEW.INCIDENT_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TotalPartInciOccur
BEFORE INSERT OR UPDATE ON Incident
FOR EACH ROW
EXECUTE FUNCTION enforce_incident_occurred_participation();

CREATE OR REPLACE FUNCTION enforce_no_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Transit_Police WHERE NYPD_PID = NEW.NYPD_PID) AND
       EXISTS (SELECT 1 FROM Precinct WHERE NYPD_PID = NEW.NYPD_PID) THEN
        RAISE EXCEPTION 'No overlap constraint violated: NYPD_PID % exists in both Transit_Police and Precinct.', NEW.NYPD_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_no_overlap_on_transit_police
BEFORE INSERT OR UPDATE ON Transit_Police
FOR EACH ROW
EXECUTE FUNCTION enforce_no_overlap();

CREATE TRIGGER enforce_no_overlap_on_precinct
BEFORE INSERT OR UPDATE ON Precinct
FOR EACH ROW
EXECUTE FUNCTION enforce_no_overlap();

CREATE OR REPLACE FUNCTION enforce_coverage()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Transit_Police WHERE NYPD_PID = NEW.NYPD_PID) AND
       NOT EXISTS (SELECT 1 FROM Precinct WHERE NYPD_PID = NEW.NYPD_PID) THEN
        RAISE EXCEPTION 'Coverage constraint violated: NYPD_PID % must exist in either Transit_Police or Precinct.', NEW.NYPD_PID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_coverage_on_nypd
AFTER INSERT OR UPDATE ON NYPD
FOR EACH ROW
EXECUTE FUNCTION enforce_coverage();
