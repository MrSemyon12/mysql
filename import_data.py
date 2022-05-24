import csv
import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="password",
    database="filmoteka",
)

mycursor = db.cursor()   

categories = set()
directors = set()
countries = set()

synonims = {
    "США": { "Америка", "Соединённые Штаты Америки", "Штаты", "американцы" },
    "Россия" : { "Российская Федерация", "русские" },
    "Германия" : { "ФРГ", "ГДР", "немцы" },
    "СССР" : { "Советский Союз", "Советский" }
}

with open("data.csv", "r", newline="") as csvfile:
    reader = csv.DictReader(csvfile, delimiter=";")
    for row in reader:
        # film
        mycursor.execute("INSERT INTO film (title, year, rate) VALUES (%s, %s, %s)", (row["title"], row["year"], row["rate"]))
        last_id = mycursor.lastrowid

        # category & film_category
        mas = row["category"].split(", ")
        for i in mas:                      
            if i not in categories:
                categories.add(i)
                mycursor.execute("INSERT INTO category (name) VALUES (%s)", (i,))
            mycursor.execute("INSERT INTO film_has_category (category_name, film_id) VALUES (%s, %s)", (i, last_id))

        # director & film_director
        mas = row["director"].split(", ")
        for i in mas:                      
            if i not in directors:
                directors.add(i)
                mycursor.execute("INSERT INTO director (name) VALUES (%s)", (i,))
            mycursor.execute("INSERT INTO film_has_director (director_name, film_id) VALUES (%s, %s)", (i, last_id))

        # country & film_country & synonims
        mas = row["country"].split(", ")
        for i in mas:                      
            if i not in countries:
                countries.add(i)
                mycursor.execute("INSERT INTO country (name) VALUES (%s)", (i,))
                if i in synonims:
                    for syn in synonims[i]:
                        mycursor.execute("INSERT INTO synonims (name, country_name) VALUES (%s, %s)", (syn, i))
            mycursor.execute("INSERT INTO film_has_country (country_name, film_id) VALUES (%s, %s)", (i, last_id))

db.commit()
print("Successful import!")
