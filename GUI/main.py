import tkinter.ttk as ttk

import pyodbc
from Functions import *

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=LAPTOP\SQLEXPRESS;'
                      'Database=LantCofetariiDB;'
                      'Trusted_Connection=yes;')

cursor = conn.cursor()
master = Tk()
master.title("Managementul unui lant de cofetarii")
mainframe = LabelFrame(master, text="Actiune pe tabele")
mainframe.pack(padx=80, pady=(20, 0), fill="none", expand="no")

option = StringVar(master)

option_list = ["Angajati", "Cofetarii", "Contracte",
               "Furnizori", "Incasari", "Marfuri",
               "Meniuri", "Ocupatii", "Produse",
               "Retete"]
option.set("Tables")

dropMenu = OptionMenu(mainframe, option, *option_list)
Label(mainframe, text="Alege un tabel").grid(row=1, column=1, padx=(30, 5), pady=10, sticky=E)
dropMenu.grid(row=1, column=2, padx=(5, 30), pady=10, sticky=W)


def change_dropdown(*args):
    tableWindow = Tk()
    tableWindow.config(padx=10, pady=10)
    table = option.get()
    tableWindow.title(table)

    cursor.execute("SELECT * from " + table)

    columns = [column[0] for column in cursor.description]

    tree = ttk.Treeview(tableWindow, column=list(range(1, len(columns) + 1)), show='headings')

    ok = [0] * (len(columns) + 1)
    for i in range(1, len(columns) + 1):
        tree.column("#" + str(i), anchor=CENTER, stretch=True, width=130)
        action = partial(rearrange, tree, cursor, table, columns[i - 1], i, ok)
        tree.heading("#" + str(i), text=columns[i - 1], command=action)

    tree.grid(row=1, column=1, columnspan=2)

    cursor.execute("SELECT * from " + table)

    rows = cursor.fetchall()

    for i in tree.get_children():
        tree.delete(i)
    for row in rows:
        tree.insert("", END, values=list(row))

    action = partial(Update, tree, table, cursor)
    button = Button(tableWindow, text="Update", command=action)
    button.grid(row=4, column=1, sticky=E, pady=2, padx=2)

    entry = Entry(tableWindow, width=5)
    entry.grid(row=5, column=2, sticky=W, pady=2, padx=2)

    action2 = partial(Stergere, tree, table, cursor, entry)
    button2 = Button(tableWindow, text="Stergere", command=action2)
    button2.grid(row=5, column=1, sticky=E, pady=2, padx=2)

    action3 = partial(Reload, tree, table, cursor, entry)
    button3 = Button(tableWindow, text="Reload", command=action3)
    button3.grid(row=6, column=1, sticky=E, pady=2, padx=2)


option.trace('w', change_dropdown)

mainframe2 = LabelFrame(master, text="Cereri")
mainframe2.pack(padx=80, pady=(20, 20), fill="none", expand="no")


def Querry1():
    tableWindow = Tk()
    tableWindow.config(padx=10, pady=10)
    table = option.get()
    tableWindow.title("Cererea 1")

    label = Label(tableWindow,text = "Afisati numele angajatiilor si salariul acestora, pentru toti angajatii care au "
                                     "\nsalariul mai mare de 4000 de lei brut si sunt angajati inainte de 2019")
    label.grid(row=0, column=1,columnspan=2,padx=10,pady=(0,10))

    cursor.execute("""select concat(a.nume,' ',a.prenume) Nume, c.salariu Salariu
	                    from ANGAJATI a join CONTRACTE b on (a.id_angajat = b.id_angajat)
		                join OCUPATII c on (b.id_ocupatie = c.id_ocupatie)
                        WHERE c.salariu>4000
	                    and a.data_angajarii < CONVERT(datetime,'01-01-19',5)""")

    columns = [column[0] for column in cursor.description]

    tree = ttk.Treeview(tableWindow, column=list(range(1, len(columns) + 1)), show='headings')

    for i in range(1, len(columns) + 1):
        tree.column("#" + str(i), anchor=CENTER, stretch=True, width=130)
        tree.heading("#" + str(i), text=columns[i - 1])

    tree.grid(row=1, column=1, columnspan=2)

    cursor.execute("""select concat(a.nume,' ',a.prenume) Nume, c.salariu Salariu
    	            from ANGAJATI a join CONTRACTE b on (a.id_angajat = b.id_angajat)
    		        join OCUPATII c on (b.id_ocupatie = c.id_ocupatie)
                    WHERE c.salariu>4000
    	            and a.data_angajarii < CONVERT(datetime,'01-01-19',5)""")

    rows = cursor.fetchall()

    for i in tree.get_children():
        tree.delete(i)
    for row in rows:
        tree.insert("", END, values=list(row))

