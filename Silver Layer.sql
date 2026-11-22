DROP TABLE IF EXISTS Silver.Customers;

SELECT 
    customer_id,
    cc_num,
    ISNULL(LTRIM(RTRIM(first_name)), '') AS first_name,
    ISNULL(LTRIM(RTRIM(last_name)), '') AS last_name,
    ISNULL(LTRIM(RTRIM(gender)), '') AS gender,
    ISNULL(LTRIM(RTRIM(street)), '') AS street,
    ISNULL(LTRIM(RTRIM(city)), '') AS city,
    ISNULL(LTRIM(RTRIM(state)), '') AS state,
    TRY_CAST(zip AS INT) AS zip,
    TRY_CAST([lat] AS DECIMAL(9,4)) AS latitude,
    TRY_CAST([long] AS DECIMAL(9,4)) AS longitude,
    TRY_CAST(city_pop AS INT) AS city_pop,
    ISNULL(LTRIM(RTRIM(job)), 'Unknown') AS job,
    TRY_CAST(dob AS DATE) AS date_of_birth,
    ISNULL(loyalty_tier, 'Regular') AS loyalty_tier,
    ISNULL(email_domain, '') AS email_domain,
    TRY_CAST(signup_date AS DATE) AS signup_date
INTO Silver.Customers
FROM Bronze.[Customers (3)];


select * 
from Bronze.[Customers (3)]


alter table Silver.Customers alter column customer_id int not null;

alter table Silver.Customers add constraint PK_Silver_customer primary key (customer_id);


---- ======== Merchants ======= ----

DROP TABLE IF EXISTS Silver.Merchants;

SELECT 
    TRY_CAST(merchant_id AS INT) AS merchant_id,
    ISNULL(LTRIM(RTRIM(merchant_name)), 'Unknown') AS merchant_name,
    ISNULL(LTRIM(RTRIM(dominant_category)), 'Unknown') AS dominant_category,
    ISNULL(LTRIM(RTRIM(merchant_city)), '') AS merchant_city,
    ISNULL(LTRIM(RTRIM(merchant_state)), '') AS merchant_state,
    TRY_CAST(merchant_lat AS DECIMAL(9,4)) AS merchant_latitude,
    TRY_CAST(merchant_long AS DECIMAL(9,4)) AS merchant_longitude,
    TRY_CAST(merchant_since AS DATE) AS merchant_since,
    is_active
INTO Silver.Merchants
FROM Bronze.Merchants;


alter table Silver.Merchants alter column merchant_id int not null;


alter table Silver.Merchants add constraint PK_Silver_merchant primary key (merchant_id);


---- ======== Transactions ======= ----

DROP TABLE IF EXISTS Silver.Transactions;

SELECT 
    TRY_CAST(transaction_id AS INT) AS transaction_id,
    TRY_CAST(trans_date_trans_time AS DATETIME) AS trans_date_trans_time,
    TRY_CAST(customer_id AS INT) AS customer_id,
    TRY_CAST(merchant_id AS INT) AS merchant_id,
    ISNULL(LTRIM(RTRIM(category)), 'Unknown') AS category,
    ROUND(TRY_CAST(amt AS FLOAT), 2) AS amt,
    ROUND(TRY_CAST(tax_amt AS FLOAT), 2) AS tax_amt,
    ROUND(TRY_CAST(discount_amt AS FLOAT), 2) AS discount_amt,
    ISNULL(LTRIM(RTRIM(currency)), 'USD') AS currency,
    ISNULL(LTRIM(RTRIM(payment_method)), 'Unknown') AS payment_method,
    ISNULL(LTRIM(RTRIM(channel)), 'Unknown') AS channel,
    ISNULL(LTRIM(RTRIM(entry_mode)), 'Unknown') AS entry_mode,
    ISNULL(LTRIM(RTRIM(device_type)), 'Unknown') AS device_type,
    ISNULL(LTRIM(RTRIM(transaction_status)), 'Unknown') AS transaction_status,
    ISNULL(LTRIM(RTRIM(trans_num)), '') AS trans_num,
    ISNULL(LTRIM(RTRIM(session_id)), '') AS session_id,
    TRY_CAST(unix_time AS INT) AS unix_time,
    is_fraud
INTO Silver.Transactions
FROM Bronze.Transactions;


alter table Silver.Transactions alter column transaction_id int not null;

alter table Silver.Transactions add constraint PK_Silver_Transactions primary key (transaction_id);

--------------------------------------------------------------------------------------------------------

USE [Commerce];
GO

UPDATE T
SET T.category = M.dominant_category
FROM Silver.Transactions T
INNER JOIN Silver.Merchants M
    ON T.merchant_id = M.merchant_id;


SELECT merchant_id, COUNT(DISTINCT category) AS total_categories
FROM Silver.Transactions
GROUP BY merchant_id
HAVING COUNT(DISTINCT category) > 1;





