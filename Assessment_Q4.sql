-- Assessment_Q4.sql
-- Question 4: Customer Lifetime Value (CLV) Estimation

USE adashi_staging;

WITH transaction_data AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) / 100.0 AS total_value_naira,
        AVG(s.confirmed_amount) / 100.0 AS avg_transaction_value_naira
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0
    GROUP BY 
        s.owner_id
),
tenure_data AS (
    SELECT 
        u.id AS customer_id,
        COALESCE(u.first_name, 'Unknown') AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM 
        users_customuser u
),
combined AS (
    SELECT 
        t.customer_id,
        t.name,
        td.total_transactions,
        td.total_value_naira,
        td.avg_transaction_value_naira,
        t.tenure_months,
        
        -- CLV formula using simplified model
        ROUND((
            (td.total_transactions / t.tenure_months) * 12 * (0.001 * td.avg_transaction_value_naira)
        ), 2) AS estimated_clv

    FROM 
        tenure_data t
    JOIN 
        transaction_data td ON t.customer_id = td.owner_id
    WHERE 
        t.tenure_months > 0
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM 
    combined
ORDER BY 
    estimated_clv DESC;
