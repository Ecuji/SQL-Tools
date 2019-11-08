/*################################################
//     FIND SEARCH TERM IN STORED PROCEDURES    //
//               TRIGGERS or JOBS               //
################################################*/
/*
	Author: Steven Duffy
	Date:	08 November 2019

	Info:	This code can help identify if a search term is present in
	programatic SQL Server code.  Particularly useful if you are trying
	to locate a particular trigger, stored procedure or SQL job that is
	running.

	

	Weather: Cold morning , icy roads.
	Temp: 04°C


	NOTES:  (1). Line 1 - Set database to use
		(2). Line 7 - Set search string to look for


USE [ACE];
GO
SELECT [Scehma]=schema_name(o.schema_id), o.Name, o.type 
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON o.object_id = m.object_id
WHERE m.definition like '%Bill.Nelson@ace-winches.com%'
GO