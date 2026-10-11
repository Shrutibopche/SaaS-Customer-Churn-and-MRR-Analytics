-- SAAS CUSTOMER CHURN & MRR ANALYTICS PROJECT

-- ============================================================================
-- SAAS CUSTOMER CHURN & MRR ANALYTICS PROJECT
-- Complete Schema, Seed Data, and Core Business Queries
-- ============================================================================

-- 1. CLEANUP PREVIOUS SCHEMAS
DROP TABLE IF EXISTS fact_support CASCADE;
DROP TABLE IF EXISTS fact_usage CASCADE;
DROP TABLE IF EXISTS fact_payments CASCADE;
DROP TABLE IF EXISTS fact_subscriptions CASCADE;
DROP TABLE IF EXISTS dim_plans CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;


-- 2. CREATE DIMENSION TABLES

CREATE TABLE dim_customers (
    customer_id     VARCHAR(20) PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    signup_date     DATE NOT NULL,
    country         VARCHAR(50),
    company_size    VARCHAR(20),
    segment         VARCHAR(30)
);

CREATE TABLE dim_plans (
    plan_id         VARCHAR(20) PRIMARY KEY,
    plan_name       VARCHAR(50) NOT NULL,
    billing_cycle   VARCHAR(20) NOT NULL,
    monthly_fee     NUMERIC(10, 2) NOT NULL
);


-- 3. CREATE FACT TABLES

CREATE TABLE fact_subscriptions (
    subscription_id VARCHAR(20) PRIMARY KEY,
    customer_id     VARCHAR(20) NOT NULL REFERENCES dim_customers(customer_id) ON DELETE CASCADE,
    plan_id         VARCHAR(20) NOT NULL REFERENCES dim_plans(plan_id),
    start_date      DATE NOT NULL,
    end_date        DATE,
    status          VARCHAR(20) NOT NULL 
                    CHECK (status IN ('Active', 'Cancelled', 'Upgraded', 'Downgraded'))
);

CREATE TABLE fact_payments (
    payment_id      VARCHAR(20) PRIMARY KEY,
    customer_id     VARCHAR(20) NOT NULL REFERENCES dim_customers(customer_id) ON DELETE CASCADE,
    amount          NUMERIC(10, 2) NOT NULL,
    payment_date    DATE NOT NULL,
    payment_status  VARCHAR(20) NOT NULL 
                    CHECK (payment_status IN ('Success', 'Failed', 'Refunded'))
);

CREATE TABLE fact_usage (
    usage_id        VARCHAR(20) PRIMARY KEY,
    customer_id     VARCHAR(20) NOT NULL REFERENCES dim_customers(customer_id) ON DELETE CASCADE,
    feature_name    VARCHAR(100) NOT NULL,
    usage_count     INT NOT NULL,
    activity_date   DATE NOT NULL
);

CREATE TABLE fact_support (
    ticket_id           VARCHAR(20) PRIMARY KEY,
    customer_id         VARCHAR(20) NOT NULL REFERENCES dim_customers(customer_id) ON DELETE CASCADE,
    issue_type          VARCHAR(100) NOT NULL,
    resolution_time_hrs NUMERIC(6, 2),
    satisfaction_score  INT CHECK (satisfaction_score BETWEEN 1 AND 5)
);


-- 4. INSERT DATA DIRECTLY (Zero CSV dependencies)


-- Plans Catalog

INSERT INTO dim_plans 
    (plan_id, plan_name, billing_cycle, monthly_fee) 
VALUES
    ('PLAN-BASIC', 'Starter Tier', 'Monthly', 29.00),
    ('PLAN-PRO',   'Professional Tier', 'Monthly', 99.00),
    ('PLAN-ENT',   'Enterprise Tier', 'Monthly', 299.00),
    ('PLAN-ANN',   'Enterprise Annual', 'Annual', 249.00);


-- Customer Cohorts

INSERT INTO dim_customers 
    (customer_id, customer_name, signup_date, country, company_size, segment) 
