-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema filmoteka
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema filmoteka
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `filmoteka` DEFAULT CHARACTER SET utf8mb4 ;
USE `filmoteka` ;

-- -----------------------------------------------------
-- Table `filmoteka`.`film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`film` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `year` YEAR NULL,
  `rate` DECIMAL(3,1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`director`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`director` (
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`category` (
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`country` (
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`synonims`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`synonims` (
  `name` VARCHAR(25) NOT NULL,
  `country_name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`name`, `country_name`),
  INDEX `fk_synonims_country1_idx` (`country_name` ASC) VISIBLE,
  CONSTRAINT `fk_synonims_country1`
    FOREIGN KEY (`country_name`)
    REFERENCES `filmoteka`.`country` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`subscription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`subscription` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `price` INT UNSIGNED NOT NULL,
  `valid_until` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`favourites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`favourites` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `film_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `film_id`),
  INDEX `fk_favourites_film1_idx` (`film_id` ASC) VISIBLE,
  CONSTRAINT `fk_favourites_film1`
    FOREIGN KEY (`film_id`)
    REFERENCES `filmoteka`.`film` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`user` (
  `login` VARCHAR(25) NOT NULL,
  `password` VARCHAR(25) NOT NULL,
  `subscription_id` INT UNSIGNED NULL,
  `favourites_id` INT UNSIGNED NULL,
  PRIMARY KEY (`login`),
  INDEX `fk_user_subscription1_idx` (`subscription_id` ASC) VISIBLE,
  INDEX `fk_user_favourites1_idx` (`favourites_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_subscription1`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `filmoteka`.`subscription` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_favourites1`
    FOREIGN KEY (`favourites_id`)
    REFERENCES `filmoteka`.`favourites` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`film_has_director`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`film_has_director` (
  `film_id` INT UNSIGNED NOT NULL,
  `director_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`film_id`, `director_name`),
  INDEX `fk_film_has_director_director1_idx` (`director_name` ASC) VISIBLE,
  INDEX `fk_film_has_director_film1_idx` (`film_id` ASC) VISIBLE,
  CONSTRAINT `fk_film_has_director_film1`
    FOREIGN KEY (`film_id`)
    REFERENCES `filmoteka`.`film` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_film_has_director_director1`
    FOREIGN KEY (`director_name`)
    REFERENCES `filmoteka`.`director` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`film_has_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`film_has_category` (
  `film_id` INT UNSIGNED NOT NULL,
  `category_name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`film_id`, `category_name`),
  INDEX `fk_film_has_category_category1_idx` (`category_name` ASC) VISIBLE,
  INDEX `fk_film_has_category_film1_idx` (`film_id` ASC) VISIBLE,
  CONSTRAINT `fk_film_has_category_film1`
    FOREIGN KEY (`film_id`)
    REFERENCES `filmoteka`.`film` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_film_has_category_category1`
    FOREIGN KEY (`category_name`)
    REFERENCES `filmoteka`.`category` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `filmoteka`.`film_has_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `filmoteka`.`film_has_country` (
  `film_id` INT UNSIGNED NOT NULL,
  `country_name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`film_id`, `country_name`),
  INDEX `fk_film_has_country_country1_idx` (`country_name` ASC) VISIBLE,
  INDEX `fk_film_has_country_film1_idx` (`film_id` ASC) VISIBLE,
  CONSTRAINT `fk_film_has_country_film1`
    FOREIGN KEY (`film_id`)
    REFERENCES `filmoteka`.`film` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_film_has_country_country1`
    FOREIGN KEY (`country_name`)
    REFERENCES `filmoteka`.`country` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
