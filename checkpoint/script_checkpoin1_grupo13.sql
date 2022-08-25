-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema DHespegar
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema DHespegar
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DHespegar` DEFAULT CHARACTER SET utf8 ;
USE `DHespegar` ;

-- -----------------------------------------------------
-- Table `DHespegar`.`REGISTROS_CLIENTES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`REGISTROS_CLIENTES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigo_reserva` CHAR(6) NOT NULL,
  `fecha_reserva` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`SUCURSALES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`SUCURSALES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `telefono` INT NULL,
  `direccion` VARCHAR(45) NULL,
  `ciudad` VARCHAR(45) NULL,
  `RESERVAS_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_SUCURSALES_RESERVAS1_idx` (`RESERVAS_id` ASC) VISIBLE,
  CONSTRAINT `fk_SUCURSALES_RESERVAS1`
    FOREIGN KEY (`RESERVAS_id`)
    REFERENCES `DHespegar`.`REGISTROS_CLIENTES` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`PAISES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`PAISES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `CLIENTES_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_PAISES_CLIENTES1_idx` (`CLIENTES_id` ASC) VISIBLE,
  CONSTRAINT `fk_PAISES_CLIENTES1`
    FOREIGN KEY (`CLIENTES_id`)
    REFERENCES `DHespegar`.`CLIENTES` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`RESERVA_PAQUETE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`RESERVA_PAQUETE` (
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`CLIENTES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`CLIENTES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `numero_pasaporte` VARCHAR(45) NULL,
  `ciudad` VARCHAR(45) NULL,
  `telefono` INT NULL,
  `SUCURSALES_id` INT NOT NULL,
  `RESERVA_PAQUETE_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_CLIENTES_SUCURSALES1_idx` (`SUCURSALES_id` ASC) VISIBLE,
  INDEX `fk_CLIENTES_RESERVA_PAQUETE1_idx` (`RESERVA_PAQUETE_id` ASC) VISIBLE,
  CONSTRAINT `fk_CLIENTES_SUCURSALES1`
    FOREIGN KEY (`SUCURSALES_id`)
    REFERENCES `DHespegar`.`SUCURSALES` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIENTES_RESERVA_PAQUETE1`
    FOREIGN KEY (`RESERVA_PAQUETE_id`)
    REFERENCES `DHespegar`.`RESERVA_PAQUETE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`PAISES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`PAISES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `CLIENTES_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_PAISES_CLIENTES1_idx` (`CLIENTES_id` ASC) VISIBLE,
  CONSTRAINT `fk_PAISES_CLIENTES1`
    FOREIGN KEY (`CLIENTES_id`)
    REFERENCES `DHespegar`.`CLIENTES` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`VUELOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`VUELOS` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero_vuelo` CHAR(6) NULL,
  `fecha_partida` DATETIME NULL,
  `fecha_llegada` DATETIME NULL,
  `pais_origen` VARCHAR(30) NULL,
  `pais_destino` VARCHAR(30) NULL,
  `RESERVA_PAQUETE_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_VUELOS_RESERVA_PAQUETE1_idx` (`RESERVA_PAQUETE_id` ASC) VISIBLE,
  CONSTRAINT `fk_VUELOS_RESERVA_PAQUETE1`
    FOREIGN KEY (`RESERVA_PAQUETE_id`)
    REFERENCES `DHespegar`.`RESERVA_PAQUETE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`CLASES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`CLASES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `clase_turista` TINYINT(1) NULL,
  `plazas_turista` TINYINT(255) NULL,
  `plazas_primera_clase` TINYINT(255) NULL,
  `VUELOS_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_CLASES_VUELOS1_idx` (`VUELOS_id` ASC) VISIBLE,
  CONSTRAINT `fk_CLASES_VUELOS1`
    FOREIGN KEY (`VUELOS_id`)
    REFERENCES `DHespegar`.`VUELOS` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`HOTELES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`HOTELES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
  `ciudad` VARCHAR(45) NULL,
  `cantidad_habitaciones` SMALLINT(3000) NULL,
  `telefono` INT NULL,
  `RESERVA_PAQUETE_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_HOTELES_RESERVA_PAQUETE1_idx` (`RESERVA_PAQUETE_id` ASC) VISIBLE,
  CONSTRAINT `fk_HOTELES_RESERVA_PAQUETE1`
    FOREIGN KEY (`RESERVA_PAQUETE_id`)
    REFERENCES `DHespegar`.`RESERVA_PAQUETE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`TIPO_HOSPEDAJES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`TIPO_HOSPEDAJES` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pension_completa` TINYINT(1) NOT NULL,
  `fecha_llegada` DATETIME NOT NULL,
  `fecha_partida` DATETIME NOT NULL,
  `HOTELES_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_TIPO_HOSPEDAJES_HOTELES1_idx` (`HOTELES_id` ASC) VISIBLE,
  CONSTRAINT `fk_TIPO_HOSPEDAJES_HOTELES1`
    FOREIGN KEY (`HOTELES_id`)
    REFERENCES `DHespegar`.`HOTELES` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`METODOS_PAGO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`METODOS_PAGO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `efectivo` TINYINT(1) NULL,
  `debito` TINYINT(1) NULL,
  `transferencia_bancaria` TINYINT(1) NULL,
  `RESERVA_PAQUETE_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_METODOS_PAGO_RESERVA_PAQUETE1_idx` (`RESERVA_PAQUETE_id` ASC) VISIBLE,
  CONSTRAINT `fk_METODOS_PAGO_RESERVA_PAQUETE1`
    FOREIGN KEY (`RESERVA_PAQUETE_id`)
    REFERENCES `DHespegar`.`RESERVA_PAQUETE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DHespegar`.`TARJETAS_CREDITO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DHespegar`.`TARJETAS_CREDITO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cantidad_coutas` TINYINT(24) NOT NULL,
  `precio_total` INT NOT NULL,
  `METODOS_PAGO_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_TARJETAS_CREDITO_METODOS_PAGO1_idx` (`METODOS_PAGO_id` ASC) VISIBLE,
  CONSTRAINT `fk_TARJETAS_CREDITO_METODOS_PAGO1`
    FOREIGN KEY (`METODOS_PAGO_id`)
    REFERENCES `DHespegar`.`METODOS_PAGO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
