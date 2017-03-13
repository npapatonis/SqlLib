
SELECT [name], CONVERT(DEC(19, 2), [size]) * 8192 / 1048576.0 AS [size_mb] FROM sys.master_files WHERE [database_id] = DB_ID('Guard1Track') OR [database_id] = DB_ID('Guard1TrackWarehouse')