VALUES
    ('CUST_2001', 'CloudScale Technologies', '2025-01-05', 'United States', '51-200', 'Mid-Market'),
    ('CUST_2002', 'Apex FinTech Global', '2025-01-12', 'United Kingdom', '201-500', 'Enterprise'),
    ('CUST_2003', 'DataPeak Analytics', '2025-01-20', 'India', '11-50', 'SMB'),
    ('CUST_2004', 'GreenPulse Energy', '2025-02-01', 'Germany', '51-200', 'Mid-Market'),
    ('CUST_2005', 'Nova Retail Systems', '2025-02-14', 'United States', '1-10', 'SMB'),
    ('CUST_2006', 'Vortex Health Partners', '2025-02-25', 'Canada', '500+', 'Enterprise'),
    ('CUST_2007', 'Starlight Media', '2025-03-01', 'India', '11-50', 'SMB'),
    ('CUST_2008', 'Quantum Logistics', '2025-03-15', 'Australia', '51-200', 'Mid-Market'),
    ('CUST_2009', 'Prime Secure AI', '2025-03-22', 'United Kingdom', '11-50', 'Mid-Market'),
    ('CUST_2010', 'Horizon EdTech', '2025-04-02', 'United States', '1-10', 'SMB'),
    ('CUST_2011', 'Zenith Logistics', '2025-04-10', 'India', '51-200', 'Mid-Market'),
    ('CUST_2012', 'Aegis Security', '2025-04-18', 'United States', '201-500', 'Enterprise');


-- Subscription Lifecycles
-- Including Active, Upgrades, Downgrades, and Churn

INSERT INTO fact_subscriptions 
    (subscription_id, customer_id, plan_id, start_date, end_date, status) 
VALUES
    ('SUB_1001', 'CUST_2001', 'PLAN-BASIC', '2025-01-05', '2025-03-05', 'Upgraded'),
    ('SUB_1002', 'CUST_2001', 'PLAN-PRO',   '2025-03-05', NULL,         'Active'),
    ('SUB_1003', 'CUST_2002', 'PLAN-ENT',   '2025-01-12', NULL,         'Active'),
    ('SUB_1004', 'CUST_2003', 'PLAN-PRO',   '2025-01-20', '2025-04-20', 'Cancelled'),
    ('SUB_1005', 'CUST_2004', 'PLAN-PRO',   '2025-02-01', '2025-05-01', 'Cancelled'),
    ('SUB_1006', 'CUST_2005', 'PLAN-BASIC', '2025-02-14', NULL,         'Active'),
    ('SUB_1007', 'CUST_2006', 'PLAN-ENT',   '2025-02-25', NULL,         'Active'),
    ('SUB_1008', 'CUST_2007', 'PLAN-BASIC', '2025-03-01', '2025-04-01', 'Cancelled'),
    ('SUB_1009', 'CUST_2008', 'PLAN-PRO',   '2025-03-15', NULL,         'Active'),
    ('SUB_1010', 'CUST_2009', 'PLAN-PRO',   '2025-03-22', '2025-05-22', 'Downgraded'),
    ('SUB_1011', 'CUST_2009', 'PLAN-BASIC', '2025-05-22', NULL,         'Active'),
    ('SUB_1012', 'CUST_2010', 'PLAN-BASIC', '2025-04-02', NULL,         'Active'),
    ('SUB_1013', 'CUST_2011', 'PLAN-PRO',   '2025-04-10', NULL,         'Active'),
    ('SUB_1014', 'CUST_2012', 'PLAN-ENT',   '2025-04-18', NULL,         'Active');


-- Invoicing & Payments Ledger

INSERT INTO fact_payments 
    (payment_id, customer_id, amount, payment_date, payment_status) 
