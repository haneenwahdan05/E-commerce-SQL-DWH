

use [Commerce];
GO

-- ============ Customers ============ --

-- ============ Nulls ============ --

SELECT 
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS blank_id,
    SUM(CASE WHEN cc_num IS NULL OR cc_num = '' Then 1 else 0 end) as blank_ccNum,
    SUM(CASE WHEN first_name is null or first_name = '' then 1 else 0 end) as blank_fname,
    SUM(CASE WHEN last_name is null or last_name = '' then 1 else 0 end) as blank_lname,
    SUM(CASE WHEN gender is null or gender = '' then 1 else 0 end) as blank_gender,
    SUM(CASE WHEN street is null or street = '' then 1 else 0 end) as blank_st,
    SUM(CASE WHEN city is null or city = '' then 1 else 0 end) as blank_city,
    SUM(CASE WHEN state is null or state = '' then 1 else 0 end) as blank_state,
    SUM(CASE WHEN job is null or job = '' then 1 else 0 end) as blank_job,
    SUM(CASE WHEN dob is null or dob = '' then 1 else 0 end) as blank_dob,
    SUM(CASE WHEN loyalty_tier is null or loyalty_tier = '' then 1 else 0 end) as blank_loyalty
FROM Bronze.[Customers (3)];


-- ============ Inconsistent Category Values ============ --

select distinct
    gender,
    count(*) as CNT
from Bronze.[Customers (3)]
group by (gender);


-- ============ Duplicates IDs ============ --

select
    customer_id, 
    count(*) as CNT
from Bronze.[Customers (3)]
group by(customer_id)
having count(*) > 1;


-- ============ Total Rows Counts ============ --

select count(*) as total_rows
from Bronze.[Customers (3)]


select *
from Bronze.[Customers (3)]
-- ============ Merchants ============ --

-- ============ Nulls ============ --

SELECT 
    sum(case when merchant_id is null or merchant_id = '' then 1 else 0 end) as blank_mID,
    sum(case when merchant_name is null or merchant_name = '' then 1 else 0 end) as blank_mName,
    sum(case when dominant_category is null or dominant_category = '' then 1 else 0 end) as blank_dCateg,
    sum(case when merchant_city is null or merchant_city = '' then 1 else 0 end) as blank_mCity,
    sum(case when  merchant_state is null or merchant_state = '' then 1 else 0 end) as blank_mState,
    sum(case when is_active is null or is_active = '' then 1 else 0 end ) as blank_isActive
from Bronze.Merchants



select is_active , count(*) as total
from Bronze.Merchants
group by is_active 
order by total desc;


UPDATE Bronze.Merchants
SET is_active = 1
WHERE is_active IS NULL OR is_active = '';


update Bronze.Merchants
set merchant_city = 'Unknown'
where merchant_city is null or merchant_city = '';


SELECT COUNT(*) AS orphan_transactions
FROM Bronze.Transactions t
LEFT JOIN Bronze.[Customers (3)] c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- ============ Inconsistent categorical values ============ --

select * 
from Bronze.Merchants


select distinct 
    [merchant_name],
    count (*) as CNT
from Bronze.Merchants
group by [merchant_name];



select distinct 
    [dominant_category],
    count (*) as CNT
from Bronze.Merchants
group by [dominant_category];



select distinct 
    [merchant_city],
    count (*) as CNT
from Bronze.Merchants
group by [merchant_city];


select distinct 
    [merchant_state],
    count (*) as CNT
from Bronze.Merchants
group by [merchant_state];

-- ============ Nulls in Transactions ============ --

select *
from Bronze.Transactions


select
    sum(case when session_id is null or session_id = '' then 1 else 0 end) as blank_sessionID,
    sum(case when transaction_id is null or transaction_id = '' then 1 else 0 end) as blank_tID,
    sum(case when customer_id is null or customer_id = '' then 1 else 0 end ) as blank_CustId,
    sum(case when currency is null or currency = '' then 1 else 0 end) as blank_currency,
    sum(case when transaction_status is null or  transaction_status = '' then 1 else 0 end) as blank_transStatus
from Bronze.Transactions


SELECT 
    customer_id,
    merchant_id,
    amt,
    COALESCE(session_id, 'Unknown_Session') AS session_id
FROM Bronze.Transactions;


-- ============ Inconsistent categorical values ============ --
select distinct 
    [category],
    count (*) as CNT
from Bronze.Transactions
group by [category];


-- ============ Duplicates ============ --

select 
    merchant_id,
    count(*) as CNT 
from Bronze.Merchants
group by merchant_id
having count(*) > 1
    


SELECT 
    transaction_id,
    customer_id,
    merchant_id,
    COUNT(*) AS CNT 
FROM Bronze.Transactions
GROUP BY transaction_id, customer_id, merchant_id
HAVING COUNT(*) > 1;


-- ============ Distinct Error Types ============ --


SELECT 
    transaction_status,
    channel,
    COUNT(*) AS CNT
FROM Bronze.Transactions
WHERE transaction_status <> 'approved' 
GROUP BY transaction_status, channel
ORDER BY CNT DESC;


-- ============ Distinct entry mode values ============ --

select  
    [merchant_id],
    count(distinct category) as distinct_category_count
from Bronze.Transactions
group by [merchant_id]
having count(distinct category) >1
order by distinct_category_count desc;















































