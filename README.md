# SaaS Customer Churn & MRR Analytics

## Project Overview

This project analyzes customer subscriptions, churn, Monthly Recurring Revenue (MRR), payments, product usage, and customer support performance for a SaaS business.

The project was built using PostgreSQL and follows an end-to-end SQL analytics workflow, from database schema creation and data insertion to business-focused analysis and advanced SQL techniques.

## Business Objectives

The analysis focuses on answering key SaaS business questions:

- How many customers does the business have?
- How are customers distributed across segments and countries?
- Which subscription plans have the most customers?
- What is the customer churn rate?
- What is the total Monthly Recurring Revenue (MRR)?
- Which plans and customer segments generate the most MRR?
- Which customers upgraded or downgraded?
- What is the payment success rate?
- Which customers have failed payments?
- Which product features are used most frequently?
- Is product usage different between churned and active customers?
- What is the average customer support satisfaction?
- Is customer support satisfaction related to churn?
- Which customers generate the highest MRR?

## Database Schema

The project uses a relational database with six tables:

### Dimension Tables

- `dim_customers` — Customer information
- `dim_plans` — SaaS subscription plan information

### Fact Tables

- `fact_subscriptions` — Subscription lifecycle and status
- `fact_payments` — Customer payment transactions
- `fact_usage` — Product feature usage
- `fact_support` — Customer support tickets and satisfaction

The tables are connected using primary keys and foreign keys.

## Data

The SQL script contains the database schema and seed data directly, so the project has no external CSV dependencies.

The dataset includes information about:

- Customers
- Countries
- Customer segments
- Company sizes
- Subscription plans
- Billing cycles
- Subscription status
- Payments
- Product feature usage
- Support tickets
- Customer satisfaction
- Subscription dates

## SQL Techniques Used

### Basic SQL

- `SELECT`
- `WHERE`
- `ORDER BY`
- `GROUP BY`
- `COUNT`
- `SUM`
- `AVG`
- `ROUND`

### Joins

- `INNER JOIN`
- Joining customers with subscriptions
- Joining subscriptions with plans
- Joining customers with payments, usage, and support data

### Advanced SQL

- Common Table Expressions (CTEs)
- Window Functions
- `RANK()`
- `CASE` statements
- Date calculations
- Conditional aggregation
- `FILTER`
- Subqueries
- Foreign Keys
- Constraints

## Analysis Performed

### 1. Customer Analysis

Analyzed:

- Total customers
- Customers by segment
- Customers by country
- Customers by company size

### 2. Subscription Analysis

Analyzed:

- Active subscriptions
- Subscription status distribution
- Customer subscription details
- Customers by subscription plan
- Active customers by plan

### 3. Churn Analysis

Identified churned customers and calculated customer churn rate using a defined starting-customer cohort and churn period.

### 4. MRR Analysis

Calculated:

- MRR per active customer
- Total MRR
- MRR by subscription plan
- MRR by customer segment

Annual plans were normalized to a monthly value when calculating MRR.

### 5. Upgrade & Downgrade Analysis

Identified customers who:

- Upgraded their subscription
- Downgraded their subscription

### 6. Payment Analysis

Analyzed:

- Successful payment revenue
- Failed payment count
- Failed payment value
- Payment success rate
- Customers with failed payments

### 7. Product Usage Analysis

Analyzed:

- Most-used product features
- Usage by customer
- Average usage of churned vs non-churned customers

### 8. Customer Support Analysis

Analyzed:

- Average support resolution time
- Average satisfaction score
- Customers with poor satisfaction scores
- Support satisfaction for churned vs active customers

## Advanced SQL Analysis

The project includes advanced SQL queries using:

### CTE

Used CTEs to structure customer usage and churn calculations.

### Window Functions

Used `RANK()` to rank customers based on MRR.

### CASE Statements

Classified customers into:

- High Value
- Medium Value
- Low Value

based on MRR.

### Date Analysis

Calculated subscription duration using subscription start and end dates.

## Key Business Metrics

The analysis produced metrics including:

- Monthly Recurring Revenue (MRR)
- Customer churn rate
- Payment success rate
- Failed payment value
- Product usage
- Average support satisfaction
- Average support resolution time

## Business Recommendations

Based on the analysis, the business can:

- Focus retention efforts on customers showing signs of churn.
- Monitor customer usage to identify low-engagement accounts.
- Investigate failed payments that may contribute to customer loss.
- Improve support experiences for customers with low satisfaction scores.
- Identify high-value customers based on MRR and prioritize retention strategies.
- Evaluate subscription plans and customer segments based on their contribution to MRR.
- Monitor upgrades and downgrades to understand changes in customer value.

## Project Structure

```text
SaaS-Customer-Churn-and-MRR-Analytics/
│
├── README.md
└── SaaS Customer Churn and MRR Analytics.sql
