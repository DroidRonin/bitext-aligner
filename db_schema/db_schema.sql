-- MySQL Script generated by MySQL Workbench
-- Sat Jan 18 00:33:33 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bitext-aligner
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bitext-aligner` ;

-- -----------------------------------------------------
-- Schema bitext-aligner
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bitext-aligner` DEFAULT CHARACTER SET utf8 ;
USE `bitext-aligner` ;

-- -----------------------------------------------------
-- Table `bitext-aligner`.`dim_author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`dim_author` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(90) NOT NULL,
  `total_books` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bitext-aligner`.`dim_book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`dim_book` (
  `id` INT NOT NULL,
  `code` VARCHAR(90) NOT NULL,
  `added_at` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bitext-aligner`.`dim_book_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`dim_book_info` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(90) NOT NULL,
  `description` VARCHAR(200) NULL,
  `lang` VARCHAR(5) NOT NULL,
  `source` VARCHAR(90) NOT NULL,
  `is_translation` TINYINT NOT NULL,
  `total_chapters` INT UNSIGNED NOT NULL,
  `isbn` VARCHAR(80) NULL,
  `book` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `info_book_fk`
    FOREIGN KEY (`book`)
    REFERENCES `bitext-aligner`.`dim_book` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `book_fk_idx` ON `bitext-aligner`.`dim_book_info` (`book` ASC) VISIBLE;

CREATE UNIQUE INDEX `book_UNIQUE` ON `bitext-aligner`.`dim_book_info` (`book` ASC) VISIBLE;

CREATE UNIQUE INDEX `id_UNIQUE` ON `bitext-aligner`.`dim_book_info` (`id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bitext-aligner`.`dim_book_content`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`dim_book_content` (
  `id` INT NOT NULL,
  `book` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `content_book_fk`
    FOREIGN KEY (`book`)
    REFERENCES `bitext-aligner`.`dim_book` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `book_fk_idx` ON `bitext-aligner`.`dim_book_content` (`book` ASC) VISIBLE;

CREATE UNIQUE INDEX `book_UNIQUE` ON `bitext-aligner`.`dim_book_content` (`book` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bitext-aligner`.`dim_book_chapter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`dim_book_chapter` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `c_num` INT UNSIGNED NOT NULL,
  `name` VARCHAR(90) NULL,
  `book_content` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ch_content_fk`
    FOREIGN KEY (`book_content`)
    REFERENCES `bitext-aligner`.`dim_book_content` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `content_fk_idx` ON `bitext-aligner`.`dim_book_chapter` (`book_content` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bitext-aligner`.`dim_book_sentence`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`dim_book_sentence` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `s_num` INT UNSIGNED NOT NULL,
  `text` VARCHAR(500) NOT NULL,
  `chapter` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `sen_chapter_fk`
    FOREIGN KEY (`chapter`)
    REFERENCES `bitext-aligner`.`dim_book_chapter` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `chapter_fk_idx` ON `bitext-aligner`.`dim_book_sentence` (`chapter` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bitext-aligner`.`map_book_author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bitext-aligner`.`map_book_author` (
  `author` INT NOT NULL,
  `book` INT NOT NULL,
  `translator` TINYINT NOT NULL,
  CONSTRAINT `map_book_fk`
    FOREIGN KEY (`book`)
    REFERENCES `bitext-aligner`.`dim_book_info` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `map_author_fk`
    FOREIGN KEY (`author`)
    REFERENCES `bitext-aligner`.`dim_author` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `book_fk_idx` ON `bitext-aligner`.`map_book_author` (`book` ASC) VISIBLE;

CREATE INDEX `author_fk_idx` ON `bitext-aligner`.`map_book_author` (`author` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
