# Output of Analysis

In order to address the business issue raised by the head sales executive of the BIA company, a comprehensive analysis was conducted to determine the best salesperson. The following metrics were considered in providing solutions for this problem:

1. Total receipts or transactions made:
To determine the total number of sales transactions made by each staff member of the Newcastle branch, the following query was executed:

```sql
SELECT COUNT(DISTINCT f.Receipt_ID) AS Transaction_count, s.Staff_ID
FROM FactSale f, DimStaff s
WHERE f.Staff_Key = s.Staff_Key
GROUP BY f.Staff_Key, s.Staff_ID;
```
![](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/Screenshots/Picture12.png)
This query provides insights into the total number of transactions made by each salesperson.

2. Number of transactions or receipts issued each month:
To analyze the number of transactions or receipts issued by each staff member on a monthly basis, the following query was executed:

```sql
-- Create a temporary table to store transaction count per staff member per month
CREATE TABLE #transactionCount_Staff_Month (
  Staff_Id NVARCHAR(255),
  countTrans INT,
  Month INT,
  Year INT
)

INSERT INTO #transactionCount_Staff_Month (Staff_Id, countTrans, Month, Year)
SELECT s.Staff_ID, COUNT(DISTINCT f.Receipt_ID), d.Date_Month, d.Date_Year
FROM DimDate d, DimStaff s, FactSale f
WHERE f.Staff_Key = s.Staff_Key AND f.Sale_Date_Key = d.Date_Key
GROUP BY f.Staff_Key, d.Date_Key, f.Sale_Date_Key, s.Staff_ID, s.Staff_Key, d.Date_Month, d.Date_Year, f.Receipt_ID

-- Query to retrieve the transaction count per staff member per month
SELECT Staff_Id, COUNT(countTrans) AS Transaction_Count, Month, Year
FROM #transactionCount_Staff_Month
WHERE Month IN (SELECT Date_Month FROM DimDate) AND Year IN (SELECT Date_Year FROM DimDate) AND countTrans <> 0
GROUP BY Month, Year, Staff_Id;
```

This query provides a breakdown of the number of transactions issued by each staff member on a monthly basis.
![](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/Screenshots/Picture21.png)

3. Number of transactions or receipts issued each quarter:
To analyze the number of transactions or receipts issued by each staff member on a quarterly basis, the following query was executed:

```sql
-- Create a temporary table to store transaction count per staff member per quarter
CREATE TABLE #transactionCount_Staff_Quarter (
  Staff_Id NVARCHAR(255),
  countTrans INT,
  Quarter INT,
  Year INT
)

INSERT INTO #transactionCount_Staff_Quarter (Staff_Id, countTrans, Quarter, Year)
SELECT s.Staff_ID, COUNT(DISTINCT f.Receipt_ID) AS Transaction_count, d.Date_Quarter, d.Date_Year
FROM DimDate d, DimStaff s, FactSale f
WHERE f.Staff_Key = s.Staff_Key AND f.Sale_Date_Key = d.Date_Key
GROUP BY f.Staff_Key, d.Date_Key, f.Sale_Date_Key, s.Staff_ID, s.Staff_Key, d.Date_Quarter, d.Date_Year, f.Receipt_ID

-- Query to retrieve the transaction count per staff member per quarter
SELECT Staff_Id, COUNT(countTrans) AS Transaction_Count, Quarter, Year
FROM #transactionCount_Staff_Quarter
WHERE Quarter IN (SELECT Date_Quarter FROM DimDate) AND Year IN (SELECT Date_Year FROM DimDate) AND countTrans <> 0
GROUP BY Quarter, Year, Staff_Id;
```

This query provides a breakdown of the number of transactions issued by each staff member on a quarterly basis.
![](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/Screenshots/Picture3.png)

4. Items sold each month:
To analyze the number of items sold by each staff member on a monthly basis, the following query was executed:

```sql
-- Create a temporary table to store item count per staff member per month
CREATE TABLE #ItemCount_Staff_Month (
  Staff_Id NVARCHAR(255),
  ItemCount INT,
  Month INT,
  Year INT
)

INSERT INTO #ItemCount_Staff_Month (Staff_Id, ItemCount, Month, Year)
SELECT s.Staff_ID, SUM(f.Item_Quantity), d.Date_Month, d.Date_Year
FROM DimDate d, DimStaff s, FactSale f
WHERE f.Staff_Key = s.Staff_Key AND f.Sale_Date_Key = d.Date_Key
GROUP BY f.Staff_Key, d.Date_Key, f.Sale_Date_Key, s.Staff_ID, s.Staff_Key, d.Date_Month, d.Date_Year, f.Item_Quantity

-- Query to retrieve the item count per staff member per month
SELECT Staff_Id, SUM(ItemCount) AS Item_Count, Month, Year
FROM #ItemCount_Staff_Month
WHERE Month IN (SELECT Date_Month FROM DimDate) AND Year IN (SELECT Date_Year FROM DimDate)
GROUP BY Month, Year, Staff_Id
ORDER BY Month, Year, Item_Count DESC;
```

This query provides a breakdown of the number of items sold by each staff member on a monthly basis.
![](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/Screenshots/Picture4.png)

5. Revenue made from each salesperson:
To determine the revenue made by each salesperson, the following query was executed:

```sql
SELECT TOP 5 s.Staff_ID, SUM(f.Row_Total) AS Revenue
FROM FactSale f, DimStaff s
WHERE f.Staff_Key = s.Staff_Key
GROUP BY f.Staff_Key, s.Staff_Key, s.Staff_ID
ORDER BY Revenue DESC;
```

This query retrieves the top 5 salespeople based on their revenue.

By analyzing these metrics, we can identify the best salesperson. In this case, based on the provided sample data, the salesperson with the staff ID "S15" (Mel Jackson) consistently demonstrated good
sales performance across various metrics.

