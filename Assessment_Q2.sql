-- Assessment_Q2.sql
-- Question 2: Transaction Frequency Analysis

USE adashi_staging;

WITH transaction_summary AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS active_months
    FROM 
        savings_savingsaccount s
    GROUP BY 
        s.owner_id
),
monthly_activity AS (
    SELECT 
        t.owner_id,
        COALESCE(u.first_name, 'Unknown') AS name,
        t.total_transactions,
        t.active_months,
        ROUND(t.total_transactions / t.active_months, 1) AS avg_tx_per_month
    FROM 
        transaction_summary t
    JOIN 
        users_customuser u ON u.id = t.owner_id
),
categorized AS (
    SELECT 
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM 
        monthly_activity
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM 
    categorized
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