VALUES
    ('PAY_5001', 'CUST_2001', 29.00,  '2025-01-05', 'Success'),
    ('PAY_5002', 'CUST_2001', 29.00,  '2025-02-05', 'Success'),
    ('PAY_5003', 'CUST_2001', 99.00,  '2025-03-05', 'Success'),
    ('PAY_5004', 'CUST_2001', 99.00,  '2025-04-05', 'Success'),

    ('PAY_5005', 'CUST_2002', 299.00, '2025-01-12', 'Success'),
    ('PAY_5006', 'CUST_2002', 299.00, '2025-02-12', 'Success'),
    ('PAY_5007', 'CUST_2002', 299.00, '2025-03-12', 'Success'),
    ('PAY_5008', 'CUST_2002', 299.00, '2025-04-12', 'Success'),

    ('PAY_5009', 'CUST_2003', 99.00,  '2025-01-20', 'Success'),
    ('PAY_5010', 'CUST_2003', 99.00,  '2025-02-20', 'Success'),
    ('PAY_5011', 'CUST_2003', 99.00,  '2025-03-20', 'Failed'),

    ('PAY_5012', 'CUST_2004', 99.00,  '2025-02-01', 'Success'),
    ('PAY_5013', 'CUST_2004', 99.00,  '2025-03-01', 'Success'),
    ('PAY_5014', 'CUST_2004', 99.00,  '2025-04-01', 'Failed'),

    ('PAY_5015', 'CUST_2005', 29.00,  '2025-02-14', 'Success'),
    ('PAY_5016', 'CUST_2005', 29.00,  '2025-03-14', 'Success'),
    ('PAY_5017', 'CUST_2005', 29.00,  '2025-04-14', 'Success'),

    ('PAY_5018', 'CUST_2006', 299.00, '2025-02-25', 'Success'),
    ('PAY_5019', 'CUST_2006', 299.00, '2025-03-25', 'Success'),
    ('PAY_5020', 'CUST_2006', 299.00, '2025-04-25', 'Success'),

    ('PAY_5021', 'CUST_2007', 29.00,  '2025-03-01', 'Success'),

    ('PAY_5022', 'CUST_2008', 99.00,  '2025-03-15', 'Success'),
    ('PAY_5023', 'CUST_2008', 99.00,  '2025-04-15', 'Success'),

    ('PAY_5024', 'CUST_2009', 99.00,  '2025-03-22', 'Success'),
    ('PAY_5025', 'CUST_2009', 99.00,  '2025-04-22', 'Success'),
    ('PAY_5026', 'CUST_2009', 29.00,  '2025-05-22', 'Success'),

    ('PAY_5027', 'CUST_2010', 29.00,  '2025-04-02', 'Success'),
    ('PAY_5028', 'CUST_2011', 99.00,  '2025-04-10', 'Success'),
    ('PAY_5029', 'CUST_2012', 299.00, '2025-04-18', 'Success');


-- In-App Feature Usage Events

INSERT INTO fact_usage 
    (usage_id, customer_id, feature_name, usage_count, activity_date) 
VALUES
    ('USG_7001', 'CUST_2001', 'API Integration', 12500, '2025-01-20'),
    ('USG_7002', 'CUST_2001', 'API Integration', 48900, '2025-03-15'),

    ('USG_7003', 'CUST_2002', 'SSO Security', 420, '2025-01-25'),
    ('USG_7004', 'CUST_2002', 'Custom Query Engine', 3200, '2025-03-10'),

    ('USG_7005', 'CUST_2003', 'Analytics Dashboard', 75, '2025-01-25'),
    ('USG_7006', 'CUST_2003', 'Analytics Dashboard', 4, '2025-03-15'),

    ('USG_7007', 'CUST_2004', 'Data Ingestion', 8400, '2025-02-10'),
    ('USG_7008', 'CUST_2004', 'Data Ingestion', 150, '2025-03-20'),

    ('USG_7009', 'CUST_2005', 'Store Sync', 310, '2025-02-25'),

    ('USG_7010', 'CUST_2006', 'Audit Logs', 1450, '2025-03-10'),

    ('USG_7011', 'CUST_2007', 'Media Transcoder', 8, '2025-03-12'),

    ('USG_7012', 'CUST_2008', 'Fleet Tracking API', 21000, '2025-03-28'),

    ('USG_7013', 'CUST_2009', 'Threat Scan', 580, '2025-04-05'),
    ('USG_7014', 'CUST_2009', 'Threat Scan', 120, '2025-05-10'),

    ('USG_7015', 'CUST_2011', 'Fleet Tracking API', 18400, '2025-04-20'),

    ('USG_7016', 'CUST_2012', 'SSO Security', 890, '2025-04-25');


-- Customer Support Tickets

INSERT INTO fact_support 
    (ticket_id, customer_id, issue_type, resolution_time_hrs, satisfaction_score) 
