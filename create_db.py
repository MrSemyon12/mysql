import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="password"   
)

mycursor = db.cursor()

script = [
    "DROP DATABASE IF EXISTS `filmoteka`",
    "CREATE DATABASE `filmoteka` DEFAULT CHARACTER SET utf8mb4",   
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`film` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `title` VARCHAR(255) NOT NULL, `year` YEAR NULL, `rate` DECIMAL(3,1) NULL, PRIMARY KEY (`id`))",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`director` (`name` VARCHAR(255) NOT NULL, PRIMARY KEY (`name`))",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`category` (`name` VARCHAR(25) NOT NULL, PRIMARY KEY (`name`))",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`country` (`name` VARCHAR(25) NOT NULL, PRIMARY KEY (`name`))",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`synonims` (`name` VARCHAR(25) NOT NULL, `country_name` VARCHAR(25) NOT NULL, PRIMARY KEY (`name`, `country_name`), INDEX `fk_synonims_country1_idx` (`country_name` ASC) VISIBLE, CONSTRAINT `fk_synonims_country1` FOREIGN KEY (`country_name`) REFERENCES `filmoteka`.`country` (`name`) ON DELETE CASCADE ON UPDATE CASCADE)",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`subscription` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `price` INT UNSIGNED NOT NULL, `valid_until` DATE NOT NULL, PRIMARY KEY (`id`))",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`favourites` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `film_id` INT UNSIGNED NOT NULL, PRIMARY KEY (`id`, `film_id`), INDEX `fk_favourites_film1_idx` (`film_id` ASC) VISIBLE, CONSTRAINT `fk_favourites_film1` FOREIGN KEY (`film_id`) REFERENCES `filmoteka`.`film` (`id`) ON DELETE CASCADE ON UPDATE CASCADE)",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`user` (`login` VARCHAR(25) NOT NULL, `password` VARCHAR(25) NOT NULL, `subscription_id` INT UNSIGNED NULL, `favourites_id` INT UNSIGNED NULL, PRIMARY KEY (`login`), INDEX `fk_user_subscription1_idx` (`subscription_id` ASC) VISIBLE, INDEX `fk_user_favourites1_idx` (`favourites_id` ASC) VISIBLE, CONSTRAINT `fk_user_subscription1` FOREIGN KEY (`subscription_id`) REFERENCES `filmoteka`.`subscription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT `fk_user_favourites1` FOREIGN KEY (`favourites_id`) REFERENCES `filmoteka`.`favourites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE)",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`film_has_director` (`film_id` INT UNSIGNED NOT NULL, `director_name` VARCHAR(255) NOT NULL, PRIMARY KEY (`film_id`, `director_name`), INDEX `fk_film_has_director_director1_idx` (`director_name` ASC) VISIBLE, INDEX `fk_film_has_director_film1_idx` (`film_id` ASC) VISIBLE, CONSTRAINT `fk_film_has_director_film1` FOREIGN KEY (`film_id`) REFERENCES `filmoteka`.`film` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT `fk_film_has_director_director1` FOREIGN KEY (`director_name`) REFERENCES `filmoteka`.`director` (`name`) ON DELETE CASCADE ON UPDATE CASCADE)",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`film_has_category` (`film_id` INT UNSIGNED NOT NULL, `category_name` VARCHAR(25) NOT NULL, PRIMARY KEY (`film_id`, `category_name`), INDEX `fk_film_has_category_category1_idx` (`category_name` ASC) VISIBLE, INDEX `fk_film_has_category_film1_idx` (`film_id` ASC) VISIBLE, CONSTRAINT `fk_film_has_category_film1` FOREIGN KEY (`film_id`) REFERENCES `filmoteka`.`film` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT `fk_film_has_category_category1` FOREIGN KEY (`category_name`) REFERENCES `filmoteka`.`category` (`name`) ON DELETE CASCADE ON UPDATE CASCADE)",
    "CREATE TABLE IF NOT EXISTS `filmoteka`.`film_has_country` (`film_id` INT UNSIGNED NOT NULL, `country_name` VARCHAR(25) NOT NULL, PRIMARY KEY (`film_id`, `country_name`), INDEX `fk_film_has_country_country1_idx` (`country_name` ASC) VISIBLE, INDEX `fk_film_has_country_film1_idx` (`film_id` ASC) VISIBLE, CONSTRAINT `fk_film_has_country_film1` FOREIGN KEY (`film_id`) REFERENCES `filmoteka`.`film` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT `fk_film_has_country_country1` FOREIGN KEY (`country_name`) REFERENCES `filmoteka`.`country` (`name`) ON DELETE CASCADE ON UPDATE CASCADE)",
    
]

for command in script:    
    mycursor.execute(command)

print("Successful creation!")