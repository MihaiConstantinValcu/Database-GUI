/*
DROP TABLE Incasari;
DROP TABLE Contracte;
DROP TABLE Ocupatii;
DROP TABLE Angajati;
DROP TABLE Retete;
DROP TABLE Marfuri;
DROP TABLE Furnizori;
DROP TABLE Meniuri;
DROP TABLE Produse;
DROP TABLE Cofetarii;

DROP SEQUENCE cofetarii_seq;
DROP SEQUENCE incasari_seq;
DROP SEQUENCE angajati_seq;
DROP SEQUENCE contracte_seq;
DROP SEQUENCE ocupatii_seq;
DROP SEQUENCE meniuri_seq;
DROP SEQUENCE produse_seq;
DROP SEQUENCE retete_seq;
DROP SEQUENCE marfuri_seq;
DROP SEQUENCE furnizori_seq;
*/

CREATE TABLE COFETARII(
	id_cofetarie INT PRIMARY KEY,
	oras varchar(30) CONSTRAINT nn_cof_oras NOT NULL,
	strada varchar(30) CONSTRAINT nn_cof_strada NOT NULL,
	numar varchar(10) CONSTRAINT nn_cof_numar NOT NULL,
	telefon varchar(12) CONSTRAINT nn_cof_telefon NOT NULL,
	CONSTRAINT ck_cof_oras CHECK(oras in ('Ploiesti', 'Campina', 'Azuga', 'Baicoi', 'Boldesti-Scaeni', 'Breaza', 'Busteni', 'Comarnic', 'Mizil', 'Plopeni', 'Sinaia', 'Slanic', 'Urlati', 'Valenii de Munte')),
	CONSTRAINT ck_cof_telefon CHECK (len(telefon) in (10,12)),
	CONSTRAINT un_cof_telefon UNIQUE(telefon)
)

CREATE TABLE INCASARI(
	id_incasare INT PRIMARY KEY,
	id_cofetarie INT CONSTRAINT nn_inc_id_cofetarie NOT NULL,
	suma NUMERIC(10,2) CONSTRAINT nn_inca_suma NOT NULL,
	data DATE CONSTRAINT nn_inca_date NOT NULL,
	CONSTRAINT fk_inc_id_cofetarie FOREIGN KEY(id_cofetarie) REFERENCES Cofetarii(id_cofetarie)
		ON DELETE CASCADE,
	CONSTRAINT ck_inc_suma CHECK(suma>0)
)

CREATE TABLE ANGAJATI(
	id_angajat INT PRIMARY KEY,
	id_cofetarie INT CONSTRAINT nn_id_cofetarie NOT NULL,
	nume varchar(30) CONSTRAINT nn_nume NOT NULL,
	prenume varchar(30) CONSTRAINT nn_prenume NOT NULL,
	telefon varchar(12) CONSTRAINT nn_telefon NOT NULL,
	data_angajarii DATE CONSTRAINT nn_data_angajarii NOT NULL,
	CONSTRAINT fk_ang_id_cofetarie FOREIGN KEY(id_cofetarie) REFERENCES Cofetarii(id_cofetarie)
		ON DELETE CASCADE,
	CONSTRAINT un_ang_telefon UNIQUE(telefon),
	CONSTRAINT ck_ang_telefon CHECK (len(telefon) in (10,12))
)

CREATE TABLE OCUPATII(
	id_ocupatie INT PRIMARY KEY,
	titlu varchar(30) CONSTRAINT nn_oc_titlu NOT NULL,
	salariu NUMERIC(7,2) CONSTRAINT nn_oc_salariu DEFAULT 2300,
	CONSTRAINT ck_oc_salariu CHECK(salariu>=2300)
)

CREATE TABLE CONTRACTE(
	id_contract INT PRIMARY KEY,
	id_angajat INT CONSTRAINT nn_id_angajat NOT NULL,
	id_ocupatie INT CONSTRAINT nn_id_ocupatie NOT NULL,
	perioada_contractuala varchar(30) CONSTRAINT nn_perioada_contractuala NOT NULL DEFAULT 'Perioada nedeterminata',
	CONSTRAINT fk_con_id_angajat FOREIGN KEY(id_angajat) REFERENCES Angajati(id_angajat)
		ON DELETE CASCADE,
	CONSTRAINT fk_con_id_cofetarie FOREIGN KEY(id_ocupatie) REFERENCES Ocupatii(id_ocupatie)
		ON DELETE CASCADE

)