VALUES
    ('TCK_9001', 'CUST_2001', 'API Documentation Help', 1.5, 5),
    ('TCK_9002', 'CUST_2002', 'SSO Configuration Support', 2.8, 5),
    ('TCK_9003', 'CUST_2003', 'Payment Gateway Glitch', 34.0, 1),
    ('TCK_9004', 'CUST_2003', 'Service Latency Bug', 48.5, 1),
    ('TCK_9005', 'CUST_2004', 'Database Connection Timeout', 28.0, 2),
    ('TCK_9006', 'CUST_2007', 'Plan Quota Reached', 18.0, 3),
    ('TCK_9007', 'CUST_2008', 'Webhook Delivery Issue', 3.0, 4),
    ('TCK_9008', 'CUST_2009', 'Downgrade Request Inquiry', 2.0, 4),
    ('TCK_9009', 'CUST_2011', 'New User Onboarding', 1.0, 5);

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count
FROM dim_customers

UNION ALL

SELECT 'dim_plans', COUNT(*)
FROM dim_plans

UNION ALL

SELECT 'fact_subscriptions', COUNT(*)
FROM fact_subscriptions

UNION ALL

SELECT 'fact_payments', COUNT(*)
FROM fact_payments

UNION ALL

SELECT 'fact_usage', COUNT(*)
FROM fact_usage

UNION ALL

SELECT 'fact_support', COUNT(*)
FROM fact_support;


-- phase3:

SELECT * 
FROM dim_customers;

SELECT country, 
count(*) as customer_count
FROM dim_customers 
GROUP BY country
ORDER BY customer_count DESC;

-- Explore plans

SELECT *
FROM dim_plans
ORDER BY monthly_fee;

SELECT 
plan_name,
billing_cycle,
monthly_fee
FROM dim_plans
ORDER BY monthly_fee DESC;


--Customer analysis
-- Question 1: Total customers

SELECT COUNT(*) AS total_customers
FROM dim_customers;

-- Question 2: Customers by segment

SELECT 
	segment,
	COUNT(*) AS customer_count
FROM dim_customers
GROUP BY segment
ORDER BY customer_count DESC;

-- Question 3: Customers by country

SELECT 
      country,
	  COUNT(*) AS customer_count
FROM dim_customers
GROUP BY country
ORDER BY customer_count DESC;

--Question 4: Customers by company size

SELECT 
      company_size,
	  COUNT(*) AS customer_count
FROM dim_customers
GROUP BY company_size
ORDER BY customer_count DESC;

--Subscription analysis

--Question 5: Current active subscriptions

SELECT * 
FROM fact_subscriptions 
WHERE status = 'Active';

--Question 6: Subscription status distribution

SELECT status, COUNT(*) AS subscription_count
FROM fact_subscriptions
GROUP BY status
ORDER BY subscription_count DESC;

-- JOIN customers with subscriptions

--Question : Customer subscription details

SELECT 
		d.customer_id,
		d.customer_name,
		d.country,
		d.segment,
		f.subscription_id,
		f.plan_id,
		f.start_date,
		f.end_date,
		f.status
FROM dim_customers d
INNER JOIN fact_subscriptions f
ON d.customer_id = f.customer_id;

-- PHASE 9 — Plan analysis

-- Question 7: Customers on each plan

SELECT 
  p.plan_name,
  COUNT(DISTINCT f.customer_id) AS customers
FROM fact_subscriptions f
INNER JOIN dim_plans p
   ON f.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY customers ;

-- Question 8: Active customers by plan

SELECT p.plan_name,
COUNT(DISTINCT f.customer_id) AS active_customers
FROM dim_plans p
INNER JOIN fact_subscriptions f
ON p.plan_id = f.plan_id
WHERE status = 'Active'
GROUP BY p.plan_name
ORDER BY active_customers;

-- PHASE 10 — Churn analysis

--Step 8: Find churned customers

SELECT 
		c.customer_id,
		c.customer_name,
		c.country,
		c.segment,
		s.start_date,
		s.end_date,
		s.status
FROM dim_customers c
INNER JOIN fact_subscriptions s
ON c.customer_id = s.customer_id
WHERE s.status = 'Cancelled';

