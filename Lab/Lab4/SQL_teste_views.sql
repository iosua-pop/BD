USE MagazinDB
GO

-- Creeam tabele de testare
SELECT * FROM Categorii;
SELECT * FROM Produse;
SELECT *  FROM MagazineProduse;

DROP TABLE TestCategorii;
DROP TABLE TestProduse;
DROP TABLE TestMagazineProduse;

SELECT * INTO TestCategorii FROM Categorii;
SELECT * INTO TestProduse FROM Produse;
SELECT * INTO TestMagazineProduse FROM MagazineProduse;



--  Tabelele pentru testare


-- Teste definite
CREATE TABLE Tests (
    TestId INT PRIMARY KEY IDENTITY,
    Nume NVARCHAR(100),
    Descriere NVARCHAR(255)
);

-- Tabele candidate la test
CREATE TABLE Tables (
    TableId INT PRIMARY KEY IDENTITY,
    Nume NVARCHAR(100)
);

-- View-uri candidate la test
CREATE TABLE Views (
    ViewId INT PRIMARY KEY IDENTITY,
    Nume NVARCHAR(100)
);

-- Tabele implicate in teste (cu ordinea de executie si nr. randuri)
CREATE TABLE TestTables (
    TestId INT,
    TableId INT,
    Position INT,
    NoOfRows INT,
    PRIMARY KEY (TestId, TableId),
    FOREIGN KEY (TestId) REFERENCES Tests(TestId),
    FOREIGN KEY (TableId) REFERENCES Tables(TableId)
);

-- View-uri implicate in teste
CREATE TABLE TestViews (
    TestId INT,
    ViewId INT,
    PRIMARY KEY (TestId, ViewId),
    FOREIGN KEY (TestId) REFERENCES Tests(TestId),
    FOREIGN KEY (ViewId) REFERENCES Views(ViewId)
);

-- Logul rularilor de teste
CREATE TABLE TestRuns (
    TestRunId INT PRIMARY KEY IDENTITY,
    TestId INT,
    StartAt DATETIME,
    EndAt DATETIME,
    Descriere NVARCHAR(255),
    FOREIGN KEY (TestId) REFERENCES Tests(TestId)
);

-- Logul rularilor pe tabele (inserare)
CREATE TABLE TestRunTables (
    TestRunId INT,
    TableId INT,
    StartAt DATETIME,
    EndAt DATETIME,
    NoOfRows INT,
    PRIMARY KEY (TestRunId, TableId),
    FOREIGN KEY (TestRunId) REFERENCES TestRuns(TestRunId),
    FOREIGN KEY (TableId) REFERENCES Tables(TableId)
);

-- Logul rularilor pe view-uri (select)
CREATE TABLE TestRunViews (
    TestRunId INT,
    ViewId INT,
    StartAt DATETIME,
    EndAt DATETIME,
    PRIMARY KEY (TestRunId, ViewId),
    FOREIGN KEY (TestRunId) REFERENCES TestRuns(TestRunId),
    FOREIGN KEY (ViewId) REFERENCES Views(ViewId)
);

INSERT INTO Tests (Nume, Descriere)
VALUES ('Test performanta pe tabele de backup', 'Testare pe TestCategorii, TestProduse si TestMagazineProduse');


INSERT INTO Tables (Nume) VALUES 
('TestCategorii'), 
('TestProduse'), 
('TestMagazineProduse');

INSERT INTO TestTables (TestId, TableId, Position, NoOfRows)
VALUES
(1, 1, 1, 10),
(1, 2, 2, 50),
(1, 3, 3, 100);



-- View-uri definite
-- 1. View simplu (1 tabela)
CREATE VIEW View_Categorii AS
SELECT * FROM Categorii;



-- 2. View cu JOIN
CREATE VIEW View_ProduseCategorii AS
SELECT P.Nume, P.Pret, C.Nume AS Categorie
FROM Produse P
JOIN TestCategorii C ON P.IdCategorie = C.IdCategorie;


-- 3. View cu GROUP BY
CREATE VIEW View_StocuriPeMagazin AS
SELECT MP.IdMagazin, SUM(MP.Stoc) AS TotalStoc
FROM MagazineProduse MP
GROUP BY MP.IdMagazin;



-- 1. test
CREATE VIEW View_TestCategorii AS
SELECT * FROM TestCategorii;

-- 2. test cu JOIN
CREATE VIEW View_TestProduseCategorii AS
SELECT P.Nume, P.Pret, C.Nume AS Categorie
FROM TestProduse P
JOIN TestCategorii C ON P.IdCategorie = C.IdCategorie;

-- 3. test cu GROUP BY
CREATE VIEW View_TestStocuriPeMagazin AS
SELECT MP.IdMagazin, SUM(MP.Stoc) AS TotalStoc
FROM TestMagazineProduse MP
GROUP BY MP.IdMagazin;


INSERT INTO Views (Nume) VALUES 
('View_TestCategorii'),
('View_TestProduseCategorii'),
('View_TestStocuriPeMagazin');

