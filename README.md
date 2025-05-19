# Data Analytics SQL Assessment

This assessment consists of four SQL-based data tasks aimed at helping stakeholders across finance, marketing, and operations teams gain insights from customer and transaction data.

---

## ✅ Question 1: High-Value Customers with Multiple Products

**Objective:**  
Identify customers who have both at least one funded savings plan and one funded investment plan.

**Approach:**  
- Used `plans_plan` and `users_customuser` tables.
- Counted:
  - `is_regular_savings = 1` → savings
  - `is_a_fund = 1` or `is_managed_portfolio = 1` → investment
- Filtered on `amount > 0` and `is_deleted = 0`.
- Grouped by user and filtered for users who have both.

**Challenges:**  
- Needed to infer plan types from multiple boolean flags (`is_regular_savings`, `is_a_fund`, `is_managed_portfolio`) rather than a single `plan_type_id`.

---

## ✅ Question 2: Transaction Frequency Analysis

**Objective:**  
Classify customers based on their average transaction frequency per month.

**Approach:**  
- Used `savings_savingsaccount` and `users_customuser`.
- Calculated total transactions per customer and active months using `MIN(created_on)` to `MAX(created_on)`.
- Categorized based on average monthly transactions:
  - High: ≥ 10/month
  - Medium: 3–9/month
  - Low: ≤ 2/month

**Challenges:**  
- The schema lacked a clear `transaction_date`, so we assumed `created_on` could serve as a proxy.

---

## ✅ Question 3: Account Inactivity Alert

**Objective:**  
Identify savings or investment accounts with no transactions in the last 365 days.

**Approach:**  
- Queried both `savings_savingsaccount` and `plans_plan`.
- Used `created_on` for savings and `last_charge_date` for investments.
- Filtered records where `DATEDIFF(CURDATE(), last_transaction_date) > 365`.

**Challenges:**  
- Different tables used different date fields to track transactions, so separate logic was applied and unified via a `UNION`.

---

## ✅ Question 4: Customer Lifetime Value (CLV) Estimation

**Objective:**  
Estimate CLV using transaction volume and account tenure.

**Approach:**  
- Used `savings_savingsaccount` for transaction volume and `users_customuser.date_joined` for tenure.
- Converted kobo to naira.
- Used formula:  
  `(total_transactions / tenure_months) * 12 * (0.1% of avg transaction value)`

**Challenges:**  
- Had to account for users with 0 tenure to avoid division by zero.
- CLV required combining multiple aggregated metrics in one expression.

---
