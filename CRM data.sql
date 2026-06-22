CREATE DATABASE CRM_system;

USE crm_system;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    industry VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50),
    annual_revenue DECIMAL(15,2),
    created_date DATE
);


CREATE TABLE leads (
    lead_id INT PRIMARY KEY,
    lead_name VARCHAR(100),
    lead_source VARCHAR(50),
    status VARCHAR(50),
    created_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE contacts (
    contact_id INT PRIMARY KEY,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    designation VARCHAR(50),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE opportunities (
    opportunity_id INT PRIMARY KEY,
    opportunity_name VARCHAR(100),
    stage VARCHAR(50),
    deal_value DECIMAL(15,2),
    probability INT,
    expected_close_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE activities (
    activity_id INT PRIMARY KEY,
    activity_type VARCHAR(50),
    activity_date DATE,
    lead_id INT,
    notes VARCHAR(255),
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id)
);


SHOW TABLES;
DESC activities;


SELECT COUNT(*) FROM activities;


SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_leads
FROM leads;

SELECT COUNT(*) AS total_contacts
FROM contacts;

SELECT COUNT(*) AS total_opportunities
FROM opportunities;

SELECT COUNT(*) AS total_activities
FROM activities;


SELECT industry,
       COUNT(*) AS customer_count
FROM customers
GROUP BY industry
ORDER BY customer_count DESC;


SELECT industry,
       SUM(annual_revenue) AS total_revenue
FROM customers
GROUP BY industry
ORDER BY total_revenue DESC;

SELECT customer_name,
       annual_revenue
FROM customers
ORDER BY annual_revenue DESC
LIMIT 10;

SELECT lead_source,
       COUNT(*) AS total_leads
FROM leads
GROUP BY lead_source
ORDER BY total_leads DESC;

SELECT status,
       COUNT(*) AS lead_count
FROM leads
GROUP BY status;




SELECT ROUND(
(SUM(CASE WHEN status='Qualified' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
2
) AS lead_conversion_rate
FROM leads;


SELECT stage,
       COUNT(*) AS total_opportunities
FROM opportunities
GROUP BY stage;

SELECT SUM(deal_value) AS total_pipeline_value
FROM opportunities;

SELECT SUM(deal_value) AS won_revenue
FROM opportunities
WHERE stage='Won';


SELECT ROUND(
(SUM(CASE WHEN stage='Won' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
2
) AS win_rate
FROM opportunities;

SELECT c.industry,
       SUM(o.deal_value) AS pipeline_value
FROM customers c
JOIN opportunities o
ON c.customer_id = o.customer_id
GROUP BY c.industry
ORDER BY pipeline_value DESC;


SELECT lead_source,
       COUNT(*) AS qualified_leads
FROM leads
WHERE status='Qualified'
GROUP BY lead_source
ORDER BY qualified_leads DESC;

SELECT activity_type,
       COUNT(*) AS total_activities
FROM activities
GROUP BY activity_type;

SELECT c.customer_name,
       SUM(o.deal_value) AS pipeline_value
FROM customers c
JOIN opportunities o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY pipeline_value DESC
LIMIT 10;	


SELECT lead_source,
       COUNT(*) AS total_leads,
       SUM(CASE WHEN status='Qualified' THEN 1 ELSE 0 END) AS qualified_leads
FROM leads
GROUP BY lead_source;

SELECT stage,
       ROUND(AVG(deal_value),2) AS avg_deal_size
FROM opportunities
GROUP BY stage;


SELECT c.industry,
       SUM(o.deal_value) AS won_revenue
FROM customers c
JOIN opportunities o
ON c.customer_id = o.customer_id
WHERE o.stage='Won'
GROUP BY c.industry
ORDER BY won_revenue DESC;

SELECT lead_id,
       COUNT(*) AS total_activities
FROM activities
GROUP BY lead_id
ORDER BY total_activities DESC
LIMIT 10;


SELECT MONTH(expected_close_date) AS month,
       SUM(deal_value) AS pipeline_value
FROM opportunities
GROUP BY MONTH(expected_close_date)
ORDER BY month;