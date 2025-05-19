-- Assessment_Q3.sql
-- Question 3: Account Inactivity Alert

USE adashi_staging;

-- UNION both plan types and calculate inactivity
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    DATE(p.last_charge_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), p.last_charge_date) AS inactivity_days
FROM 
    plans_plan p
WHERE 
    p.is_deleted = 0
    AND p.last_charge_date IS NOT NULL
    AND DATEDIFF(CURDATE(), p.last_charge_date) > 365

UNION

SELECT 
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    DATE(s.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), s.created_on) AS inactivity_days
FROM 
    savings_savingsaccount s
WHERE 
    s.created_on IS NOT NULL
    AND DATEDIFF(CURDATE(), s.created_on) > 365;
