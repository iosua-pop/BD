USE MagazinDB;
GO

-- FUNCTIE DE VALIDARE

CREATE OR ALTER FUNCTION ValideazaPret(@pret DECIMAL(10,2))
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @pret > 0 THEN 1 ELSE 0 END
END;


--CRUD: Categorii (PK simpla, fara FK)

--CREATE
CREATE OR ALTER PROCEDURE AddCategorie
    @Nume NVARCHAR(100)
AS
BEGIN
    INSERT INTO Categorii (Nume) VALUES (@Nume);
END;

--READ
CREATE OR ALTER PROCEDURE GetCategorii
AS
BEGIN
    SELECT * FROM Categorii;
END;

--UPDATE
CREATE OR ALTER PROCEDURE UpdateCategorie
    @IdCategorie INT,
    @NumeNou NVARCHAR(100)
AS
BEGIN
    UPDATE Categorii
    SET Nume = @NumeNou
    WHERE IdCategorie = @IdCategorie;
END;

--DELETE
CREATE OR ALTER PROCEDURE DeleteCategorie
    @IdCategorie INT
AS
BEGIN
    DELETE FROM Categorii WHERE IdCategorie = @IdCategorie;
END;



--CRUD: Produse (PK + FK)

--CREATE
CREATE OR ALTER PROCEDURE AddProdus
    @Nume NVARCHAR(100),
    @Pret DECIMAL(10,2),
    @IdCategorie INT,
    @Success BIT OUTPUT
AS
BEGIN
    IF dbo.ValideazaPret(@Pret) = 0
    BEGIN
        SET @Success = 0;
        RETURN;
    END

    INSERT INTO Produse (Nume, Pret, IdCategorie)
    VALUES (@Nume, @Pret, @IdCategorie);

    SET @Success = 1;
END;

--READ
CREATE OR ALTER PROCEDURE GetProduse
AS
BEGIN
    SELECT * FROM Produse;
END;

--UPDATE
CREATE OR ALTER PROCEDURE UpdateProdus
    @IdProdus INT,
    @Nume NVARCHAR(100),
    @Pret DECIMAL(10,2),
    @IdCategorie INT,
    @Success BIT OUTPUT
AS
BEGIN
    IF dbo.ValideazaPret(@Pret) = 0
    BEGIN
        SET @Success = 0;
        RETURN;
    END

    UPDATE Produse
    SET Nume = @Nume, Pret = @Pret, IdCategorie = @IdCategorie
    WHERE IdProdus = @IdProdus;

    SET @Success = 1;
END;

--DELETE
CREATE OR ALTER PROCEDURE DeleteProdus
    @IdProdus INT
AS
BEGIN
    DELETE FROM Produse WHERE IdProdus = @IdProdus;
END;



--CRUD: MagazineProduse (relatie M:N, PK compus)

--CREATE
CREATE OR ALTER PROCEDURE AddMagazinProdus
    @IdMagazin INT,
    @IdProdus INT,
    @Stoc INT
AS
BEGIN
    INSERT INTO MagazineProduse (IdMagazin, IdProdus, Stoc)
    VALUES (@IdMagazin, @IdProdus, @Stoc);
END;

--READ
CREATE OR ALTER PROCEDURE GetStocuri
AS
BEGIN
    SELECT * FROM MagazineProduse;
END;

--UPDATE
CREATE OR ALTER PROCEDURE UpdateStoc
    @IdMagazin INT,
    @IdProdus INT,
    @StocNou INT
AS
BEGIN
    UPDATE MagazineProduse
    SET Stoc = @StocNou
    WHERE IdMagazin = @IdMagazin AND IdProdus = @IdProdus;
END;

--DELETE
CREATE OR ALTER PROCEDURE DeleteMagazinProdus
    @IdMagazin INT,
    @IdProdus INT
AS
BEGIN
    DELETE FROM MagazineProduse
    WHERE IdMagazin = @IdMagazin AND IdProdus = @IdProdus;
END;




--View-uri

--View_ProduseCategorii
CREATE OR ALTER VIEW View_ProduseCategorii AS
SELECT P.IdProdus, P.Nume, P.Pret, C.Nume AS Categorie
FROM Produse P
JOIN Categorii C ON P.IdCategorie = C.IdCategorie;


--View_StocuriMagazine
CREATE OR ALTER VIEW View_StocuriMagazine AS
SELECT M.Nume AS Magazin, P.Nume AS Produs, MP.Stoc
FROM MagazineProduse MP
JOIN Magazine M ON MP.IdMagazin = M.IdMagazin
JOIN Produse P ON MP.IdProdus = P.IdProdus;




--Indexuri NON-CLUSTERED

--Index pe Produse.Nume
CREATE NONCLUSTERED INDEX idx_Produse_Nume ON Produse(Nume);


--Index pe MagazineProduse.IdMagazin
CREATE NONCLUSTERED INDEX idx_MP_Magazin ON MagazineProduse(IdMagazin);




--TESTE

--Validare
SELECT dbo.ValideazaPret(1500.00) AS Rezultat; -- returneazã 1
SELECT dbo.ValideazaPret(-50.00) AS Rezultat;  -- returneazã 0


--CRUD Categorie
EXEC AddCategorie @Nume = 'Electronice';
EXEC GetCategorii;
EXEC UpdateCategorie @IdCategorie = 11, @NumeNou = 'Electro IT';
EXEC DeleteCategorie @IdCategorie = 11;

--CRUD Produs
DECLARE @ok BIT;
EXEC AddProdus 'Laptop Lenovo', 2800.00, 2, @ok OUTPUT;
SELECT @ok AS Succes;

EXEC GetProduse;

DECLARE @ok2 BIT;
EXEC UpdateProdus 41, 'Laptop HP', 3000.00, 2, @ok2 OUTPUT;
SELECT @ok2 AS Succes;

EXEC DeleteProdus @IdProdus = 41;

--CRUD MagazinProdus
EXEC AddMagazinProdus @IdMagazin = 1, @IdProdus = 2, @Stoc = 30;
EXEC GetStocuri;
EXEC UpdateStoc @IdMagazin = 1, @IdProdus = 2, @StocNou = 50;
EXEC DeleteMagazinProdus @IdMagazin = 1, @IdProdus = 2;


--View-uri
SELECT * FROM View_ProduseCategorii;
SELECT * FROM View_StocuriMagazine;


--Indexi NON-CLUSTER
SELECT 
    t.name AS Tabel,
    ind.name AS IndexNume,
    ind.type_desc AS TipIndex,
    col.name AS Coloana
FROM 
    sys.indexes ind 
INNER JOIN 
    sys.index_columns ic ON ind.object_id = ic.object_id AND ind.index_id = ic.index_id 
INNER JOIN 
    sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id 
INNER JOIN 
    sys.tables t ON ind.object_id = t.object_id
WHERE 
    t.name IN ('Produse', 'Categorii', 'MagazineProduse');