def Querry2():
    tableWindow = Tk()
    tableWindow.config(padx=10, pady=10)
    table = option.get()
    tableWindow.title("Cererea 2")

    label = Label(tableWindow,text = "Afisati numarul de marfuri de origine vegetala pentru furnizorii care au acest numar maxim.")
    label.grid(row=0, column=1,columnspan=2,padx=10,pady=(0,10))

    cursor.execute("""select a.nume Furnizori, count(b.id_marfa) as "Numar marfuri"
    	                    from FURNIZORI a join MARFURI b on (a.id_furnizor=b.id_furnizor)
                        WHERE b.origine = 'Vegetala'
                        GROUP BY a.nume
                        HAVING count(b.id_marfa) = (select count(id_marfa)
    								    from MARFURI
    							    WHERE origine = 'Vegetala'
    							    GROUP BY id_furnizor
    							    ORDER BY count(id_marfa) DESC
    							    offset 0 rows
    							    fetch next 1 rows only)""")

    columns = [column[0] for column in cursor.description]

    tree = ttk.Treeview(tableWindow, column=list(range(1, len(columns) + 1)), show='headings')

    for i in range(1, len(columns) + 1):
        tree.column("#" + str(i), anchor=CENTER, stretch=True, width=130)
        tree.heading("#" + str(i), text=columns[i - 1])

    tree.grid(row=1, column=1, columnspan=2)

    cursor.execute("""select a.nume Furnizori, count(b.id_marfa) as "Numar marfuri"
	                    from FURNIZORI a join MARFURI b on (a.id_furnizor=b.id_furnizor)
                    WHERE b.origine = 'Vegetala'
                    GROUP BY a.nume
                    HAVING count(b.id_marfa) = (select count(id_marfa)
								    from MARFURI
							    WHERE origine = 'Vegetala'
							    GROUP BY id_furnizor
							    ORDER BY count(id_marfa) DESC
							    offset 0 rows
							    fetch next 1 rows only)""")

    rows = cursor.fetchall()

    for i in tree.get_children():
        tree.delete(i)
    for row in rows:
        tree.insert("", END, values=list(row))


querry1 = Button(mainframe2, text="Cererea 1",
                 command=Querry1).pack(padx=80, pady=(5, 5))
querry2 = Button(mainframe2, text="Cererea 2",
                 command=Querry2).pack(padx=80, pady=(0, 10))

def View1():
    tableWindow = Tk()
    tableWindow.config(padx=10, pady=10)
    table = option.get()
    tableWindow.title("Vizualizarea 1")

    label = Label(tableWindow,text = "Incasarile fiecarei cofetarii")
    label.grid(row=0, column=1,columnspan=2,padx=10,pady=(0,10))

    cursor.execute("select * from prod_cof_view")

    columns = [column[0] for column in cursor.description]

    tree = ttk.Treeview(tableWindow, column=list(range(1, len(columns) + 1)), show='headings')

    for i in range(1, len(columns) + 1):
        tree.column("#" + str(i), anchor=CENTER, stretch=True, width=130)
        tree.heading("#" + str(i), text=columns[i - 1])

    tree.grid(row=1, column=1, columnspan=2)

    cursor.execute("select * from prod_cof_view")

    rows = cursor.fetchall()

    for i in tree.get_children():
        tree.delete(i)
    for row in rows:
        tree.insert("", END, values=list(row))

def View2():
    tableWindow = Tk()
    tableWindow.config(padx=10, pady=10)
    table = option.get()
    tableWindow.title("Vizualizarea 2")

    label = Label(tableWindow,text = "Cea mai mare incasare a fiecarei cofetarii pentru luna mai 2020")
    label.grid(row=0, column=1,columnspan=2,padx=10,pady=(0,10))

    cursor.execute("select * from incasari_mai")

    columns = [column[0] for column in cursor.description]

    tree = ttk.Treeview(tableWindow, column=list(range(1, len(columns) + 1)), show='headings')

    for i in range(1, len(columns) + 1):
        tree.column("#" + str(i), anchor=CENTER, stretch=True, width=130)
        tree.heading("#" + str(i), text=columns[i - 1])

    tree.grid(row=1, column=1, columnspan=2)

    cursor.execute("select * from incasari_mai")

    rows = cursor.fetchall()

    for i in tree.get_children():
        tree.delete(i)
    for row in rows:
        tree.insert("", END, values=list(row))



mainframe3 = LabelFrame(master, text="Vizualizari")
mainframe3.pack(padx=80, pady=(10, 40), fill="none", expand="no")

view1 = Button(mainframe3, text="Vizualizarea 1",
                 command=View1).pack(padx=80, pady=(5, 5))
view1 = Button(mainframe3, text="Vizualizarea 2",
                 command=View2).pack(padx=80, pady=(0, 10))

master.mainloop()
