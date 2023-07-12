--  Populate the DataMart Star Schema tables from DataStaging table.

USE Sales
GO

INSERT INTO DimDate 
(Date_ID, Date_Month, Date_Day, Date_Year)
SELECT distinct Cast(DataStaging.[Sale Date] AS date), Datepart(month, DataStaging.[Sale Date]), Datepart(DAY, DataStaging.[Sale Date]), Datepart(year, DataStaging.[Sale Date]) 
FROM DataStaging


Insert into DimCustomer
(Customer_ID, Customer_First_Name, Customer_Surname, Loyalty_status)
SELECT distinct DataStaging.[Customer ID], DataStaging.[Customer First Name], DataStaging.[Customer Surname],DataStaging.Loyalty
From DataStaging


Insert into DimOffice
(Office_ID, Office_location)
SELECT distinct DataStaging.[Staff office],
	DataStaging.[Office Location]
	From DataStaging

Insert into DimStaff
 (Staff_ID, Staff_First_Name, Staff_Surname)
SELECT distinct  DataStaging.[Staff ID],DataStaging.[Staff First Name], DataStaging.[Staff Surname]
FROM DataStaging

Insert into DimItem 
(Item_ID,Item_Description,Item_unitPrice)
SELECT  distinct DataStaging.[Item ID],DataStaging.[Item Description],DataStaging.[Item Price] from DataStaging



--Now Populate the Fact Table
Insert into FactSale
(Receipt_ID, Reciept_Transaction_Row_ID, Sale_Date_Key, Customer_Key, Office_Key, Staff_Key, Item_Key,
 Item_Quantity,Row_Total)
	  
  SELECT  x.[Reciept Id],x.[Reciept Transaction Row ID], d.Date_Key, c.Cust_Key, o.Office_Key, s.Staff_Key, i.Item_Key, x.[Item Quantity],  x.[Row Total]
  FROM
  DataStaging x
	inner join DimStaff s
		on x.[Staff ID] = s.Staff_ID
	inner Join DimOffice o	
		on x.[Staff office] = o.Office_ID
	Inner join DimCustomer c
		on x.[Customer ID] = c.Customer_ID
	inner join DimDate d
		on x.[Sale Date] = d.Date_ID
	inner join DimItem i
		on x.[Item ID] = i.Item_ID


Update FactSale
set Discount_status = 'Yes'
where FactSale.Receipt_ID in (

	select FactSale.Receipt_ID
	from FactSale
	group by FactSale.Receipt_ID
	having count(FactSale.Receipt_ID)>5
	) and 
	FactSale.Customer_Key in (
		select distinct f.Customer_Key
		from FactSale f, DimCustomer c
		where f.Customer_Key = c.Cust_Key and c.Loyalty_status ='Yes'
		)

