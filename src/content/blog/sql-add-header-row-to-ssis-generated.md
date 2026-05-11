---
title: "SQL - Add Header Row to SSIS Generated CSV Files"
description: "After generating a flat file in SSIS I needed to update that file with the column headers as the first row. In order to do this I used a SQL stored procedure."
pubDate: 2013-11-04
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/11/sql-add-header-row-to-ssis-generated.html
---

After generating a flat file in SSIS I needed to update that file with the column headers as the first row.  In order to do this I used a SQL stored procedure.

**STEP 1:** Run the code below to create the stored procedure.

```
USE MIGRATION_DB  
  
IF OBJECT_ID('GenerateBCPforSSIS') IS NOT NULL  
DROP PROC GenerateBCPforSSIS  
GO  
  
CREATE PROCEDURE GenerateBCPforSSIS  
(  
@db_name varchar(1000),  
@table_name varchar(1000),  
@file_name varchar(1000)  
) AS  
  
Declare @Headers varchar(MAX),@HeadersRaw varchar(MAX),@sql varchar(MAX), @header_file varchar(MAX), @filename_short varchar(MAX)  
  
--Generate column names as a recordset  
Select @Headers = IsNull(@Headers + ',', '') + '""' + Column_Name + '""'  
From INFORMATION_SCHEMA.COLUMNS  
Where Table_Name = @table_name ORDER BY ORDINAL_POSITION ASC  
  
--Create a dummy file to have header data  
select @header_file=substring(@file_name,1,len(@file_name)-charindex('\',reverse(@file_name)))+'\data_file.csv'  
  
set @sql = 'bcp "select ''' + @Headers + '''" queryout "'+@header_file+'" -c -C RAW -t, -S localhost -T'  
print @sql  
  
set @sql = 'type "'+@file_name+'" >> "'+@header_file+'"'  
print @sql  
  
set @sql = 'del "'+@file_name+'"'  
print @sql  
  
set @filename_short = reverse(substring(reverse(@file_name),1,charindex('\',reverse(@file_name)) -1 ) )  
  
set @sql = 'rename "'+@header_file+'" '+'"'+@filename_short+'"'  
print @sql  
  
GO
```

  

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }

  

**STEP 2**: Run the following command which will produce sql commands for all the views and tables in your database.  You can add where clauses to the statements to limit which views/tables commands are created for.  Note: Make sure to update the MIGRATION\_DB string to the name of your database

```
USE MIGRATION_DB  
  
SELECT 'exec GenerateBCPforSSIS ''MIGRATION_DB'',''' + name + ''',''E:\SSIS Output\' + name + '.csv''' AS CommandName  
FROM sys.views   
  
UNION  
  
SELECT 'exec GenerateBCPforSSIS ''MIGRATION_DB'',''' + name + ''',''E:\SSIS Output\' + name + '.csv''' AS CommandName  
FROM sys.tables
```

  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }  
  

**STEP 3**: Copy the output from the command in step 2 and paste it into a new SQL query window.

  

**STEP 4**: Copy the output from step 3 and past it into a batch file.

  

**STEP 5**: Run the batch file, it will open your SSIS csv file and insert a header row with the column names.

  

Notes:

  

  
- The CVS file output from SSIS must match the names of your Views/Tables
  
- If you change, add, or remove any of the columns in your table/view you will have to run steps 2-5 again.
