## 🏥 Clinical Trial Patient Retention & Safety Analytics Pipeline

A robust end-to-end SQL data pipeline and analytics portfolio project built in **SQLite**. This project demonstrates multi-source clinical data harmonization, schema standardization, patient ID reconciliation, and automated safety signal tracking for clinical trial management.

---

## 🛠️ Tech Stack & Skills Demonstrated

* **Database & Querying:** SQL (SQLite / DB Browser)
* **Advanced SQL Techniques:** Common Table Expressions (CTEs), `UNION ALL`, `LEFT JOIN` aggregations, Case-insensitive String Normalization (`UPPER(TRIM())`), Conditional Aggregation (`SUM(CASE WHEN...)`), Date Parsing (`SUBSTR`), and Multi-column Sorting (`ORDER BY`).
* **Data Engineering & Quality Control:** Schema standardization, legacy system integration, missing value handling (`COALESCE`), and audit query design.
* **Reporting & Visualization:** Excel Executive Dashboards, KPI Scorecards, and Granular Patient Audit Logs.

---

## 📁 Repository Structure

```text
clinical-trial-patient-retention/
│
├── README.md                                # Executive overview & technical documentation
├── Daira Santos - Resume.pdf                # Candidate resume & qualifications
│
├── data/                                    # Raw & standardized source datasets
│   ├── patients_raw.csv                     # Active system patient registry
│   ├── historical_patient_archive.csv        # Legacy archive records
│   ├── clinical_visits_and_queries_raw.csv  # Visit tracking & data query logs
│   └── patient_safety_events.csv            # Adverse event tracking logs
│
├── sql/                                     # Core SQL pipeline scripts
│   └── clinical_analysis.sql                # Full SQL script (ETL, master & audit queries)
│
└── reports/                                 # Business intelligence outputs
    ├── clinical_trial_report.csv            # Formatted multi-tab
    └── _clinical_kpi_report.csv             # Exported site-level aggregate KPIs
