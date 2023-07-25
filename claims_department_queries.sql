-- calculating the total number of distinct claims, total cost
-- and total covered amount from the claims table for June 2023
select count(distinct claims.claim_id) as total_claims,
  round(sum(claims.claim_amount),2) as total_cost,
  round(sum(claims.covered_amount),2) as total_covered_amount
from `psychic-raceway-393323.rowhealth.claims` claims
where date_trunc(claims.claim_date, month) = '2023-06-01';

-- calculating total claims and monthly average for each product
-- grouped by month and product name for the year 2020
with monthly_claims as (
  select 
    claims.product_name as product_name,
    extract(month from claim_date) as month,
    count(claims.product_name) as monthly_total
  from `psychic-raceway-393323.rowhealth.claims` claims
  where extract(year from claims.claim_date) = 2020
  group by 
    1,2
),
monthly_average as (
  select 
    monthly_claims.product_name,
    round(avg(monthly_claims.monthly_total),2) as monthly_avg
  from monthly_claims
  group by 1
  order by 1
)
select date_trunc(claims.claim_date, month) as month,
  claims.product_name,
  count(distinct claims.claim_id) as total_claims,
  monthly_average.monthly_avg
from `psychic-raceway-393323.rowhealth.claims` claims
join monthly_average
  on claims.product_name = monthly_average.product_name
where extract(year from claims.claim_date) = 2020
group by 1, 2, 4
order by 1, 2;

-- fetching the top 2 products related to 'hair' with the highest claimed amount for June 2023.
select claims.product_name as product,
  round(sum(claim_amount),2) as total_claimed_amt
from `psychic-raceway-393323.rowhealth.claims` claims
where date_trunc(claims.claim_date, month) = '2023-06-01' and
  lower(claims.product_name) like '%hair%'
group by 1
order by 2 desc
limit 2;

-- retrieving the total number of claims made and total claimed amount by state for the year 2023
-- sorted by total claims and total claimed amount in descending order
select customers.state as state,
  count(distinct claims.claim_id) as total_claims_made,
  round(sum(claims.claim_amount),2) as total_claimed_amt
from `psychic-raceway-393323.rowhealth.claims` claims
join `psychic-raceway-393323.rowhealth.customers` customers 
  on claims.customer_id = customers.customer_id
where extract(year from claims.claim_date) = 2023
group by 1
order by 2 desc, 3 desc;

-- calculating the avg yearly claims and average total claimed amount by state
-- sorted by total claimed amount and total claims in descending order
with totals as (
  select customers.state as state,
    extract(year from claims.claim_date) as year,
    count(distinct claims.claim_id) as yearly_claims,
    round(sum(claims.claim_amount),2) as yearly_claimed_amt
  from `psychic-raceway-393323.rowhealth.claims` claims
  join `psychic-raceway-393323.rowhealth.customers` customers 
    on claims.customer_id = customers.customer_id
  group by 1, 2
)
select state,
  avg(yearly_claims) as avg_claims,
  round(avg(yearly_claimed_amt),2) as avg_total_claim_amt
from totals
group by 1
order by 3 desc, 2 desc;

-- this query groups Christmas 2022 orders into categories 'Hair', 'Biotin', and 'Vitamin B'
-- it then sorts them by the covered amount in descending order
with christmas_2022 as (
  select 
    case 
      when lower(claims.product_name) like '%hair%' then 'Hair'
      when lower(claims.product_name) like '%biotin%' then 'Biotin'
      when lower(claims.product_name) like '%vitamin b%' then 'Vitamin B'
    end as category,
    round(sum(claims.covered_amount),2) as covered_amt,
    count(claims.claim_id) as total_orders
  from `psychic-raceway-393323.rowhealth.claims` claims 
  where date_trunc(claims.claim_date, day) = '2022-12-25'
  group by 1
)
select *
from christmas_2022
where category in ('Hair', 'Biotin', 'Vitamin B')
order by 2 desc;

-- counting the total unique customers who either signed up in 2022
-- or signed up in 2023 with a 'platinum' plan
select count(distinct customers.customer_id) as total
from `psychic-raceway-393323.rowhealth.customers` customers 
where (customers.plan = 'platinum' and extract(year from customers.signup_date) = 2023)
  or extract(year from customers.signup_date) = 2022;

-- counting total unique customers who signed up in the year 2022
select count(distinct customers.customer_id) as total
from `psychic-raceway-393323.rowhealth.customers` customers 
where extract(year from customers.signup_date) = 2022;

