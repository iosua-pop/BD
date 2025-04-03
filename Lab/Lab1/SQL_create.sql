CREATE DATABASE MagazinDB;
GO
USE MagazinDB;


-- 1. Categorii
CREATE TABLE Categorii (
    IdCategorie INT PRIMARY KEY IDENTITY,
    Nume VARCHAR(100) NOT NULL
);

-- 2. Produse
CREATE TABLE Produse (
    IdProdus INT PRIMARY KEY IDENTITY,
    Nume VARCHAR(100) NOT NULL,
    Pret DECIMAL(10,2),
    IdCategorie INT NOT NULL,
    FOREIGN KEY (IdCategorie) REFERENCES Categorii(IdCategorie)
);

-- 3. Magazine
CREATE TABLE Magazine (
    IdMagazin INT PRIMARY KEY IDENTITY,
    Nume VARCHAR(100),
    Oras VARCHAR(100)
);

-- 4. Angajati
CREATE TABLE Angajati (
    IdAngajat INT PRIMARY KEY IDENTITY,
    Nume VARCHAR(100),
    Functie VARCHAR(100),
    IdMagazin INT NOT NULL,
    FOREIGN KEY (IdMagazin) REFERENCES Magazine(IdMagazin)
);

-- 5. Clienti
CREATE TABLE Clienti (
    IdClient INT PRIMARY KEY IDENTITY,
    Nume VARCHAR(100),
    Email VARCHAR(100),
	Telefon VARCHAR(100)
);

-- 6. Comenzi
CREATE TABLE Comenzi (
    IdComanda INT PRIMARY KEY IDENTITY,
    DataComanda DATE,
    IdClient INT NOT NULL,
    FOREIGN KEY (IdClient) REFERENCES Clienti(IdClient)
);

-- 7. MetodePlata
CREATE TABLE MetodePlata (
    IdMetodaPlata INT PRIMARY KEY IDENTITY,
    TipPlata VARCHAR(50)
);

-- 8. Plati ( relatie 1-1 cu comanda )
CREATE TABLE Plati (
    IdPlata INT PRIMARY KEY IDENTITY,
    Suma DECIMAL(10,2),
    DataPlata DATE,
    IdMetodaPlata INT NOT NULL,
    IdComanda INT UNIQUE NOT NULL,  
    FOREIGN KEY (IdMetodaPlata) REFERENCES MetodePlata(IdMetodaPlata),
    FOREIGN KEY (IdComanda) REFERENCES Comenzi(IdComanda)
);

-- 9. Recenzii
CREATE TABLE Recenzii (
    IdRecenzie INT PRIMARY KEY IDENTITY,
    IdClient INT NOT NULL,
    IdProdus INT NOT NULL,
    Scor INT CHECK (Scor BETWEEN 1 AND 5),
    Comentariu TEXT,
    DataRecenzie DATE,
    FOREIGN KEY (IdClient) REFERENCES Clienti(IdClient),
    FOREIGN KEY (IdProdus) REFERENCES Produse(IdProdus)
);

-- 10. MagazineProduse ( m-n intre Magazine si Produse, cu stock )
CREATE TABLE MagazineProduse (
    IdMagazin INT,
    IdProdus INT,
    Stoc INT DEFAULT 0,
    PRIMARY KEY (IdMagazin, IdProdus),
    FOREIGN KEY (IdMagazin) REFERENCES Magazine(IdMagazin),
    FOREIGN KEY (IdProdus) REFERENCES Produse(IdProdus)
);

-- 11. ComenziProduse ( m-n între Comenzi si Produse )
CREATE TABLE ComenziProduse (
    IdComanda INT,
    IdProdus INT,
    IdMagazin INT,
    Cantitate INT DEFAULT 1,
    PRIMARY KEY (IdComanda, IdProdus, IdMagazin),
    FOREIGN KEY (IdComanda) REFERENCES Comenzi(IdComanda),
    FOREIGN KEY (IdMagazin, IdProdus) REFERENCES MagazineProduse(IdMagazin, IdProdus)
);
