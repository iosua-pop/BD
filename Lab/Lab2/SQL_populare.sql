USE MagazinDB;
GO

-- CATEGORII
INSERT INTO Categorii (Nume) VALUES
('Alimente'),
('Haine'),
('Jucarii'),
('Electronice'),
('Mobila'),
('Sport'),
('Gradina'),
('Ingrijire Personala'),
('Auto'),
('Carti');

SELECT * FROM Categorii;

-- PRODUSE
INSERT INTO Produse (Nume, Pret, IdCategorie) VALUES
('Ulei de masline extra virgin', 9.97, 1),
('Lapte bio 1L', 12.65, 1),
('Paine integrala', 12.11, 1),
('Paste Barilla', 26.42, 1),
('Tricou Adidas', 93.94, 2),
('Jacheta de iarna', 128.75, 2),
('Blugi Levi`s', 59.59, 2),
('Camasa eleganta', 114.28, 2),
('Masinuta LEGO', 116.55, 3),
('Papusa Barbie', 124.17, 3),
('Puzzle 1000 piese', 190.95, 3),
('Set constructii magnetice', 117.62, 3),
('Telefon iPhone 14', 3068.86, 4),
('Televizor Samsung 55''', 1399.77, 4),
('Laptop Lenovo ThinkPad', 873.0, 4),
('Casti wireless JBL', 1351.17, 4),
('Scaun ergonomic', 268.01, 5),
('Birou alb modern', 289.0, 5),
('Dulap dormitor', 485.21, 5),
('Comoda cu sertare', 571.27, 5),
('Bicicleta MTB', 892.62, 6),
('Racheta de tenis Wilson', 847.86, 6),
('Minge fotbal Adidas', 838.29, 6),
('Trening Nike', 253.38, 6),
('Foarfeca de gradina', 500.99, 7),
('Lampa solara LED', 159.48, 7),
('Masina tuns iarba', 298.33, 7),
('Hamac pentru terasa', 205.95, 7),
('Periuta electrica Oral-B', 131.57, 8),
('Crema hidratanta Nivea', 74.99, 8),
('Sampon Head & Shoulders', 12.65, 8),
('Balsam buze Neutrogena', 131.83, 8),
('Odorizant auto', 289.74, 9),
('Set stergatoare parbriz', 52.09, 9),
('Camera video auto', 274.43, 9),
('Spray curatare bord', 54.79, 9),
('Dune - Frank Herbert', 93.41, 10),
('1984 - George Orwell', 93.18, 10),
('Pride and Prejudice', 39.29, 10),
('Harry Potter vol. 1', 47.7, 10);

SELECT * FROM Produse;

-- MAGAZINE
INSERT INTO Magazine (Nume, Oras) VALUES
('Magazin Central', 'Bucuresti'),
('Kaufland', 'Cluj');

SELECT * FROM Magazine;

-- ANGAJATI
INSERT INTO Angajati (Nume, Functie, IdMagazin) VALUES
('Ion', 'Vanzator', 1),
('Maria', 'Casier', 1),
('Vlad', 'Vanzator', 1),
('Andreea', 'Vanzator', 1),
('George', 'Manager', 1),
('Elena', 'Casier', 2),
('Alex', 'Casier', 2),
('Diana', 'Manager', 2),
('Florin', 'Vanzator', 2),
('Ioana', 'Manager', 2);

SELECT * FROM Angajati;

-- CLIENTI
INSERT INTO Clienti (Nume, Email, Telefon) VALUES
('Andrei Popescu', 'andrei.popescu@mail.com', '0744547649'),
('Ioana Ionescu', 'ioana.ionescu@mail.com', '0743293173'),
('Mihai Georgescu', 'mihai.georgescu@mail.com', '0730221362'),
('Elena Stan', 'elena.stan@mail.com', '0729093981'),
('Radu Dumitrescu', 'radu.dumitrescu@mail.com', '0724336114'),
('Maria Marin', 'maria.marin@mail.com', '0746564160'),
('Cristian Enache', 'cristian.enache@mail.com', '0715871160'),
('Alexandra Tudor', 'alexandra.tudor@mail.com', '0754492795'),
('Vlad Nistor', 'vlad.nistor@mail.com', '0787544739'),
('Ana Neagu', 'ana.neagu@mail.com', '0794438038');

SELECT * FROM Clienti;

-- COMENZI
INSERT INTO Comenzi (DataComanda, IdClient) VALUES
('2024-05-02', 7),
('2024-05-03', 8),
('2024-05-04', 2),
('2024-05-05', 4),
('2024-05-06', 7),
('2024-05-07', 8),
('2024-05-08', 3),
('2024-05-09', 10),
('2024-05-10', 10),
('2024-05-11', 3);

SELECT * FROM Comenzi;

-- METODE PLATA
INSERT INTO MetodePlata (TipPlata) VALUES
('Card'),
('Cash');

SELECT * FROM MetodePlata;

