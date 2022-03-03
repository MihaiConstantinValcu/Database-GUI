/*
Afisati numele angajatiilor si salariul acestora, pentru toti angajatii care au salariul mai mare de 4000 de lei brut si sunt angajati inainte de 2019
*/

select concat(a.nume,' ',a.prenume) Nume, c.salariu Salariu
	from ANGAJATI a join CONTRACTE b on (a.id_angajat = b.id_angajat)
		join OCUPATII c on (b.id_ocupatie = c.id_ocupatie)
WHERE c.salariu>4000
	and a.data_angajarii < CONVERT(datetime,'01-01-19',5)

/*
Afisati numarul de marfuri de origine vegetala pentru furnizorii care au acest numar maxim.
*/

select a.nume Furnizori, count(b.id_marfa) as "Numar marfuri"
	from FURNIZORI a join MARFURI b on (a.id_furnizor=b.id_furnizor)
WHERE b.origine = 'Vegetala'
GROUP BY a.nume
HAVING count(b.id_marfa) = (select count(id_marfa)
				from MARFURI
			WHERE origine = 'Vegetala'
			GROUP BY id_furnizor
			ORDER BY count(id_marfa) DESC
			offset 0 rows
			fetch next 1 rows only)
