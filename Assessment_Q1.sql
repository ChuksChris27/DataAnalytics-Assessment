-- Assessment_Q1.sql
-- Question 1: High-Value Customers with Multiple Products

USE adashi_staging;

SELECT 
    u.id AS owner_id,
    COALESCE(u.first_name, 'Unknown') AS name,

    -- Count of distinct funded savings plans
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 
             AND p.amount > 0 
             AND p.is_deleted = 0 
        THEN p.id 
    END) AS savings_count,

    -- Count of distinct funded investment plans
    COUNT(DISTINCT CASE 
        WHEN (p.is_a_fund = 1 OR p.is_managed_portfolio = 1)
             AND p.amount > 0 
             AND p.is_deleted = 0 
        THEN p.id 
    END) AS investment_count,

    -- Total deposits across all valid savings/investment plans
    SUM(CASE 
        WHEN (p.is_regular_savings = 1 OR p.is_a_fund = 1 OR p.is_managed_portfolio = 1)
             AND p.amount > 0 
             AND p.is_deleted = 0 
        THEN p.amount 
        ELSE 0 
    END) AS total_deposits

FROM 
    users_customuser u

LEFT JOIN 
    plans_plan p 
    ON u.id = p.owner_id

GROUP BY 
    u.id, u.first_name

-- Filter only those with at least one savings and one investment plan
HAVING 
    savings_count > 0 
    AND investment_count > 0

ORDER BY 
    total_deposits DESC;

