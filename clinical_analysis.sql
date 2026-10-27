-- ADVANCED MULTI-SOURCE CLINICAL RESEARCH DATA CLEANING & RECONCILIATION PIPELINE
-- Author: Daira Santos
-- Description: Reconciles current trial logs with unupdated legacy archive data, standardizing formatting variations and missing entries.

-- STEP 1: Standardize Current Patient Records
WITH current_standardized AS (
    SELECT 
        patient_id AS pt_id,
        CASE 
            WHEN LOWER(site_location) LIKE '%north%' THEN 'Site A - North'
            WHEN LOWER(site_location) LIKE '%south%' THEN 'Site B - South'
            WHEN LOWER(site_location) LIKE '%east%' THEN 'Site C - East'
            ELSE 'Unknown Site'
        END AS standardized_site,
        risk_category,
        CAST(enrollment_date AS DATE) AS standardized_date,
        'Current System' as data_source
    FROM patients_raw
),

-- STEP 2: Standardize Legacy Archive Data (Fixing old formats & alternative naming conventions)
legacy_standardized AS (
    SELECT 
        Pt_ID AS pt_id,
        CASE 
            WHEN LOWER(Location_Code) LIKE '%north_branch_a%' THEN 'Site A - North'
            WHEN LOWER(Location_Code) LIKE '%south_branch_b%' THEN 'Site B - South'
            WHEN LOWER(Location_Code) LIKE '%east_branch_c%' THEN 'Site C - East'
            ELSE 'Unknown Site'
        END AS standardized_site,
        'Unspecified (Legacy)' AS risk_category,
        CAST(
            SUBSTR(Registration_Date, 7, 4) || '-' || 
            SUBSTR(Registration_Date, 1, 2) || '-' || 
            SUBSTR(Registration_Date, 4, 2) 
        AS DATE) AS standardized_date,
        'Legacy Archive' as data_source
    FROM historical_patient_archive
),

-- STEP 3: Combine Current and Relevant Historical Data into a Unified Master View
unified_master_patients AS (
    SELECT * FROM current_standardized
    UNION ALL
    SELECT * FROM legacy_standardized
),

-- STEP 4: Standardize Visit and Query Metrics
cleaned_visits AS (
    SELECT 
        patient_id,
        visit_status,
        COALESCE(actual_date, '1900-01-01') AS verified_actual_date,
        COALESCE(data_queries_count, 0) AS verified_queries_count
    FROM clinical_visits_and_queries_raw
)

-- STEP 5: Final Aggregate Master KPI Report across All Data Sources
SELECT 
    m.standardized_site,
    m.data_source,
    COUNT(DISTINCT m.pt_id) AS total_patients_registered,
    SUM(CASE WHEN v.visit_status IN ('Completed', 'Finished') THEN 1 ELSE 0 END) AS successful_outcomes,
    SUM(v.verified_queries_count) AS total_data_queries
FROM unified_master_patients m
LEFT JOIN cleaned_visits v ON m.pt_id = v.patient_id
GROUP BY m.standardized_site, m.data_source
ORDER BY m.standardized_site;
