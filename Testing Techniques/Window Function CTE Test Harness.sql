WITH Tally (n) AS
(
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
SELECT MyDate   = DATEADD(day, 1+ABS(CHECKSUM(NEWID()))%10000, CAST('1900-01-01' AS DATE))
    ,MyTime     = DATEADD(millisecond, 1+ABS(CHECKSUM(NEWID()))%86400000, CAST('00:00' AS TIME))
--INTO #Temp
FROM Tally;
