
--optiune 1 fisier bak export
BACKUP DATABASE MagazinDB
--locatie unde SQL are access
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\MagazinDB.bak'
WITH FORMAT;

--optiune 1 fisier bak restore
RESTORE DATABASE MagazinDB
--locatia actuala
FROM DISK = 'C:\Backup\MagazinDB.bak'
WITH MOVE 'MagazinDB' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MagazinDB.mdf',
     MOVE 'MagazinDB_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MagazinDB_log.ldf',
     REPLACE;

--optiune 2 fisiere mdf + ldf
CREATE DATABASE MagazinDB
ON 
(FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MagazinDB.mdf'),
(FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MagazinDB_log.ldf')
FOR ATTACH;
