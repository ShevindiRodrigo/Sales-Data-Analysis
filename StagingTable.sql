
USE [Sales]

-- Drop tables if they exist
DROP TABLE IF EXISTS [dbo].[DataStaging];

CREATE TABLE [dbo].[DataStaging](
	[Sale Date] datetime,
	[Loyalty] nvarchar(255),
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
) ON [PRIMARY]

INSERT INTO  [dbo].[DataStaging](
	[Sale Date]
      ,[Loyalty]
      ,[Reciept Id]
      ,[Customer ID]
      ,[Customer First Name]
      ,[Customer Surname]
      ,[Staff ID]
      ,[Staff First Name]
      ,[Staff Surname]
      ,[Staff office]
      ,[Office Location]
      ,[Reciept Transaction Row ID]
      ,[Item ID]
      ,[Item Description]
      ,[Item Quantity]
      ,[Item Price]
      ,[Row Total]
)
SELECT [Sale Date]
      ,[Loyalty]
      ,[Reciept Id]
      ,[Customer ID]
      ,[Customer First Name]
      ,[Customer Surname]
      ,[Staff ID]
      ,[Staff First Name]
      ,[Staff Surname]
      ,[Staff office]
      ,[Office Location]
      ,[Reciept Transaction Row ID]
      ,[Item ID]
      ,[Item Description]
      ,[Item Quantity]
      ,[Item Price]
      ,[Row Total]
FROM [dbo].['Asgn1 Data$']