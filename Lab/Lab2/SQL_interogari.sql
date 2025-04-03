USE MagazinDB;
GO


-- Afiseaza produsele care costa peste 1000 RON (WHERE)
--selectie de produse premium
SELECT Nume, Pret
FROM Produse
WHERE Pret > 1000;


-- Afiseaza comenzile plasate dupa 5 mai 2024 (WHERE)
--filtrare comenzi recente
SELECT IdComanda, DataComanda, IdClient
FROM Comenzi
WHERE DataComanda > '2024-05-05';


-- Afiseaza clientii care au efectuat cel putin o comanda (WHERE, DISTINCT, 3 tabele)
--clienti activi
SELECT DISTINCT C.Nume, C.Email
FROM Clienti C
JOIN Comenzi CO ON C.IdClient = CO.IdClient;


-- Afiseaza produsele comandate in cantitate mai mare de 2 bucati (WHERE, relatie m-n)
--produse foarte cerute
SELECT P.Nume, CP.Cantitate
FROM ComenziProduse CP
JOIN Produse P ON CP.IdProdus = P.IdProdus
WHERE CP.Cantitate > 2;


-- Afiseaza platile efectuate prin metoda „Cash” (WHERE, 3 tabele)
--analiza metode plata
SELECT PL.Suma, PL.DataPlata, MP.TipPlata
FROM Plati PL
JOIN MetodePlata MP ON PL.IdMetodaPlata = MP.IdMetodaPlata
WHERE MP.TipPlata = 'Cash';


-- Numar comenzi per client (GROUP BY)
--identificare clienti activi
SELECT C.Nume, COUNT(*) AS NrComenzi
FROM Clienti C
JOIN Comenzi CO ON C.IdClient = CO.IdClient
GROUP BY C.Nume;


-- Suma totala platita per metoda de plata (GROUP BY)
--analiza celor mai folosite metode de plata
SELECT MP.TipPlata, SUM(P.Suma) AS TotalIncasari
FROM Plati P
JOIN MetodePlata MP ON P.IdMetodaPlata = MP.IdMetodaPlata
GROUP BY MP.TipPlata;


-- Categorii de produse comandate si valoarea totala a comenzilor (GROUP BY, HAVING, 3+ tabele)
--categorii performante
SELECT CAT.Nume AS Categorie, SUM(Prod.Pret * CP.Cantitate) AS TotalVanzari
FROM ComenziProduse CP
JOIN Produse Prod ON CP.IdProdus = Prod.IdProdus
JOIN Categorii CAT ON Prod.IdCategorie = CAT.IdCategorie
GROUP BY CAT.Nume
HAVING SUM(Prod.Pret * CP.Cantitate) > 500;


-- Afiseaza magazinele care au in stoc mai mult de 3 produse cu stoc > 50 (GROUP BY, HAVING, relatie m-n)
--identificare magazine bine aprovizionate
SELECT M.Nume AS Magazin, COUNT(*) AS NrProduseStoc
FROM MagazineProduse MP
JOIN Magazine M ON MP.IdMagazin = M.IdMagazin
WHERE MP.Stoc > 50
GROUP BY M.Nume
HAVING COUNT(*) > 3;


-- Afiseaza toate produsele diferite care au fost comandate (DISTINCT, 3 tabele, relatie m-n)
--raport diversitate comenzi
SELECT DISTINCT P.Nume
FROM ComenziProduse CP
JOIN Produse P ON CP.IdProdus = P.IdProdus
JOIN Comenzi C ON CP.IdComanda = C.IdComanda;