CREATE TABLE PRODUSE(
	id_produs INT PRIMARY KEY,
	denumire varchar(30) CONSTRAINT nn_prod_denumire NOT NULL,
	pret NUMERIC(5,2) CONSTRAINT nn_prod_pret NOT NULL,
	proteine NUMERIC(3,1) CONSTRAINT nn_prod_proteine NOT NULL DEFAULT 0,
	glucide NUMERIC(3,1) CONSTRAINT nn_prod_glucide NOT NULL DEFAULT 0,
	lipide NUMERIC(3,1) CONSTRAINT nn_prod_lipide NOT NULL DEFAULT 0,
	CONSTRAINT ck_prod_macro CHECK(proteine>=0 and glucide >=0 and lipide >=0 and proteine+glucide+lipide<=100),
	CONSTRAINT ck_prod_pret CHECK(pret>0),
	CONSTRAINT un_prod_denumire UNIQUE(denumire)
)

CREATE TABLE MENIURI(
	id_continutMeniu INT PRIMARY KEY,
	id_produs INT CONSTRAINT nn_men_id_produs NOT NULL,
	id_cofetarie INT CONSTRAINT  nn_men_id_cofetarie NOT NULL,
	stoc INT CONSTRAINT nn_men_stoc NOT NULL,
	CONSTRAINT fk_men_id_produs FOREIGN KEY(id_produs) REFERENCES Produse(id_produs)
		ON DELETE CASCADE,
	CONSTRAINT fk_men_id_cofetarie FOREIGN KEY(id_cofetarie) REFERENCES Cofetarii(id_cofetarie)
		ON DELETE CASCADE,
	CONSTRAINT ck_men_stoc CHECK(stoc>0)
)

CREATE TABLE FURNIZORI(
	id_furnizor INT PRIMARY KEY,
	nume varchar(30) CONSTRAINT nn_fur_nume NOT NULL,
	telefon varchar(12) CONSTRAINT nn_fur_telefon NOT NULL,
	judet varchar(30) CONSTRAINT nn_jfur_udet NOT NULL,
	oras varchar(30) CONSTRAINT nn_fur_judet NOT NULL,
	strada varchar(30) CONSTRAINT nn_fur_strada NOT NULL,
	numar varchar(10) CONSTRAINT nn_fur_numar NOT NULL,
	email varchar(50) CONSTRAINT nn_fur_email NOT NULL,
	CONSTRAINT un_fur_nume UNIQUE(nume),
	CONSTRAINT un_fur_telefon UNIQUE(telefon),
	CONSTRAINT un_fur_email UNIQUE(email),
	CONSTRAINT ck_fur_telefon CHECK (len(telefon) in (10,12))
)

CREATE TABLE MARFURI(
	id_marfa INT PRIMARY KEY,
	id_furnizor INT CONSTRAINT nn_mar_id_furnizor NOT NULL,
	denumire varchar(30) CONSTRAINT nn_mar_denumire NOT NULL,
	origine varchar(30) CONSTRAINT nn_mar_origine NOT NULL DEFAULT 'animala',
	CONSTRAINT fk_mar_id_furnizor FOREIGN KEY(id_furnizor) REFERENCES Furnizori(id_furnizor)
		ON DELETE CASCADE,
	CONSTRAINT un_mar_denumire UNIQUE(denumire),
	CONSTRAINT ck_mar_origine CHECK(origine in ('animala','vegetala'))
)

CREATE TABLE RETETE(
	id_ingredient INT PRIMARY KEY,
	id_produs INT CONSTRAINT nn_ret_id_produs NOT NULL,
	id_marfa INT CONSTRAINT nn_ret_id_marfa NOT NULL,
	cantitate INT CONSTRAINT nn_ret_cantitate NOT NULL,
	CONSTRAINT fk_ret_id_produs FOREIGN KEY(id_produs) REFERENCES Produse(id_produs)
		ON DELETE CASCADE,
	CONSTRAINT fk_ret_id_marfa FOREIGN KEY(id_marfa) REFERENCES Marfuri(id_marfa)
		ON DELETE CASCADE,
	CONSTRAINT ck_ret_cantitate CHECK(cantitate>0)
)

CREATE SEQUENCE cofetarii_seq start with 1 increment by 1;
CREATE SEQUENCE incasari_seq start with 1 increment by 1;
CREATE SEQUENCE angajati_seq start with 1 increment by 1;
CREATE SEQUENCE contracte_seq start with 1 increment by 1;
CREATE SEQUENCE ocupatii_seq start with 1 increment by 1;
CREATE SEQUENCE meniuri_seq start with 1 increment by 1;
CREATE SEQUENCE produse_seq start with 1 increment by 1;
CREATE SEQUENCE retete_seq start with 1 increment by 1;
CREATE SEQUENCE marfuri_seq start with 1 increment by 1;
CREATE SEQUENCE furnizori_seq start with 1 increment by 1;

