# 🏥 Clinical Trial Patient Retention & Data Governance Pipeline

### 📌 Project Overview
In multi-site clinical trials, data migrations and manual entry often result in legacy archives using outdated formats, alternative column names (`Pt_ID` vs `patient_id`), and different date structures (`MM/DD/YYYY`). This project demonstrates an advanced data cleaning pipeline that reconciles current operational databases with relevant unupdated historical archives.

---

### ⚙️ Advanced Data Engineering & Reconciliation Logic
* **Multi-Source Unioning (`UNION ALL`):** Merged current system records with legacy archive files seamlessly.
* **Legacy Date Parsing & Transformation:** Converted string-based legacy date formats (`MM/DD/YYYY`) into standard SQL date structures.
* **Cross-System Text Standardization:** Mapped disparate legacy location codes (`North_Branch_A`) to modern standardized naming conventions (`Site A - North`).
* **Missing Value & Null Management:** Handled unrecorded tracking notes and missing visit markers using conditional fallback logic (`COALESCE`).

---

### 📊 Key Performance Indicators (KPIs Tracked)
1. **Retention & Success Rate:** Percentage of patients successfully completing study milestones across sites.
2. **Data Query Load:** Total data entry discrepancies flagged per clinic, highlighting where staff data entry training is required.
3. **Multi-Source Reconciliation:** Tracking patient distribution across modern and legacy database versions.

---

### 📁 Repository Structure
* `/patients_raw.csv` — Current participant intake records with formatting irregularities.
* `/clinical_visits_and_queries_raw.csv` — Current clinical visit logs and error flags.
* `/historical_patient_archive.csv` — Unupdated legacy archive requiring format transformation.
* `/clinical_analysis.sql` — Multi-table SQL script handling data unioning, cleaning, and master KPI aggregation.
* 📄 [Download Daira Santos' Resume (PDF)](./Daira%20Santos%20-%20Resume.pdf)