INSERT INTO TestViews (TestId, ViewId)
VALUES
(1, 1),
(1, 2),
(1, 3);



-- Procedura de test

CREATE OR ALTER PROCEDURE RulareTest @TestId INT
AS
BEGIN
    DECLARE @StartTest DATETIME = GETDATE();
    DECLARE @EndTest DATETIME;

    INSERT INTO TestRuns(TestId, StartAt, Descriere)
    VALUES (@TestId, @StartTest, 'Rulare automata pentru testul ' + CAST(@TestId AS VARCHAR));

    DECLARE @TestRunId INT = SCOPE_IDENTITY();

    -- 1. DELETE tabele in ordine descrescatoare
    DECLARE @TableName NVARCHAR(100), @TableId INT;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE cur CURSOR FOR
    SELECT T.Nume, T.TableId
    FROM TestTables TT
    JOIN Tables T ON TT.TableId = T.TableId
    WHERE TT.TestId = @TestId
    ORDER BY TT.Position DESC;

    OPEN cur;
    FETCH NEXT FROM cur INTO @TableName, @TableId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = 'DELETE FROM ' + QUOTENAME(@TableName);
        EXEC sp_executesql @sql;

        FETCH NEXT FROM cur INTO @TableName, @TableId;
    END
    CLOSE cur; DEALLOCATE cur;

    -- 2. INSERT tabele in ordine crescatoare
    DECLARE @NoOfRows INT;
    DECLARE cur2 CURSOR FOR
    SELECT T.Nume, T.TableId, TT.NoOfRows
    FROM TestTables TT
    JOIN Tables T ON TT.TableId = T.TableId
    WHERE TT.TestId = @TestId
    ORDER BY TT.Position ASC;

    OPEN cur2;
    FETCH NEXT FROM cur2 INTO @TableName, @TableId, @NoOfRows;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @StartTab DATETIME = GETDATE();
		DECLARE @i INT = 1;
        IF @TableName = 'TestCategorii'
        BEGIN
            SET @i = 1;
            WHILE @i <= @NoOfRows
            BEGIN
                INSERT INTO TestCategorii(Nume) VALUES ('Cat_' + CAST(@i AS VARCHAR));
                SET @i += 1;
            END
        END

		IF @TableName = 'TestProduse'
		BEGIN
			SET @i = 1;
			WHILE @i <= @NoOfRows
			BEGIN
				INSERT INTO TestProduse(Nume, Pret, IdCategorie)
				VALUES ('Prod_' + CAST(@i AS VARCHAR), 100 + @i, 1);  -- toate pe IdCategorie 1
				SET @i += 1;
			END
		END

		IF @TableName = 'TestMagazineProduse'
		BEGIN
			SET @i = 1;
			WHILE @i <= @NoOfRows
			BEGIN
				INSERT INTO TestMagazineProduse(IdMagazin, IdProdus, Stoc)
				VALUES (1, @i, 10 + @i);  -- presupune MagazinID = 1
				SET @i += 1;
			END
		END



        -- TODO: poti adauga blocuri similare pentru Produse, MagazineProduse etc.

        DECLARE @EndTab DATETIME = GETDATE();
        INSERT INTO TestRunTables(TestRunId, TableId, StartAt, EndAt, NoOfRows)
        VALUES (@TestRunId, @TableId, @StartTab, @EndTab, @NoOfRows);

        FETCH NEXT FROM cur2 INTO @TableName, @TableId, @NoOfRows;
    END
    CLOSE cur2; DEALLOCATE cur2;

    -- 3. EXECUTA SELECT pe view-uri
    DECLARE @ViewName NVARCHAR(100), @ViewId INT;
    DECLARE cur3 CURSOR FOR
    SELECT V.Nume, V.ViewId
    FROM TestViews TV
    JOIN Views V ON TV.ViewId = V.ViewId
    WHERE TV.TestId = @TestId;

    OPEN cur3;
    FETCH NEXT FROM cur3 INTO @ViewName, @ViewId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @StartView DATETIME = GETDATE();
        SET @sql = 'SELECT * FROM ' + QUOTENAME(@ViewName);
        EXEC sp_executesql @sql;
        DECLARE @EndView DATETIME = GETDATE();

        INSERT INTO TestRunViews(TestRunId, ViewId, StartAt, EndAt)
        VALUES (@TestRunId, @ViewId, @StartView, @EndView);

        FETCH NEXT FROM cur3 INTO @ViewName, @ViewId;
    END
    CLOSE cur3; DEALLOCATE cur3;

    SET @EndTest = GETDATE();
    UPDATE TestRuns SET EndAt = @EndTest WHERE TestRunId = @TestRunId;
END;

SELECT * FROM TestCategorii;
SELECT * FROM TestProduse;
SELECT * FROM TestMagazineProduse;

EXEC RulareTest @TestId = 1;

SELECT * FROM TestRuns