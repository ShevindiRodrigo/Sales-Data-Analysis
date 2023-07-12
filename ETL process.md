## ETL Process

The data integration process known as ETL, or extract, transform, and load, merges data from several data sources into a single, consistent data store that is loaded into a datamart. ETL is a procedure for integrating and loading data for computation and analysis. It is the main way to process data for data warehousing projects.

ETL cleans and arranges data through a set of business rules in a way that satisfies particular business intelligence requirements, such as monthly reporting, but it can also handle more advanced analytics that might enhance back-end operations or end-user experiences.

This process is used for:
- Extracting data from legacy systems.
- Cleansing the data to improve data quality and establish consistency.
- Loading data into a target database.

### Create DB Sales_BIA in MS SQL Server

```sql
CREATE DATABASE Sales_BIA;
```

### Extract

Raw data from AssignmentOne2022RealData.xls is imported to a staging area on the MS SQL server.

```sql
USE Sales_BIA;

-- Drop tables if they exist
DROP TABLE IF EXISTS dbo.DataStaging;

CREATE TABLE dbo.DataStaging (
    [Sale Date] datetime,
    Loyalty nvarchar(255),
    [Reciept Id] int,
    [Customer ID] nvarchar(255),
    [Customer First Name] nvarchar(255),
    [Customer Surname] nvarchar(255),
    [Staff ID] nvarchar(255),
    [Staff First Name] nvarchar(255),
    [Staff Surname] nvarchar(255),
    [Staff office] int,
    [Office Location] nvarchar(255),
    [Reciept Transaction Row ID] int,
    [Item ID] int,
    [Item Description] nvarchar(255),
    [Item Quantity] int,
    [Item Price] decimal,
    [Row Total] decimal
) ON [PRIMARY];

INSERT INTO dbo.DataStaging (
    [Sale Date], Loyalty, [Reciept Id], [Customer ID], [Customer First Name], [Customer Surname],
    [Staff ID], [Staff First Name], [Staff Surname], [Staff office], [Office Location],
    [Reciept Transaction Row ID], [Item ID], [Item Description], [Item Quantity], [Item Price], [Row Total]
)
SELECT [Sale Date], Loyalty, [Reciept Id], [Customer ID], [Customer First Name], [Customer Surname],
    [Staff ID], [Staff First Name], [Staff Surname], [Staff office], [Office Location],
    [Reciept Transaction Row ID], [Item ID], [Item Description], [Item Quantity], [Item Price], [Row Total]
FROM [dbo].['Asgn1 Data$'];
```

### Transform

This is the phase where the raw data is processed. The data is changed and refined in this place for its intended analytical use case.

Following tasks are done within this transform stage:
- Filtering, cleaning, and removing duplicates.
- Performing calculations, transforming invalid data, and summarizing raw data.

According to our project, when carefully going through the dataset, we were able to find out records against the business rule, "Only 1 BIA sales assistant can be attributed to any sales transaction receipt". There were several sales assistants that were attributed to a sales transaction receipt.

Reciept IDs of such transactions were filtered, and a new column with sub receipt IDs was created, concatenating the corresponding receipt ID and Staff ID.

```sql
UPDATE dbo.DataStaging
SET SubReciept = CONCAT([Reciept Id], [Staff ID])
WHERE [Reciept Id] IN (
    SELECT DISTINCT [Reciept Id]
    FROM dbo.DataStaging
    GROUP BY [Reciept Id]
    HAVING COUNT(DISTINCT [Staff Id]) != 1
);
```

Data set was queried for null values. If found, they were removed from the data set.

```sql
DELETE FROM dbo.DataStaging
WHERE [Sale Date] IS NULL
    OR [Customer ID] IS NULL
    OR [Reciept Id] IS NULL
    OR [Staff ID] IS NULL
    OR [Staff office] IS NULL
    OR [Item ID] IS NULL
    OR [Reciept Transaction Row ID] IS NULL;
```

Checked for any duplicate entries, and they were removed with the following query.

```sql
WITH CTE AS (
    SELECT [Sale Date], Loyalty, [Reciept Id], [Customer ID], [Customer First Name], [Customer Surname],
        [Staff ID], [Staff First Name], [Staff Surname], [Staff office], [Office Location],
        [Reciept Transaction Row ID], [Item ID], [Item Description], [Item Quantity], [Item Price], [Row Total],
        ROW_NUMBER() OVER (
            PARTITION BY [Sale Date], Loyalty, [Reciept Id], [Customer ID], [Customer First Name], [Customer Surname],
                [Staff ID], [Staff First Name], [Staff Surname], [Staff office], [Office Location],
                [Reciept Transaction Row ID], [Item ID], [Item Description], [Item Quantity], [Item Price], [Row Total]
            ORDER BY [Reciept Id]
        ) AS DuplicateCount
    FROM DataStaging
)
DELETE FROM CTE
WHERE DuplicateCount > 1;
```