-- Step 9: Calculate churned customers

SELECT 
COUNT(DISTINCT customer_id) AS churned_customer_count
FROM fact_subscriptions
WHERE status = 'Cancelled';

-- Step 10: Calculate customer churn rate


--PHASE 11 — MRR analysis
-- (Monthly Recurring Revenue)

-- Step 11: Calculate MRR per active customer

SELECT 
	c.customer_id,
	c.customer_name,
	p.plan_name,
	p.monthly_fee
FROM dim_customers c
INNER JOIN fact_subscriptions s
 ON c.customer_id = s.customer_id
INNER JOIN dim_plans p
 ON s.plan_id = p.plan_id
WHERE status = 'Active';

-- Step 12: Total MRR

SELECT 
	SUM(
		CASE(
				WHEN p.billing_cycle = 'Annual' 
					THEN p.monthly_fee / 12
				ELSE p.monthly_fee
				END 	
		) AS total_mrr
	)
FROM fact_subscriptions s
JOIN dim_plans p
    ON s.plan_id = p.plan_id
WHERE s.status = 'Active';

-- PHASE 12 — MRR by plan
-- Question: Which plans generate the most MRR?

SELECT 
p.plan_name,
COUNT(DISTINCT s.customer_id) AS active_customers,
SUM(
	CASE
			WHEN p.billing_cycle = 'Annual' 
			   THEN p.monthly_fee / 12
			ELSE p.monthly_fee
		END
	) AS mrr
	
FROM fact_subscriptions s
INNER JOIN dim_plans p
    ON s.plan_id = p.plan_id
WHERE s.status = 'Active'
GROUP BY p.plan_name
ORDER BY mrr DESC; 

--PHASE 13 — MRR by customer segment

SELECT 
c.segment,
COUNT(DISTINCT c.customer_id) AS active_customers,
SUM(
	CASE 
	   WHEN billing_cycle = 'Annual'
	   THEN monthly_fee / 12
	   ELSE monthly_fee
	   END
) AS mrr
FROM dim_customers c
INNER JOIN fact_subscriptions s
ON c.customer_id = s.customer_id
INNER JOIN dim_plans p
ON s.plan_id = p.plan_id
WHERE s.status = 'Active'
GROUP BY c.segment
ORDER BY mrr DESC;

-- PHASE 14 — Upgrade & downgrade analysis

--Who Upgraded?

SELECT 
	c.customer_name,
	p.plan_name,
	s.start_date,
	s.end_date,
	s.status
FROM fact_subscriptions s
INNER JOIN dim_customers c
	ON s.customer_id = c.customer_id
INNER JOIN dim_plans p
	ON s.plan_id = p.plan_id
WHERE status = 'Upgraded';

-- Question: Who downgraded?

SELECT 
	c.customer_name,
	p.plan_name,
	s.start_date,
	s.end_date,
	s.status
FROM fact_subscriptions s
INNER JOIN dim_customers c
	ON s.customer_id = c.customer_id
INNER JOIN dim_plans p
	ON s.plan_id = p.plan_id
WHERE status = 'Downgraded';

--PHASE 15 — Payment analysis

--Question: Total successful revenue

SELECT
SUM(amount) AS total_successful_revenue
FROM fact_payments
WHERE payment_status = 'Success';

--Question: Failed payments

SELECT 
COUNT(*) AS failed_payment_counts,
SUM(amount) AS failed_amount_value
FROM fact_payments
WHERE payment_status = 'Failed';

-- Question: Payment success rate

SELECT 
ROUND(
	100.0 * COUNT(*) FILTER(WHERE payment_status =  'Success')
	/ COUNT(*),2		
) AS Payment_success_rate
FROM fact_payments;

-- PHASE 16 — Failed payment customers

SELECT 
	c.customer_id,
    c.customer_name,
    COUNT(*) AS failed_payments,
    SUM(p.amount) AS failed_amount
FROM dim_customers c
INNER JOIN fact_payments p
ON c.customer_id = p.customer_id
WHERE payment_status = 'Failed'
GROUP BY 
	c.customer_id,
	c.customer_name