-- MAGAZINEPRODUSE
INSERT INTO MagazineProduse (IdMagazin, IdProdus, Stoc) VALUES
(1, 11, 98),
(1, 34, 27),
(1, 10, 69),
(1, 23, 28),
(1, 3, 23),
(1, 32, 76),
(1, 26, 16),
(1, 40, 18),
(1, 8, 57),
(1, 4, 49),
(1, 16, 55),
(1, 24, 16),
(1, 7, 40),
(1, 36, 78),
(1, 31, 68),
(1, 17, 93),
(1, 35, 67),
(1, 15, 43),
(1, 21, 54),
(1, 12, 11),
(2, 2, 71),
(2, 9, 73),
(2, 37, 40),
(2, 39, 16),
(2, 20, 10),
(2, 28, 77),
(2, 14, 91),
(2, 18, 22),
(2, 6, 18),
(2, 30, 19),
(2, 1, 17),
(2, 29, 85),
(2, 13, 20),
(2, 27, 65),
(2, 38, 89),
(2, 33, 79),
(2, 5, 33),
(2, 22, 19),
(2, 25, 86),
(2, 19, 91);

SELECT * FROM MagazineProduse;

-- RECENZII
INSERT INTO Recenzii (IdClient, IdProdus, Scor, Comentariu, DataRecenzie) VALUES
(5, 29, 4, 'Produs excelent, recomand!', '2024-05-19'),
(9, 8, 4, 'Calitate buna pentru pretul platit.', '2024-05-24'),
(7, 4, 1, 'Nu sunt foarte multumit, dar merge.', '2024-05-28'),
(6, 36, 3, 'Livrare rapida si ambalaj ok.', '2024-05-08'),
(2, 36, 3, 'Exact ca in descriere.', '2024-05-09'),
(2, 14, 3, 'Material slab, se putea mai bine.', '2024-05-31'),
(3, 12, 4, 'Foarte util, îl folosesc zilnic.', '2024-05-02'),
(3, 39, 1, 'L-am returnat, nu a fost ce ma asteptam.', '2024-05-31'),
(1, 24, 1, 'Super calitate! Multumit.', '2024-05-14'),
(10, 40, 3, 'Ambalaj deteriorat la livrare.', '2024-05-02'),
(6, 20, 4, 'Perfect pentru nevoile mele.', '2024-05-14'),
(8, 29, 2, 'Un produs decent, fara probleme.', '2024-05-04'),
(5, 22, 1, 'Design frumos si functional.', '2024-05-07'),
(2, 38, 1, 'Pret cam mare pentru ce ofera.', '2024-05-08'),
(1, 28, 5, 'Foarte usor de folosit.', '2024-05-14'),
(6, 15, 1, 'Lipsesc instructiunile din cutie.', '2024-05-07'),
(10, 26, 1, 'Un cadou perfect!', '2024-05-27'),
(6, 9, 3, 'Corespunde descrierii.', '2024-05-06'),
(1, 1, 5, 'Am cumparat mai multe bucati, toate ok.', '2024-05-07'),
(10, 29, 2, 'Recomand cu incredere.', '2024-05-20');

SELECT * FROM Recenzii;

-- PLATI
INSERT INTO Plati (Suma, DataPlata, IdMetodaPlata, IdComanda) VALUES
(1569.03, '2024-05-02', 1, 1),
(1900.82, '2024-05-03', 2, 2),
(381.9, '2024-05-04', 1, 3),
(42.56, '2024-05-05', 2, 4),
(1245.48, '2024-05-06', 2, 5),
(3267.33, '2024-05-07', 2, 6),
(1014.63, '2024-05-08', 2, 7),
(6567.7, '2024-05-09', 1, 8),
(2626.15, '2024-05-10', 1, 9),
(6008.48, '2024-05-11', 2, 10);

SELECT * FROM Plati;

-- COMENZIPRODUSE
INSERT INTO ComenziProduse (IdComanda, IdProdus, IdMagazin, Cantitate) VALUES
(1, 19, 2, 2),
(1, 2, 2, 1),
(1, 12, 1, 3),
(1, 9, 2, 2),
(2, 25, 2, 3),
(2, 12, 1, 1),
(2, 37, 2, 3),
(3, 11, 1, 2),
(4, 1, 2, 3),
(4, 31, 1, 1),
(5, 21, 1, 1),
(5, 12, 1, 3),
(6, 13, 2, 1),
(6, 3, 1, 1),
(6, 38, 2, 2),
(7, 31, 1, 1),
(7, 25, 2, 2),
(8, 12, 1, 1),
(8, 4, 1, 3),
(8, 9, 2, 2),
(8, 13, 2, 2),
(9, 10, 1, 1),
(9, 20, 2, 1),
(9, 40, 1, 3),
(9, 27, 2, 3),
(9, 21, 1, 1),
(10, 25, 2, 1),
(10, 14, 2, 2),
(10, 22, 2, 3),
(10, 36, 1, 3);

SELECT * FROM ComenziProduse;

-- Rezultatul Seedului
SELECT * FROM Categorii;
SELECT * FROM Produse;
SELECT * FROM Magazine;
SELECT * FROM Angajati;
SELECT * FROM Clienti;
SELECT * FROM Comenzi;
SELECT * FROM MetodePlata;
SELECT * FROM Plati;
SELECT * FROM Recenzii;
SELECT * FROM MagazineProduse;
SELECT * FROM ComenziProduse;