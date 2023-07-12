-- Retrive rows with null values
-- Check Sale date, receipt id, Customer id, Staff id, Satff office, 
-- Item id and Receipt transaction row id columns for null values
Select *
From [dbo].[DataStaging]
Where [dbo].[DataStaging].[Sale Date] is null

-- if there is are rows with null value for Sale date, receipt id, Customer id, Staff id, Satff office, 
-- Item id and Receipt transaction row id --> delete them
--- otherwise ignore other null values
-- assume other fields can have null values
delete from [dbo].[DataStaging]
where [dbo].[DataStaging].[Sale Date] is null 
	or [dbo].[DataStaging].[Customer ID] is null
	or [dbo].[DataStaging].[Reciept Id] is null
	or [dbo].[DataStaging].[Staff ID] is null
	or [dbo].[DataStaging].[Staff office] is null
	or [dbo].[DataStaging].[Item ID] is null
	or [dbo].[DataStaging].[Reciept Transaction Row ID] is null