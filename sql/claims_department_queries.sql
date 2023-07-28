-- calculating the total number of distinct claims, total cost
-- and total covered amount from the claims table for June 2023
SELECT COUNT(DISTINCT claims.claim_id) AS total_claims,
  ROUND(SUM(claims.claim_amount),2) AS total_cost,
  ROUND(SUM(claims.covered_amount),2) AS total_covered_amount
FROM `psychic-raceway-393323.rowhealth.claims` claims
WHERE DATE_TRUNC(claims.claim_date, MONTH) = '2023-06-01';

-- calculating total claims and monthly average for each product
-- grouped by month and product name for the year 2020
WITH monthly_claims AS (
  SELECT claims.product_name AS product_name,
    EXTRACT(MONTH FROM claim_date) AS month,
    COUNT(claims.product_name) AS monthly_total
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  WHERE EXTRACT(YEAR FROM claims.claim_date) = 2020
  GROUP BY 
    1,2
),
monthly_average AS (
  SELECT monthly_claims.product_name,
    ROUND(AVG(monthly_claims.monthly_total),2) AS monthly_avg
  FROM monthly_claims
  GROUP BY 1
  ORDER BY 1
)
SELECT DATE_TRUNC(claims.claim_date, MONTH) AS month,
  claims.product_name,
  COUNT(DISTINCT claims.claim_id) AS total_claims,
  monthly_average.monthly_avg
FROM `psychic-raceway-393323.rowhealth.claims` claims
JOIN monthly_average
  ON claims.product_name = monthly_average.product_name
WHERE EXTRACT(YEAR FROM claims.claim_date) = 2020
GROUP BY 1, 2, 4
ORDER BY 1, 2;

-- fetching the top 2 products related to 'hair' with the highest claimed amount for June 2023.
SELECT claims.product_name AS product,
  ROUND(SUM(claim_amount),2) AS total_claimed_amt
FROM `psychic-raceway-393323.rowhealth.claims` claims
WHERE DATE_TRUNC(claims.claim_date, MONTH) = '2023-06-01' AND
  LOWER(claims.product_name) LIKE '%hair%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;

-- retrieving the total number of claims made and total claimed amount by state for the year 2023
-- Sorted by total claims and total claimed amount in descending order
SELECT customers.state AS state,
  COUNT(DISTINCT claims.claim_id) AS total_claims_made,
  ROUND(SUM(claims.claim_amount),2) AS total_claimed_amt
FROM `psychic-raceway-393323.rowhealth.claims` claims
JOIN `psychic-raceway-393323.rowhealth.customers` customers 
  ON claims.customer_id = customers.customer_id
WHERE EXTRACT(YEAR FROM claims.claim_date) = 2023
GROUP BY 1
ORDER BY 2 DESC, 3 DESC;

-- calculating the avg yearly claims and average total claimed amount by state
-- Sorted by total claimed amount and total claims in descending order
WITH totals AS (
  SELECT customers.state AS state,
    EXTRACT(YEAR FROM claims.claim_date) AS year,
    COUNT(DISTINCT claims.claim_id) AS yearly_claims,
    ROUND(SUM(claims.claim_amount),2) AS yearly_claimed_amt
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  JOIN `psychic-raceway-393323.rowhealth.customers` customers 
    ON claims.customer_id = customers.customer_id
  GROUP BY 1, 2
)
SELECT state,
  AVG(yearly_claims) AS avg_claims,
  ROUND(AVG(yearly_claimed_amt),2) AS avg_total_claim_amt
FROM totals
GROUP BY 1
ORDER BY 3 DESC, 2 DESC;

-- grouping Christmas 2022 orders into categories 'Hair', 'Biotin', and 'Vitamin B'
-- It then sorts them by the covered amount in descending order
WITH christmas_2022 AS (
  SELECT 
    CASE 
      WHEN LOWER(claims.product_name) LIKE '%hair%' THEN 'Hair'
      WHEN LOWER(claims.product_name) LIKE '%biotin%' THEN 'Biotin'
      WHEN LOWER(claims.product_name) LIKE '%vitamin b%' THEN 'Vitamin B'
    END AS category,
    ROUND(SUM(claims.covered_amount),2) AS covered_amt,
    COUNT(claims.claim_id) AS total_orders
  FROM `psychic-raceway-393323.rowhealth.claims` claims 
  WHERE DATE_TRUNC(claims.claim_date, DAY) = '2022-12-25'
  GROUP BY 1
)
SELECT *
FROM christmas_2022
WHERE category IN ('Hair', 'Biotin', 'Vitamin B')
ORDER BY 2 DESC;

-- counting the total unique customers who either signed up in 2022
-- or signed up in 2023 with a 'platinum' plan
SELECT COUNT(DISTINCT customers.customer_id) AS total
FROM `psychic-raceway-393323.rowhealth.customers` customers 
WHERE (customers.plan = 'platinum' AND EXTRACT(YEAR FROM customers.signup_date) = 2023)
  OR EXTRACT(YEAR FROM customers.signup_date) = 2022;

