# Database ETL of NYC Crime Analysis

## Project Overview
This project involves the development of a comprehensive database system to analyze NYC crime data. The primary objective was to integrate and process real-world public datasets into a structured format for deeper insights into crime patterns and stakeholder involvement. Utilizing PostgreSQL for data management and relational mapping, we implemented a robust ETL (Extract, Transform, Load) pipeline, designed a custom ER diagram, and developed a queryable database schema.

---

## E/R Diagram - Part3
![Project1 - Part3](https://github.com/user-attachments/assets/e4c3b20f-051b-432a-9f9b-ebc9a328bd0d)

## Key Features
### 1. Data Integration and Preprocessing
- Integrated two large-scale public datasets:
  - [NYPD Calls for Service](https://data.cityofnewyork.us/Public-Safety/NYPD-Calls-for-Service-Year-to-Date-/n2zq-pubd/about_data) (5.43M rows, 18 columns)
  - [NYPD Complaint Data Historic](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i/about_data) (8.91M rows, 35 columns)
- Preprocessed and resolved inconsistencies in raw datasets, reducing redundant information while ensuring alignment with database constraints.

### 2. Schema Design and Implementation
- Designed an enhanced ER diagram with entities such as `Crime_Scene`, `Incident`, `NYPD`, `Dispatch_Duration`, and relationships like `Monitor`, `Send`, `Arrive`, and `Occurred`.
- Integrated ISA hierarchies for the `NYPD` entity (`Transit_Police` and `Precinct`) to model specialization and total participation constraints.
- Mapped the ER diagram into a normalized PostgreSQL schema.

### 3. Advanced Features
- Implemented triggers to enforce participation and integrity constraints (e.g., ensuring `Crime_Scene` is linked to a valid `Incident`).
- Added array attributes to store multi-dimensional contact information (e.g., sub-officer details for `Transit_Police`).
- Integrated a text search feature for court reviews using the `TEXT` data type.

### 4. Query Development
- Designed and executed 10+ complex SQL queries to analyze:
  - Crime patterns by location and time.
  - Victim demographics by race and gender.
  - Stakeholder (hospital and court) involvement in crime responses.

---

## Technical Details
- **Database Management System**: PostgreSQL
- **Entities and Relationships**: Modeled real-world scenarios with a revised ER diagram incorporating feedback and stakeholder considerations.
- **Triggers and Constraints**:
  - Ensured database integrity with custom triggers for participation and ISA constraints.
  - Implemented cascading updates and deletions for hierarchical data models.

---

## Insights and Contributions
- **Quantitative Impact**:
  - Processed over **14M+ raw records** into an actionable database.
  - Enabled crime pattern analysis through SQL queries with sub-second response times.
- **Contributions**:
  - Collaborative project with schema design, data preprocessing, and query optimization responsibilities distributed among team members.
