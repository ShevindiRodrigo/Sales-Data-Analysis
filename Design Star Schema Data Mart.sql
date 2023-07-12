-- Setup table for Star Schema Data Mart 
Use Sales_BIA
GO
-- Drop tables if they exist
DROP TABLE IF EXISTS FactSale;	--Need to drop FactTable before dropping other tables, 
						--	for example, DimItem and DimDate tables as 
						--	the Fact table contains Foreign Key references 
						--	to both DimItem and DimDate tables
						--	and you cannot drop a table with existing references
						--	from another table
DROP TABLE IF EXISTS DimCustomer;
DROP TABLE IF EXISTS DimStaff;
DROP TABLE IF EXISTS DimDate;
DROP TABLE IF EXISTS DimOffice;
DROP TABLE IF EXISTS DimItem;		--After FactTable has been dropped, it is safe to drop Item Table

GO

CREATE TABLE DimCustomer (
	Cust_Key int identity not null,					-- Surrogate key for Dimension Table
	Customer_ID nvarchar(10) not null,				
	Customer_First_Name nvarchar(20),
	Customer_Surname nvarchar(20),				
	Loyalty_status nvarchar(10) 
 Primary Key (Cust_Key),
 constraint chk_loyality check(Loyalty_status in ('Yes','No'))
 )

 -- Need a dimension table for sales office
 --	since there are several branches for the sales company and it would
 --	easy in selecting the best salesperson from specific branch 
 CREATE TABLE DimOffice (
	Office_Key int identity not null,			-- Surrogate key for Dimension Table
	Office_ID int not null,			
	Office_location nvarchar(30),
	
  Primary Key (Office_Key),

)

 CREATE TABLE DimStaff (
	Staff_Key int identity not null,				-- Surrogate key for Dimension Table	
	Staff_ID nvarchar(6)not null,						-- staff natural key identifer
	Staff_First_Name nvarchar(20),				
	Staff_Surname nvarchar(20),

	Primary Key (Staff_Key)
	)


CREATE TABLE DimItem (					
	Item_Key int identity not null,					--Surrogate dimension table key
	Item_ID	nvarchar(5) not	null,						-- Natural item key
	Item_Description nvarchar(30),
	Item_unitPrice decimal(5,2)

 Primary Key (Item_Key)
 )

CREATE TABLE DimDate (
	Date_Key int identity not null,
	Date_ID date not null,							--This will be the datekey and the actual date, although in 
													--	DataMarts it is usually a surrogate key that has a YYYYMMDD format
													--	 to allow joins across all table and date formats
	Date_Month int,							--Can calculate Month from date
	Date_Quarter int,
	Date_Year int,

 Primary Key (Date_Key)
 )

--We now create the Fact Table for each Sale transaction.
 CREATE TABLE FactSale (
	Sale_Key int identity not null,					--Surrogate Sale Fact Key
	Receipt_ID nvarchar(255) not null,
	Sub_Receipt_ID nvarchar(255)null,
	Reciept_Transaction_Row_ID int not null,        --Natural Sale Transaction Key
	Sale_Date_Key int,							    --will use a Date Dimension later
	Customer_Key int,
	Office_Key int,
	Staff_Key int,
	Item_Key Int,
	Item_Quantity int,
	Row_Total decimal(10,2),
	Discount_status nvarchar(5) default 'No',
	
 FOREIGN KEY (Item_Key) REFERENCES DimItem (Item_Key),
 FOREIGN KEY (Sale_Date_Key)  REFERENCES DimDate (Date_Key),
 FOREIGN KEY (Customer_Key) REFERENCES DimCustomer (Cust_Key),
 FOREIGN KEY (Staff_Key) REFERENCES DimStaff (Staff_Key),
 FOREIGN KEY (Office_Key) REFERENCES DimOffice (Office_Key),

 )							

 GO