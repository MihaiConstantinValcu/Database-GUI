--Vizualizare compusa care permite operatii LMD

--Incasarile fiecarei cofetarii

/*
DROP VIEW prod_cof_view
DROP VIEW incasari_mai
*/

CREATE VIEW prod_cof_view
AS SELECT a.id_cofetarie, a.oras, a.strada, a.numar, a.telefon,
b.suma, b.data
FROM COFETARII a join INCASARI b on (a.id_cofetarie = b.id_cofetarie)

select * from prod_cof_view


--Vizualizare complexa

--Cea mai mare incasare a fiecarei cofetarii pentru luna mai 2020

CREATE VIEW incasari_mai 
AS SELECT id_cofetarie, max(suma) as "Incasarea maxima"
FROM INCASARI
WHERE data between CONVERT(datetime,'01-05-20',5) and CONVERT(datetime,'31-05-20',5)
GROUP BY id_cofetarie

select * from incasari_mai
