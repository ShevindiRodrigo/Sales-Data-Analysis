# Sales Recommendations

Sales analysis provides valuable insights into a company's sales activities, performance, and overall sales strategy. By analyzing the provided sales data, we have identified some significant insights that can drive long-term growth for BIA Inc. Here are our recommendations based on the analysis:

1. Improve Performance of Underperforming Salespeople:
   - Utilize the total revenue by month or quarter to set sales quotas for each salesperson.
   - Create a table to store revenues by quarter:
   ```sql
   DROP TABLE IF EXISTS #TotRevenue;
   CREATE TABLE #TotRevenue (
      Date_Quarter INT,
      Date_Year INT,
      Revenue DECIMAL(10, 2)
   );

   INSERT INTO #TotRevenue (Date_Quarter, Date_Year, Revenue)
   SELECT d.Date_Quarter, d.Date_Year, SUM(f.Row_Total) AS Revenue
   FROM FactSale f
   JOIN DimDate d ON f.Sale_Date_Key = d.Date_Key
   GROUP BY f.Sale_Date_Key, d.Date_Key, d.Date_Quarter, d.Date_Year;
   ```

   - Calculate average quarterly revenue:
   ```sql
   SELECT SUM(Revenue) / 4
   FROM #TotRevenue;
   ```

   - Create a table to store revenues by month:
   ```sql
   CREATE TABLE #Month_Rev (
      Month INT,
      Year INT,
      Monthly_Revenue DECIMAL(10, 2)
   );

   INSERT INTO #Month_Rev (Month, Year, Monthly_Revenue)
   SELECT d.Date_Month, d.Date_Year, SUM(f.Row_Total)
   FROM DimDate d
   JOIN FactSale f ON f.Sale_Date_Key = d.Date_Key
   GROUP BY d.Date_Month, d.Date_Year, f.Sale_Date_Key, d.Date_Key;
   ```

   - Calculate average monthly revenue:
   ```sql
   SELECT ROUND(SUM(Monthly_Revenue) / 12, 0) AS Monthly_Revenue
   FROM #Month_Rev;
   ```

   Based on the average quarterly revenue of $370,686.25 and the average monthly revenue of $123,562.00, set a monthly revenue target of $200,000. This will allow you to establish expectations and benchmarks for the sales team. Each salesperson should aim for monthly earnings close to $11,000, which can be their sales quota.

2. Real-time Dashboard and Performance Tracking:
   - Implement a real-time dashboard that can be shared with all staff members to track their individual sales achievements and progress towards their targets. This will help motivate and drive performance improvements.

3. Item Analysis:
   - Identify popular items and focus on boosting sales of underperforming items.
   - Determine the item with the highest sales, such as the cordless drill kit, and maintain its momentum.
   - Offer deals and discounts to increase sales of low-performing items.

4. Customer Behavior Analysis:
   - Analyze churned customers' behavior to identify any problematic patterns in the sales process.
   - Implement targeted strategies, such as discount programs or special offers, to regain the interest of churned customers and increase their engagement with the company.

By implementing these recommendations, BIA Inc. can drive performance improvements, increase revenue, and strengthen customer relationships, ultimately leading to long-term growth.
