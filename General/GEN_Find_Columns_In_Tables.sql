/*################################################
//           FIND COLUMNS IN TABLES             //
//                                              //
################################################*/
/*
	Author: Steven Duffy
	Date:	16-10-2019

	Info:	Find Columns in Tables WHERE a full or 
  part columnname is known.

	Comments: Nice day of getting to know GitHub

	Weather: Overcast but not quite cold enough for a jacket yet.
	Temp: 12°C

*/

SELECT
  sys.columns.name AS ColumnName,
  tables.name AS TableName
FROM
  sys.columns
JOIN sys.tables ON
  sys.columns.object_id = tables.object_id
WHERE
  sys.columns.name like '%market%' -- Search for partial column name
