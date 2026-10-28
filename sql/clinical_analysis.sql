WITH 
current_standardized AS (
    SELECT 
        patient_id AS Pt_ID, 
        site_location,
        CASE
            WHEN LOWER(site_location) LIKE '%north%' THEN 'Site A - North'
            WHEN LOWER(site_location) LIKE '%south%' THEN 'Site B - South'
            WHEN LOWER(site_location) LIKE '%east%' THEN 'Site C - East'
            ELSE 'Unknown Site'
        END AS standardized_site, 
        risk_category, 
        enrollment_date AS standardized_date, 
        'Current System' AS data_source
    FROM patients_raw
),
legacy_standardized AS (
    SELECT 
        Pt_ID AS Pt_ID,
        Location_Code,
        CASE 
            WHEN LOWER(Location_Code) LIKE '%north%' THEN 'Site A - North'
            WHEN LOWER(Location_Code) LIKE '%south%' THEN 'Site B - South'
            WHEN LOWER(Location_Code) LIKE '%east%' THEN 'Site C - East'
            ELSE 'Unknown Site'
        END AS standardized_site,
        'Unspecified (Legacy)' AS risk_category,
        SUBSTR(Registration_Date, 7, 4) || '-' || 
        SUBSTR(Registration_Date, 1, 2) || '-' || 
        SUBSTR(Registration_Date, 4, 2) AS standardized_date,
        'Legacy Archive' AS data_source
    FROM historical_patient_archive
),
unified_master_patients AS (
    SELECT * FROM current_standardized
    UNION ALL
    SELECT * FROM legacy_standardized
),
cleaned_visits AS (
    SELECT 
        patient_id,
        visit_status,
        COALESCE(actual_date, '1900-01-01') AS verified_actual_date,
        COALESCE(data_queries_count, 0) AS verified_queries_count
    FROM clinical_visits_and_queries_raw
),
patient_safety_summary AS (
    SELECT 
        UPPER(TRIM(patient_id)) AS resolved_patient_id,
        COUNT(event_id) AS total_adverse_events,
        SUM(CASE WHEN UPPER(TRIM(ae_severity)) IN ('SEVERE', 'SERIOUS') THEN 1 ELSE 0 END) AS severe_events_count
    FROM patient_safety_events
    GROUP BY UPPER(TRIM(patient_id))
)
SELECT 
    m.standardized_site,
    m.data_source,
    COUNT(DISTINCT m.Pt_ID) AS total_patients_registered,
    SUM(CASE WHEN v.visit_status IN ('Completed', 'Finished') THEN 1 ELSE 0 END) AS successful_outcomes,
    SUM(v.verified_queries_count) AS total_data_queries,
    COALESCE(SUM(s.severe_events_count), 0) AS total_severe_adverse_events
FROM unified_master_patients m
LEFT JOIN cleaned_visits v ON UPPER(TRIM(m.Pt_ID)) = UPPER(TRIM(v.patient_id))
LEFT JOIN patient_safety_summary s ON UPPER(TRIM(m.Pt_ID)) = s.resolved_patient_id
GROUP BY m.standardized_site, m.data_source
ORDER BY m.standardized_site ASC, m.data_source ASC;
