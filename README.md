# Sales Data Analysis and Visualization

## Problem Overview
BIA Inc. is a leading sales company in Australia with branches and offices nationwide. However, the sales performance of the Newcastle branch has been declining. The head sales executive suspects that the underperformance may be attributed to below-average salespeople in the branch. To address this, an analysis of the sales data needs to be conducted to identify the best-performing salesperson and provide recommendations for improving revenue and customer transaction behavior. However, the company lacks a centralized database to store and monitor sales performance and revenue data effectively.

## Tool
- Excel
- Microsoft SQL Server

## Programming Language
- SQL

## Visualization
- Excel

## Source Dataset
- ny_accident.csv

## Content

### Data Model
A "Sales" Star DataMart was designed to store the sales data in a format that allows for scalability and analysis.

#### Sales - Star Schema Data Mart Design
![Data mart design diagram](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/Screenshots/Picture1.png)

### Design Rationale
The chosen data model and data mart design aim to facilitate data analysis and expansion of information. The star schema structure provides a centralized fact table (e.g., "FactSales") linked to dimension tables (e.g., "DimDate," "DimCustomer," "DimStaff," "DimItem") for efficient analysis and querying.
A datamart is a specialized subset of a data warehouse that focuses on a specific subject area, allowing for quick and cost-effective creation. It is designed to improve user response time by storing pertinent and necessary information related to a single subject line.

The simplicity of the design lies in the Star schema, which is a relational database schema resembling a star-like structure. It consists of a central fact table connected to multiple dimension tables. The dimension tables are independent of each other and provide additional context and details for analysis.

For our sales project, the fact table represents the primary business process, which is sales. It should include measurements and essential data necessary for analyzing the business process. In our case, metrics such as row total, item quantity, and discount status are important. Additionally, the fact table should include other essential sales data like receipt ID, receipt transaction row ID, and relevant foreign keys.

In addition to the fact table, we need to determine the dimensions of the analysis. These dimensions provide additional context to the sales data and include Date (to analyze sales over time), Office (to analyze sales by location), Item (to analyze sales by product), Customer (to analyze sales by customer), and Staff (to analyze sales by salesperson).

It is important to note that while the Star schema simplifies the design and improves analysis capabilities, it does not fully normalize the data. Normalization is the process of organizing data to minimize redundancy and improve data integrity. However, in a Star schema, some redundancy may exist to optimize query performance and simplify data retrieval for analysis purposes.

By leveraging the data mart with the Star schema design, businesses can quickly and affordably analyze sales data, improve decision-making, and enhance overall performance.

To demonstrate the functional correctness of the designed datamart and Star schema, we can provide evidence in the form of a SQL query that retrieves the names and IDs of customers who are eligible for a 12.5% discount. Here's the SQL query:

```sql
SELECT DISTINCT c.Customer_ID, CONCAT(c.Customer_First_Name, ' ', c.Customer_Surname) AS Customer_Name
FROM FactSale f
JOIN DimCustomer c ON f.Customer_Key = c.Cust_Key
WHERE f.Discount_status = 'Yes';
```
This query retrieves distinct customer IDs and their corresponding full names from the FactSale and DimCustomer tables. It ensures that only customers with a discount status of 'Yes' are included in the result.

By executing this query against the datamart, we can verify if the design accurately captures and stores the necessary information to identify eligible customers for the 12.5% discount. The result of the query will provide a list of customer names and IDs who meet the discount criteria, demonstrating that the datamart and Star schema design are functionally correct.

Please note that the provided evidence is a specific example, and further queries and analyses can be performed to validate the functionality of the entire datamart design.

### Data Load Process
The ETL/ELT process was executed to load the data into the Sales DataMart. This involved extracting the raw sales data, transforming it to match the desired structure, and loading it into the appropriate tables within the DataMart. Quality Assurance processes were performed to ensure data cleanliness and consistency.

### Output of Analysis
SQL scripts and queries were utilized to perform the analysis on the sales data. The following metrics and insights were obtained:

1. Total receipts or transactions made
2. Number of transactions or receipts issued each month
3. Number of transactions or receipts issued each quarter
4. Items sold each month
5. Revenue generated by each salesperson

The analysis involved aggregating and summarizing the data to identify sales trends, top-performing salespersons, and revenue patterns.

(Include relevant SQL scripts/queries and analysis findings here)

### Business Recommendations