INSERT INTO Cofetarii(id_cofetarie, oras, strada, numar, telefon)
VALUES
(NEXT VALUE FOR cofetarii_seq,'Ploiesti', 'Grivitei', '54-56','+40727167257'),
(NEXT VALUE FOR cofetarii_seq,'Campina', 'Kogalniceanu', '18','+40773239753'),
(NEXT VALUE FOR cofetarii_seq,'Sinaia', 'Libertatii', '43','+40772576572'),
(NEXT VALUE FOR cofetarii_seq,'Ploiesti', 'Tudor Vladimirescu', '12-13','+40785808538'),
(NEXT VALUE FOR cofetarii_seq,'Plopeni', 'Tineretului', '55','+40789587980')

INSERT INTO Incasari(id_incasare, id_cofetarie, suma, data)
VALUES
(NEXT VALUE FOR incasari_seq, 1, 100050, CONVERT(datetime,'01-04-20',5)),
(NEXT VALUE FOR incasari_seq, 1, 120000, CONVERT(datetime,'01-05-20',5)),
(NEXT VALUE FOR incasari_seq, 2, 12500, CONVERT(datetime,'01-04-20',5)),
(NEXT VALUE FOR incasari_seq, 2, 30300, CONVERT(datetime,'01-05-20',5)),
(NEXT VALUE FOR incasari_seq, 3, 16000, CONVERT(datetime,'01-04-20',5)),
(NEXT VALUE FOR incasari_seq, 3, 18990, CONVERT(datetime,'01-05-20',5)),
(NEXT VALUE FOR incasari_seq, 4, 18700, CONVERT(datetime,'01-04-20',5)),
(NEXT VALUE FOR incasari_seq, 4, 56850, CONVERT(datetime,'01-05-20',5)),
(NEXT VALUE FOR incasari_seq, 5, 26830, CONVERT(datetime,'01-04-20',5)),
(NEXT VALUE FOR incasari_seq, 5, 17800, CONVERT(datetime,'01-05-20',5))

INSERT INTO Angajati(id_angajat, id_cofetarie, prenume, nume, telefon, data_angajarii)
VALUES
(NEXT VALUE FOR angajati_seq, 1, 'Gabriel', 'Stoenescu','+40725266306',CONVERT(datetime,'16-07-17',5)),
(NEXT VALUE FOR angajati_seq, 2, 'Manuel', 'Morariu', '+40728293998',CONVERT(datetime,'17-03-17',5)),
(NEXT VALUE FOR angajati_seq, 3, 'Viorela', 'Artenie', '+40734430939',CONVERT(datetime,'25-05-18',5)),
(NEXT VALUE FOR angajati_seq, 4, 'Gina', 'Epureanu', '+40737084087',CONVERT(datetime,'05-01-19',5)),
(NEXT VALUE FOR angajati_seq, 5, 'Remus', 'Tatarescu', '+40723636057',CONVERT(datetime,'06-10-17',5)),
(NEXT VALUE FOR angajati_seq, 1, 'Aurica', 'Hangeanu', '+40726901255',CONVERT(datetime,'02-10-17',5)),
(NEXT VALUE FOR angajati_seq, 2, 'Jean', 'Moldovan', '+40738192973',CONVERT(datetime,'11-04-11',5)),
(NEXT VALUE FOR angajati_seq, 3, 'Victoria', 'Porasca', '+40733780884',CONVERT(datetime,'29-12-19',5)),
(NEXT VALUE FOR angajati_seq, 4, 'Radu', 'Stefan', '+40728812378',CONVERT(datetime,'05-11-16',5)),
(NEXT VALUE FOR angajati_seq, 5, 'Calin', 'Dragomir', '+40742002366',CONVERT(datetime,'05-12-17',5)),
(NEXT VALUE FOR angajati_seq, 1, 'Ana', 'Diaconu', '+40746528748',CONVERT(datetime,'19-12-17',5)),
(NEXT VALUE FOR angajati_seq, 2, 'Alina', 'Pirvulescu', '+40732918879',CONVERT(datetime,'21-01-18',5)),
(NEXT VALUE FOR angajati_seq, 3, 'Teodora', 'Balan', '+40736010423',CONVERT(datetime,'22-02-17',5)),
(NEXT VALUE FOR angajati_seq, 4, 'Gavril', 'Cojoc', '+40727505205',CONVERT(datetime,'23-01-19',5))

INSERT INTO Ocupatii(id_ocupatie, titlu, salariu)
VALUES
(NEXT VALUE FOR ocupatii_seq, 'Cofetar',7500),
(NEXT VALUE FOR ocupatii_seq, 'Vanzator',4300),
(NEXT VALUE FOR ocupatii_seq, 'Om de serviciu',2900)

