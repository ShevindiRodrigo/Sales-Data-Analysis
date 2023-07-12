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
[Data mart design diagram](https://github.com/ShevindiRodrigo/Sales-Data-Analysis/blob/main/Screenshots/Picture1.png)

### Design Rationale
The chosen data model and data mart design aim to facilitate data analysis and expansion of information. The star schema structure provides a centralized fact table (e.g., "FactSales") linked to dimension tables (e.g., "DimDate," "DimCustomer," "DimStaff," "DimItem") for efficient analysis and querying.

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