ORDER BY failed_payments;

--PHASE 17 — Product usage analysis

--Question: Most-used features

SELECT 
feature_name,
SUM(usage_count) AS Total_usage
FROM fact_usage
GROUP BY feature_name
ORDER BY Total_usage DESC;

-- Step 18: Usage by customer

SELECT 
	c.customer_id,
	c.customer_name,
	SUM(u.usage_count) AS total_usage
FROM dim_customers c
INNER JOIN fact_usage u
	ON c.customer_id = u.customer_id
GROUP BY 
	c.customer_id,
	c.customer_name
ORDER BY total_usage DESC;

-- PHASE 18 — Usage vs churn

SELECT 
CASE 
	WHEN s.status = 'Cancelled' THEN 'Churned_Customers'
	ELSE 'Still_Active,Upgraded,downgraded'
	END AS Customer_status,
	AVG(u.usage_count) AS average_usage
FROM fact_usage u
INNER JOIN fact_subscriptions s
ON u.customer_id = s.customer_id
GROUP BY
  CASE
     WHEN s.status = 'Cancelled' THEN 'Churned_Customers'
	ELSE 'Still_Active,Upgraded,downgraded'
	END;

--PHASE 19 — Support analysis

-- Question: Average resolution time

SELECT 
	ROUND(AVG(resolution_time_hrs),2) as avg_resolution_time
FROM fact_support;

-- Question: Average satisfaction

SELECT 
	ROUND(AVG(satisfaction_score),2) AS avg_satisfaction_score
FROM fact_support;

-- Step 20: Customers with poor satisfaction

SELECT
    c.customer_name,
    s.issue_type,
    s.resolution_time_hrs,
    s.satisfaction_score
FROM fact_support s
INNER JOIN dim_customers c
ON s.customer_id = c.customer_id
WHERE s.satisfaction_score <= 2
ORDER BY s.satisfaction_score;

-- PHASE 20 — Support vs churn

SELECT 
CASE 
	WHEN sb.status = 'Cancelled' THEN 'Churned_Customers'
	ELSE 'Still_Active'
	END AS Customer_status,
	ROUND(AVG(s.satisfaction_score),3) AS average_score
FROM fact_support s
INNER JOIN fact_subscriptions sb
ON s.customer_id = sb.customer_id
GROUP BY
  CASE
     WHEN sb.status = 'Cancelled' THEN 'Churned_Customers'
	ELSE 'Still_Active'
	END;

-- PHASE 21 — Advanced SQL

-- 1. Customer_usage using CTEs

WITH customer_usage AS (
SELECT 
		customer_id,
		ROUND(AVG(usage_count),2) AS total_usage
		FROM fact_usage
		GROUP BY customer_id
)
SELECT * 
FROM customer_usage
ORDER BY total_usage DESC;

-- 2. Window functions
-- rank customers by MRR

WITH customer_mrr AS(
SELECT 
	c.customer_id,
	c.customer_name,
	p.monthly_fee AS mrr
	FROM dim_customers c
	INNER JOIN fact_subscriptions s
	ON c.customer_id = s.customer_id
	INNER JOIN dim_plans p
	ON s.plan_id = p.plan_id
	WHERE s.status = 'Active'
)
SELECT *,
	RANK() OVER(ORDER BY mrr DESC)  AS mrr_rank
FROM customer_mrr;

-- 3. CASE statements
--classifying customers over mrr as high,medium,low 

WITH cte AS (
    SELECT
        p.monthly_fee AS mrr,
        c.customer_id,
        c.customer_name,
        p.plan_name
    FROM dim_customers c
    INNER JOIN fact_subscriptions s
        ON c.customer_id = s.customer_id
    INNER JOIN dim_plans p
        ON s.plan_id = p.plan_id
)

SELECT
    *,
    CASE 
        WHEN mrr >= 299 THEN 'High Value'
        WHEN mrr >= 99 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS classified_customer
FROM cte
ORDER BY mrr DESC;

--4. DATE functions
--Analyze subscription duration

SELECT
    customer_id,
    start_date,
    end_date,
    end_date - start_date AS subscription_days
FROM fact_subscriptions
WHERE end_date IS NOT NULL;


















