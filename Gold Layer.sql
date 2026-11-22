---------------- GOLD TIER ----------------
--DIM Date

USE Commerce;
GO

CREATE TABLE Gold.DimDate (
    datekey int not null Primary Key, 
    full_date Date not null,
    [year] int not null,
    [quarter] int not null,
    [month] int not null,
    month_name varchar(20) not null,
    [day] int not null,
    day_name varchar(20) not null,
    is_weekend bit not null
);
GO

DECLARE @start_date DATE, @end_date DATE, @current_date DATE;

SELECT 
  @start_date = MIN([trans_date_trans_time]),
  @end_date = MAX([trans_date_trans_time]) 
FROM Silver.Transactions;

SET @current_date = @start_date;

SELECT @start_date, @end_date, @current_date;

WHILE @current_date <= @end_date
BEGIN 
    INSERT INTO Gold.DimDate(
        datekey, 
        full_date,
        [year],
        [quarter],
        [month],
        month_name,
        [day],
        day_name,
        is_weekend
    ) 
    VALUES(
        CAST(FORMAT(@current_date, 'yyyyMMdd') AS INT), 
        @current_date, 
        YEAR(@current_date), 
        DATEPART(QUARTER, @current_date),
        MONTH(@current_date),
        DATENAME(MONTH, @current_date),
        DAY(@current_date),
        DATENAME(WEEKDAY, @current_date),
        CASE 
            WHEN DATEPART(WEEKDAY, @current_date) IN (1, 7) THEN 1 
            ELSE 0 
        END
    );

    SET @current_date = DATEADD(DAY, 1, @current_date);
END;
GO

select *
from Gold.DimDate

-----------------------------------------------------------------------------------------------------------------

------- DimCustomer -------
select * 
into gold.dimCustomer
from Silver.Customers;

alter table gold.dimCustomer alter column customer_id int not null;

alter table gold.dimCustomer add constraint PK_dimCustomer Primary Key (customer_id);

------- DimMerchants -------

select * 
into gold.dimMerchants
from Silver.Merchants;

alter table gold.dimMerchants alter column merchant_id int not null;

alter table gold.dimMerchants add constraint PK_dimMerchants Primary Key (merchant_id);

------- Fact Table -------


DROP TABLE IF EXISTS gold.dimTransactions;
DROP TABLE IF EXISTS Gold.FactTransactions;
GO

SELECT 
    [transaction_id],
    CAST(FORMAT([trans_date_trans_time], 'yyyyMMdd') AS INT) AS datekey,
    [trans_date_trans_time],
    [customer_id],
    [merchant_id],
    [amt],
    [tax_amt],
    [discount_amt],
    [currency],
    [payment_method],
    [channel],
    [entry_mode],
    [device_type],
    [transaction_status],
    [trans_num],
    [session_id],
    [unix_time],
    [is_fraud]
INTO Gold.FactTransactions
FROM Silver.Transactions;

ALTER TABLE Gold.FactTransactions ALTER COLUMN transaction_id INT NOT NULL;
ALTER TABLE Gold.FactTransactions ADD CONSTRAINT PK_FactTransactions PRIMARY KEY (transaction_id);
GO

--------- Foreign Keys ---------
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS FactTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS FactColumn,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) + '.' + OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc 
    ON fk.object_id = fkc.constraint_object_id
WHERE fk.parent_object_id = OBJECT_ID('Gold.FactTransactions');

IF NOT EXISTS (
    SELECT 1 
    FROM sys.key_constraints 
    WHERE parent_object_id = OBJECT_ID('Gold.dimMerchants') 
      AND type = 'PK'
)
BEGIN
    ALTER TABLE Gold.dimMerchants ALTER COLUMN merchant_id INT NOT NULL;
    ALTER TABLE Gold.dimMerchants ADD CONSTRAINT PK_Gold_dimMerchants PRIMARY KEY (merchant_id);
END
GO

ALTER TABLE Gold.FactTransactions
ADD CONSTRAINT FK_FactTransactions_dimMerchants
FOREIGN KEY (merchant_id) REFERENCES Gold.dimMerchants(merchant_id);
GO

-------------------------------------------------------------------------------------------------------------------


USE Commerce;
GO

IF OBJECT_ID('Gold.FK_FactTransactions_Dim_Payment', 'F') IS NOT NULL
    ALTER TABLE Gold.FactTransactions DROP CONSTRAINT FK_FactTransactions_Dim_Payment;
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'Gold' AND TABLE_NAME = 'FactTransactions' AND COLUMN_NAME = 'payment_key')
    ALTER TABLE Gold.FactTransactions DROP COLUMN payment_key;
GO

DROP TABLE IF EXISTS Gold.Dim_Payment;
GO

----------------------------------------------------------------------------------------------------------

--------- Indexes ---------
create index IX_fact_datekey     on Gold.FactTransactions (datekey);
create index IX_fact_customer_id on Gold.FactTransactions (customer_id);
create index IX_fact_merchant_id on Gold.FactTransactions (merchant_id);

