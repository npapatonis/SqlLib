use [master];
go

if DATABASEPROPERTYEX(N'DbMaint2012', N'Version') > 0
begin
	alter database [DbMaint2012] set single_user with rollback immediate;
	drop database [DbMaint2012];
end
go

create database DbMaint2012;
go

use [DbMaint2012];
go

alter database [DbMaint2012] set recovery full;
go

create table [TestTable]
(
	[c1] int identity,
	[c2] varchar(100)
)
go
create clustered index [TestTable_CL] on [TestTable] ([c1]);
go

insert into [TestTable] values ('Initial data: transaction 1');
go

backup database [DbMaint2012] to disk = 'c:\backups\DbMaint2012.bak' with init;
go

insert into [TestTable] values ('Transaction 2');
go
insert into [TestTable] values ('Transaction 3');
go

-- Simulate a crash
shutdown with nowait;
go

-- Delete data file and restart SQL Server (e.g., net start MSSQLSERVER)

-- Try to take tail log backup
backup log [DbMaint2012] to disk = 'c:\backups\DbMaint2012_tail.trn' with init;
go

-- This time, use the special syntax
backup log [DbMaint2012] to disk = 'c:\backups\DbMaint2012_tail.trn' with init, no_truncate;
go

restore database [DbMaint2012] from disk = 'c:\backups\DbMaint2012.bak' with replace, norecovery;
go

restore log [DbMaint2012] from disk = 'c:\backups\DbMaint2012_tail.trn' with norecovery;
go

restore database [DbMaint2012] with recovery;
go

use [DbMaint2012];
go

select * from [TestTable];
go