-- counting total unique customers who signed up in the year 2022
SELECT COUNT(DISTINCT customers.customer_id) AS total
FROM `psychic-raceway-393323.rowhealth.customers` customers 
WHERE EXTRACT(YEAR FROM customers.signup_date) = 2022;

-- retrieving the top 10 customers (by ID and full name) with the most distinct claims.
SELECT customers.customer_id, 
  CONCAT(customers.first_name, ' ', customers.last_name) AS full_name,
  COUNT(DISTINCT claims.claim_id) AS total_claims
FROM `psychic-raceway-393323.rowhealth.customers` customers 
JOIN `psychic-raceway-393323.rowhealth.claims` claims 
  ON customers.customer_id = claims.customer_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;

-- calculating the total claim amount for the top 10 customers who have made the most distinct claims
WITH customer_list AS (
  SELECT customers.customer_id,
    COUNT(DISTINCT claims.claim_id) AS total_claims
  FROM `psychic-raceway-393323.rowhealth.customers` customers 
  JOIN `psychic-raceway-393323.rowhealth.claims` claims 
    ON customers.customer_id = claims.customer_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10  
)
SELECT ROUND(SUM(claims.claim_amount),2) AS total_claim_amt
FROM `psychic-raceway-393323.rowhealth.claims` claims 
JOIN customer_list
  ON claims.customer_id = customer_list.customer_id;

-- calculating the total covered claim amount for the top 10 customers 
-- who have made the most distinct claims
WITH customer_list AS (
  SELECT customers.customer_id,
    COUNT(DISTINCT claims.claim_id) AS total_claims
  FROM `psychic-raceway-393323.rowhealth.customers` customers 
  JOIN `psychic-raceway-393323.rowhealth.claims` claims 
    ON customers.customer_id = claims.customer_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10  
)
SELECT ROUND(SUM(claims.covered_amount),2) AS total_covered_amt
FROM `psychic-raceway-393323.rowhealth.claims` claims 
JOIN customer_list
  ON claims.customer_id = customer_list.customer_id;

-- calculating the average reimbursement percentage for claims on 'hair' products from New York customers 
-- or any 'supplement' products, excluding claims with a claim amount of zero
SELECT ROUND(AVG((claims.covered_amount)/NULLIF(claims.claim_amount, 0))*100,2) AS avg_reimbursement
FROM `psychic-raceway-393323.rowhealth.claims` claims 
JOIN `psychic-raceway-393323.rowhealth.customers` customers
  ON claims.customer_id = customers.customer_id
WHERE ((LOWER(claims.product_name) LIKE '%hair%' AND customers.state = 'NY')
  OR (LOWER(claims.product_name) LIKE '%supplement%'))
  AND claims.claim_amount != 0;

-- calculating the average number of days between claims for customers who have made more than one claim
-- cte to filter customers with more than one claim
WITH more_than_one AS (
  SELECT claims.customer_id
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  GROUP BY 1
  HAVING COUNT(DISTINCT claims.claim_id) > 1
),
-- cte to calculate the date of the previous claim for each claim
previous_claim AS (
  SELECT claims.customer_id, 
    claims.claim_date,
    LAG(claims.claim_date) OVER (PARTITION BY claims.customer_id ORDER BY claim_date) AS previous_claim_date
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  WHERE claims.customer_id IN (SELECT customer_id FROM more_than_one) -- Use the more_than_one cte here
), 
-- cte to calculate the avg number of days between claims for each customer
avg_days_per_customer AS (
  SELECT previous_claim.customer_id,
    AVG(DATE_DIFF(previous_claim.claim_date, previous_claim.previous_claim_date, DAY)) AS avg_days_between
  FROM previous_claim
  WHERE previous_claim.previous_claim_date IS NOT NULL
  GROUP BY 1
)
-- main query calculates the average of the averages calculated in the average_days_per_customer cte
SELECT ROUND(AVG(avg_days_between)) AS avg_days_between
FROM avg_days_per_customer;

-- identifying the most commonly ordered second product for customers who have made more than one claim
-- cte to filter customers with more than one claim
WITH more_than_one_order AS (
  SELECT claims.customer_id,
    COUNT(product_name) AS total_products
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  GROUP BY 1
  HAVING total_products > 1
),
--  to rank the orders for each customer
purchase_rank AS (
  SELECT claims.customer_id,
    claims.claim_id, 
    claims.claim_date,
    claims.product_name,
    ROW_NUMBER() OVER (PARTITION BY claims.customer_id ORDER BY claim_date) AS order_rank
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  JOIN more_than_one_order
    ON claims.customer_id = more_than_one_order.customer_id
)
-- main query to get the most common second order
SELECT purchase_rank.product_name,
  COUNT(purchase_rank.product_name) AS total
FROM purchase_rank
WHERE order_rank = 2
GROUP BY 1
ORDER BY 2 DESC;