### Load

In this last step, the transformed data is moved from the staging area into a targeted datamart.

```sql
-- Populate the DataMart Star Schema tables from DataStaging table.

-- DimDate
INSERT INTO DimDate (Date_ID, Date_Month, Date_Quarter, Date_Year)
SELECT DISTINCT CAST(DataStaging.[Sale Date] AS date), DATEPART(month, DataStaging.[Sale Date]),
    DATEPART(QUARTER, DataStaging.[Sale Date]), DATEPART(year, DataStaging.[Sale Date])
FROM DataStaging;

-- DimCustomer
INSERT INTO DimCustomer (Customer_ID, Customer_First_Name, Customer_Surname, Loyalty_status)
SELECT DISTINCT DataStaging.[Customer ID], DataStaging.[Customer First Name], DataStaging.[Customer Surname], DataStaging.Loyalty
FROM DataStaging;

-- DimOffice
INSERT INTO DimOffice (Office_ID, Office_location)
SELECT DISTINCT DataStaging.[Staff office], DataStaging.[Office Location]
FROM DataStaging;

-- DimStaff
INSERT INTO DimStaff (Staff_ID, Staff_First_Name, Staff_Surname)
SELECT DISTINCT DataStaging.[Staff ID], DataStaging.[Staff First Name], DataStaging.[Staff Surname]
FROM DataStaging;

-- DimItem
INSERT INTO DimItem (Item_ID, Item_Description, Item_unitPrice)
SELECT DISTINCT DataStaging.[Item ID], DataStaging.[Item Description], DataStaging.[Item Price]
FROM DataStaging;

-- Now Populate the Fact Table
INSERT INTO FactSale (Receipt_ID, Sub_Receipt_ID, Reciept_Transaction_Row_ID, Sale_Date_Key, Customer_Key, Office_Key, Staff_Key, Item_Key, Item_Quantity, Row_Total)
SELECT x.[Reciept Id], x.SubReciept, x.[Reciept Transaction Row ID], d.Date_Key

, c.Cust_Key, o.Office_Key, s.Staff_Key, i.Item_Key, x.[Item Quantity], x.[Row Total]
FROM DataStaging x
INNER JOIN DimStaff s ON x.[Staff ID] = s.Staff_ID
INNER JOIN DimOffice o ON x.[Staff office] = o.Office_ID
INNER JOIN DimCustomer c ON x.[Customer ID] = c.Customer_ID
INNER JOIN DimDate d ON x.[Sale Date] = d.Date_ID
INNER JOIN DimItem i ON x.[Item ID] = i.Item_ID;
```

The following query was executed to give information about the eligibility of the customer to obtain a discount according to a particular receipt ID.

```sql
-- If the item count for a particular receipt is greater than 5 and the customer is a loyalty customer, then the customer is qualified for a discount of 12.5%.
UPDATE FactSale
SET Discount_status = 'Yes'
WHERE Receipt_ID IN (
    SELECT Receipt_ID
    FROM FactSale
    GROUP BY Receipt_ID
    HAVING COUNT(Receipt_ID) > 5
) AND Customer_Key IN (
    SELECT DISTINCT f.Customer_Key
    FROM FactSale f
    INNER JOIN DimCustomer c ON f.Customer_Key = c.Cust_Key
    WHERE c.Loyalty_status = 'Yes'
);
```

### Evidence of Scripts to Identify any Data Anomalies

**Insertion Anomalies:**
Attempt to insert a staff key value that is not in the DimStaff table.

```sql
INSERT INTO FactSale (Receipt_ID, Reciept_Transaction_Row_ID, Sale_Date_Key, Customer_Key, Office_Key, Staff_Key, Item_Key, Item_Quantity, Row_Total)
VALUES (29000, 1, 20, 30, 2, 21, 5, 4, 44);
```

Output:
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__FactSale__Staff___5DCAEF64". The conflict occurred in the database "Sales_BIA", table "dbo.DimStaff", column 'Staff_Key'. The statement has been terminated.

**Deletion Anomalies:**
Attempt to delete an important record that must not be deleted from the DimStaff table.

```sql
DELETE FROM DimStaff WHERE Staff_Key = 3;
```

Output:
The DELETE statement conflicted with the REFERENCE constraint "FK__FactSale__Staff___5DCAEF64". The conflict occurred in the database "Sales_BIA", table "dbo.FactSale", column 'Staff_Key'.

*Note: The above code snippets demonstrate the anomalies and their corresponding outputs.*
##### [Back HOME -->](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/README.md)
