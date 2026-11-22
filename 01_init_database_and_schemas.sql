Use master;
GO

CREATE DATABASE Commerce;
GO

USE Commerce;
GO

CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO


ALTER SCHEMA Bronze TRANSFER dbo.[Customers (3)];
ALTER SCHEMA Bronze TRANSFER dbo.Merchants;
ALTER SCHEMA Bronze TRANSFER dbo.Transactions;