INSERT INTO Contracte(id_contract, id_angajat, id_ocupatie, perioada_contractuala)
VALUES
(NEXT VALUE FOR contracte_seq,1,1,'5 ani'),
(NEXT VALUE FOR contracte_seq,2,1,'5 ani'),
(NEXT VALUE FOR contracte_seq,3,1,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,4,1,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,5,1,'5 ani'),
(NEXT VALUE FOR contracte_seq,6,2,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,7,2,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,7,3,'5 ani'),
(NEXT VALUE FOR contracte_seq,8,2,'3 ani'),
(NEXT VALUE FOR contracte_seq,9,2,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,10,2,'5 ani'),
(NEXT VALUE FOR contracte_seq,11,3,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,12,3,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,13,3,'Perioada Nedeterminata'),
(NEXT VALUE FOR contracte_seq,14,2,'3 ani'),
(NEXT VALUE FOR contracte_seq,14,3,'3 ani')


INSERT INTO Produse(id_produs, denumire, pret, proteine, glucide, lipide)
VALUES
(NEXT VALUE FOR produse_seq, 'Savarina', 4, 3.5, 44.6, 8.7),
(NEXT VALUE FOR produse_seq, 'Amandina', 4, 6, 35.1, 9.3),
(NEXT VALUE FOR produse_seq, 'Ecler', 3, 5.9, 55.2, 10.2)

INSERT INTO Meniuri(id_continutMeniu, id_produs, id_cofetarie,stoc)
VALUES
(NEXT VALUE FOR meniuri_seq,1,1,100),
(NEXT VALUE FOR meniuri_seq,2,1,140),
(NEXT VALUE FOR meniuri_seq,2,2,150),
(NEXT VALUE FOR meniuri_seq,3,2,210),
(NEXT VALUE FOR meniuri_seq,3,3,90),
(NEXT VALUE FOR meniuri_seq,1,3,80),
(NEXT VALUE FOR meniuri_seq,1,4,105),
(NEXT VALUE FOR meniuri_seq,3,4,200),
(NEXT VALUE FOR meniuri_seq,2,5,70),
(NEXT VALUE FOR meniuri_seq,3,5,90)

INSERT INTO Furnizori(id_furnizor, nume, telefon, judet, oras, strada, numar, email)
VALUES
(NEXT VALUE FOR furnizori_seq,'GRIRO COM SRL','+40749685047','Suceava','Succeava','Zamca', '21BIS', 'contact@griro.ro' ),
(NEXT VALUE FOR furnizori_seq,'DR. OETKER RO SRL','+40757394573','Arges','Curtea de Arges','Albesti', '50', 'contact@oetker.com' ),
(NEXT VALUE FOR furnizori_seq,'COSAL SRL','+40766943568','Prahova','Paulestii Noi','Principala', '1', 'contact@cosalsrl.ro' )

INSERT INTO Marfuri(id_marfa, id_furnizor, denumire, origine)
VALUES
(NEXT VALUE FOR marfuri_seq,1,'Lapte', 'Animala'),
(NEXT VALUE FOR marfuri_seq,1,'Faina', 'Vegetala'),
(NEXT VALUE FOR marfuri_seq,2,'Zahar', 'Vegetala'),
(NEXT VALUE FOR marfuri_seq,2,'Cacao', 'Vegetala'),
(NEXT VALUE FOR marfuri_seq,2,'Esenta de vanilie', 'Vegetala'),
(NEXT VALUE FOR marfuri_seq,1,'Frisca', 'Vegetala'),
(NEXT VALUE FOR marfuri_seq,3,'Ulei', 'Vegetala')

INSERT INTO Retete(id_ingredient, id_produs, id_marfa, cantitate)
VALUES
(NEXT VALUE FOR retete_seq,1,1,300),
(NEXT VALUE FOR retete_seq,1,2,200),
(NEXT VALUE FOR retete_seq,1,3,50),
(NEXT VALUE FOR retete_seq,1,6,200),
(NEXT VALUE FOR retete_seq,1,7,20),
(NEXT VALUE FOR retete_seq,2,1,200),
(NEXT VALUE FOR retete_seq,2,2,150),
(NEXT VALUE FOR retete_seq,2,3,100),
(NEXT VALUE FOR retete_seq,2,4,100),
(NEXT VALUE FOR retete_seq,2,7,20),
(NEXT VALUE FOR retete_seq,3,1,200),
(NEXT VALUE FOR retete_seq,3,2,200),
(NEXT VALUE FOR retete_seq,3,3,40),
(NEXT VALUE FOR retete_seq,3,4,90),
(NEXT VALUE FOR retete_seq,3,6,200),
(NEXT VALUE FOR retete_seq,3,7,30)