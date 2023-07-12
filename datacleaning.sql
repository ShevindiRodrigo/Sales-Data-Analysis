Use Sales

Select * from [dbo].[DataStaging]
go



drop procedure if exists removeInvalidData
drop table if exists #invalidDataTbl
create table #invalidDataTbl(
	[Sale Date] datetime,
	[Loyalty] nvarchar(255),
	[Reciept Id] float,
	[Customer ID] nvarchar(255),
	[Customer First Name] nvarchar(255),
	[Customer Surname] nvarchar(255),
	[Staff ID] nvarchar(255),
	[Staff First Name] nvarchar(255),
	[Staff Surname] nvarchar(255),
	[Staff office] float,
	[Office Location] nvarchar(255),
	[Reciept Transaction Row ID] float,
	[Item ID] float,
	[Item Description] nvarchar(255),
	[Item Quantity] float,
	[Item Price] float,
	[Row Total] float
)
/* removed invalid records from the staging table*/
Create procedure removeInvalidData
as
begin
	insert into #invalidDataTbl
	select * from [dbo].[DataStaging]
	where [dbo].[DataStaging].[Reciept Id] in  
		(Select distinct [dbo].[DataStaging].[Reciept Id]
		from [dbo].[DataStaging]
		group by [dbo].[DataStaging].[Reciept Id]
		having Count(distinct [dbo].[DataStaging].[Staff Id]) != 1)
end
execute removeInvalidData

select * from #invalidDataTbl

delete from [dbo].[DataStaging]
where [dbo].[DataStaging].[Reciept Id] in (Select #invalidDataTbl.[Reciept Id] from #invalidDataTbl)

select * from [dbo].[DataStaging]