-- retrieving the top 10 customers (by ID and full name) with the most distinct claims.
select customers.customer_id, 
  concat(customers.first_name, ' ', customers.last_name) as full_name,
  count(distinct claims.claim_id) as total_claims
from `psychic-raceway-393323.rowhealth.customers` customers 
join `psychic-raceway-393323.rowhealth.claims` claims 
  on customers.customer_id = claims.customer_id
group by 1, 2
order by 3 desc
limit 10;

-- calculating the total claim amount for the top 10 customers who have made the most distinct claims
with customer_list as (
  select customers.customer_id,
    count(distinct claims.claim_id) as total_claims
  from `psychic-raceway-393323.rowhealth.customers` customers 
  join `psychic-raceway-393323.rowhealth.claims` claims 
    on customers.customer_id = claims.customer_id
  group by 1
  order by 2 desc
  limit 10  
)
select round(sum(claims.claim_amount),2) as total_claim_amt
from `psychic-raceway-393323.rowhealth.claims` claims 
join customer_list
  on claims.customer_id = customer_list.customer_id;

-- calculating the total covered claim amount for the top 10 customers 
-- who have made the most distinct claims
with customer_list as (
  select customers.customer_id,
    count(distinct claims.claim_id) as total_claims
  from `psychic-raceway-393323.rowhealth.customers` customers 
  join `psychic-raceway-393323.rowhealth.claims` claims 
    on customers.customer_id = claims.customer_id
  group by 1
  order by 2 desc
  limit 10  
)
select round(sum(claims.covered_amount),2) as total_covered_amt
from `psychic-raceway-393323.rowhealth.claims` claims 
join customer_list
  on claims.customer_id = customer_list.customer_id;

-- calculating the average reimbursement percentage for claims on 'hair' products from New York customers 
-- or any 'supplement' products, excluding claims with a claim amount of zero
select round(avg((claims.covered_amount)/nullif(claims.claim_amount, 0))*100,2) as avg_reimbursement
from `psychic-raceway-393323.rowhealth.claims` claims 
join `psychic-raceway-393323.rowhealth.customers` customers
  on claims.customer_id = customers.customer_id
where ((lower(claims.product_name) like '%hair%' and customers.state = 'NY')
  or (lower(claims.product_name) like '%supplement%'))
  and claims.claim_amount != 0;

-- calculating the average number of days between claims for customers who have made more than one claim
-- cte to filter customers with more than one claim
with more_than_one as (
  select claims.customer_id
  from `psychic-raceway-393323.rowhealth.claims` claims
  group by 1
  having count(distinct claims.claim_id) > 1
),
-- cte to calculate the date of the previous claim for each claim
previous_claim as (
  select    
    claims.customer_id, 
    claims.claim_date,
    lag(claims.claim_date) over (partition by claims.customer_id order by claim_date) as previous_claim_date
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  WHERE claims.customer_id IN (SELECT customer_id FROM more_than_one) -- use the more_than_one cte here
), 
-- cte to calculate the avg number of days between claims for each customer
avg_days_per_customer as (
  select
    previous_claim.customer_id,
    avg(date_diff(previous_claim.claim_date, previous_claim.previous_claim_date, day)) as avg_days_between
  from previous_claim
  where previous_claim.previous_claim_date is not null
  group by 1
)
-- main query calculates the average of the averages calculated in the average_days_per_customer cte
select round(avg(avg_days_between)) as avg_days_between
from avg_days_per_customer;

-- identifying the most commonly ordered second product for customers who have made more than one claim
-- cte to filter customers with more than one claim
with more_than_one_order as (
  select claims.customer_id,
    count(product_name) as total_products
  from `psychic-raceway-393323.rowhealth.claims` claims
  group by 1
  having total_products > 1
),
-- cte to rank the orders for each customer
purchase_rank as (
  select claims.customer_id,
    claims.claim_id, 
    claims.claim_date,
    claims.product_name,
    rank() over (partition by claims.customer_id order by claim_date) as order_rank
  FROM `psychic-raceway-393323.rowhealth.claims` claims
  join more_than_one_order
    on claims.customer_id = more_than_one_order.customer_id
)
-- main query to get the most common second order
select purchase_rank.product_name,
  count(purchase_rank.product_name) as total
from purchase_rank
where order_rank = 2
group by 1
order by 2 desc;
