USE	MagazinDB;
GO

-- Crearea unui tabel pentru versiune:
CREATE TABLE VersiuneBD (
    VersiuneCurenta INT NOT NULL
);

-- Initializare cu versiunea 0
INSERT INTO VersiuneBD (VersiuneCurenta) VALUES (0);


-- Operatii directe

--do_proc_1: modifica tipul unei coloane
CREATE PROCEDURE do_proc_1 AS
BEGIN
    PRINT 'Modific tipul coloanei Telefon in varchar(20)';
    ALTER TABLE Clienti ALTER COLUMN Telefon VARCHAR(20);
    UPDATE VersiuneBD SET VersiuneCurenta = 1;
END;

--pentru ca eu am deja o constrangere by default trebuie sa scap de ea
--aflu numele ei si ii dau drop
/*
SELECT dc.name AS ConstraintName
FROM sys.default_constraints dc
JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE OBJECT_NAME(dc.parent_object_id) = 'MagazineProduse' AND c.name = 'Stoc';


ALTER TABLE MagazineProduse DROP CONSTRAINT DF__MagazinePr__Stoc__5165187F;
*/

--do_proc_2: adauga constrangere de valoare implicita
CREATE PROCEDURE do_proc_2 AS
BEGIN
    PRINT 'Adauga valoare implicita 0 pentru coloana Stoc in tabelul MagazineProduse';
    ALTER TABLE MagazineProduse ADD CONSTRAINT df_stoc DEFAULT 0 FOR Stoc;
    UPDATE VersiuneBD SET VersiuneCurenta = 2;
END;

--do_proc_3: creeaza un tabel
CREATE PROCEDURE do_proc_3 AS
BEGIN
    PRINT 'Creare tabel LoguriModificari';
    CREATE TABLE LoguriModificari (
        IdLog INT PRIMARY KEY IDENTITY,
        Actiune VARCHAR(100),
        DataLog DATETIME DEFAULT GETDATE()
    );
    UPDATE VersiuneBD SET VersiuneCurenta = 3;
END;

--do_proc_4: adauga un camp nou
CREATE PROCEDURE do_proc_4 AS
BEGIN
    PRINT 'Adauga coloana Nota INT in Recenzii';
    ALTER TABLE Recenzii ADD Nota INT;
    UPDATE VersiuneBD SET VersiuneCurenta = 4;
END;

--do_proc_5: adauga o cheie straina
CREATE PROCEDURE do_proc_5 AS
BEGIN
    PRINT 'Adauga FK intre Recenzii.Nota si Produse.IdProdus';
    ALTER TABLE Recenzii ADD CONSTRAINT fk_recenzie_produs FOREIGN KEY (IdProdus) REFERENCES Produse(IdProdus);
    UPDATE VersiuneBD SET VersiuneCurenta = 5;
END;


-- Operatii inverse

--undo_proc_1: revine la tipul original
CREATE PROCEDURE undo_proc_1 AS
BEGIN
    PRINT 'Revin la VARCHAR(100) pentru Telefon';
    ALTER TABLE Clienti ALTER COLUMN Telefon VARCHAR(100);
    UPDATE VersiuneBD SET VersiuneCurenta = 0;
END;

--undo_proc_2: sterge valoarea implicita
CREATE PROCEDURE undo_proc_2 AS
BEGIN
    PRINT 'Sterge constrangerea df_stoc';
    ALTER TABLE MagazineProduse DROP CONSTRAINT df_stoc;
    UPDATE VersiuneBD SET VersiuneCurenta = 1;
END;

--undo_proc_3: sterge tabelul
CREATE PROCEDURE undo_proc_3 AS
BEGIN
    PRINT 'Stergere tabel LoguriModificari';
    DROP TABLE LoguriModificari;
    UPDATE VersiuneBD SET VersiuneCurenta = 2;
END;

--undo_proc_4: sterge coloana nou adaugata
CREATE PROCEDURE undo_proc_4 AS
BEGIN
    PRINT 'Sterge coloana Nota din Recenzii';
    ALTER TABLE Recenzii DROP COLUMN Nota;
    UPDATE VersiuneBD SET VersiuneCurenta = 3;
END;

--undo_proc_5: sterge cheia straina
CREATE PROCEDURE undo_proc_5 AS
BEGIN
    PRINT 'Sterge cheia straina fk_recenzie_produs';
    ALTER TABLE Recenzii DROP CONSTRAINT fk_recenzie_produs;
    UPDATE VersiuneBD SET VersiuneCurenta = 4;
END;




-- Procedura centrala

CREATE PROCEDURE main_version_control @vers_target INT
AS
BEGIN
    DECLARE @vers_curenta INT;
    SELECT @vers_curenta = VersiuneCurenta FROM VersiuneBD;

	PRINT 'Versiunea actualã: ' + CAST(@vers_curenta AS VARCHAR);

    IF @vers_target NOT BETWEEN 0 AND 5
    BEGIN
        PRINT 'Versiune invalidã!';
        RETURN;
    END

    IF @vers_curenta = @vers_target
    BEGIN
        PRINT 'Baza de date este deja la versiunea cerutã.';
        RETURN;
    END

    WHILE @vers_curenta < @vers_target
    BEGIN
        SET @vers_curenta = @vers_curenta + 1;
        DECLARE @sql NVARCHAR(100);
        SET @sql = N'EXEC do_proc_' + CAST(@vers_curenta AS NVARCHAR(10));
        EXEC sp_executesql @sql;
    END

    WHILE @vers_curenta > @vers_target
    BEGIN
        DECLARE @sql2 NVARCHAR(100);
        SET @sql2 = N'EXEC undo_proc_' + CAST(@vers_curenta AS NVARCHAR(10));
        EXEC sp_executesql @sql2;
        SET @vers_curenta = @vers_curenta - 1;
    END

	PRINT 'Versiunea bazei de date actualizatã la: ' + CAST(@vers_target AS VARCHAR);
END;

-- VersiuneCurenta
CREATE OR ALTER PROCEDURE afiseaza_versiunea AS
BEGIN
    SELECT 'Versiunea curenta a bazei de date este: ' + CAST(VersiuneCurenta AS VARCHAR)
    FROM VersiuneBD;
END;


EXEC do_proc_1;
EXEC undo_proc_1;

EXEC do_proc_2;
EXEC undo_proc_2;

EXEC do_proc_3;
EXEC undo_proc_3;

EXEC do_proc_4;
EXEC undo_proc_4;

EXEC do_proc_5;
EXEC undo_proc_5;

EXEC afiseaza_versiunea;

EXEC main_version_control @vers_target = 0;
EXEC main_version_control @vers_target = 1;
EXEC main_version_control @vers_target = 2;
EXEC main_version_control @vers_target = 3;
EXEC main_version_control @vers_target = 4;
EXEC main_version_control @vers_target = 5;


