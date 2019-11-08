/*################################################
//              TRIGGER EXAMPLE                 //
//                                              //
################################################*/
/*
	Author: Steven Duffy
	Date:	11 NOVEMBER 2019

	Info:	Example of a DB Trigger including an email element

	Comments: IT's Friday, Friday, Friday Whooaahh


	Weather: Coldy and icy morning, beginning to clear with sunny spells 
	Temp: 04°C

*/

USE [ACE]
GO
/****** Object:  Trigger [dbo].[tr_APPROVED]    Script Date: 08/11/2019 11:03:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[tr_APPROVED]
   ON [dbo].[IMS_Revisions]
   AFTER UPDATE
AS 

DECLARE @Revision varchar(20),
		@DocumentName as varchar(MAX),
		@DocumentNumber as varchar(20),
		@DocumentLink as varchar(MAX),
		@ApproverID as decimal(10,0),
		@EmailSubject as varchar(200),
		@EmailBody as varchar(MAX),
		@TOemail as varchar(MAX) = 'grant.donald@ace-winches.com;Keith.Anderson@ace-winches.com;stephanie.cowie@ace-winches.com;bill.nelson@ace-winches.com',	
		@CCemail as varchar(50),
		@BCCemail as varchar(50) = 'steven.duffy@ace-winches.com';

BEGIN
    SET NOCOUNT ON;
    IF UPDATE (Approved)
		BEGIN
		IF EXISTS(Select 1 from inserted I JOIN deleted D ON I.Revision_id = D.Revision_id AND I.Approved = 1  and D.Approved = 0)
			BEGIN
				SET @Revision = (Select I.Revision_No from inserted I JOIN deleted D ON I.Revision_id = D.Revision_id AND I.Approved = 1 );
				SET @DocumentNumber = (Select I.Document_No from inserted I JOIN deleted D ON I.Revision_id = D.Revision_id AND I.Approved = 1 );	
				SET @DocumentLink = (Select Current_Revision_PDF FROM IMS_Document WHERE Document_No = @DocumentNumber); --(Select I.Revision_Document from inserted I JOIN deleted D ON I.Revision_id = D.Revision_id AND I.Approved = 1 );
				SET @DocumentName = N'<TD><a href="' + @DocumentLink + '">' + (Select I.Document_Name from inserted I JOIN deleted D ON I.Revision_id = D.Revision_id AND I.Approved = 1 ) + '</a></TD>';			
				SET @ApproverID = (Select I.Approver_User_id from inserted I JOIN deleted D ON I.Revision_id = D.Revision_id AND I.Approved = 1 );
				SET @EmailSubject = 'Approved Revision - ' + @DocumentNumber;
				SET @EmailBody = 'Revision ' + @Revision + ' for document ' + @DocumentName + ' has been approved.' + N'<br><br>' + 'Thank you.' + N'<br>';
				SET @CCemail = (SELECT dbo.[User].Email FROM dbo.[User] WHERE dbo.[User].user_id = @ApproverID);
				
				EXEC msdb.dbo.sp_send_dbmail 	@profile_name = 'C-SAM Alert', @recipients =  @TOemail, @copy_recipients = @CCemail, @blind_copy_recipients = @BCCemail ,@subject = @EmailSubject,@body = @EmailBody, @body_format = 'HTML';
			END 
		END
	
END