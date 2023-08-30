CREATE SCHEMA IF NOT EXISTS `computerdb` DEFAULT CHARACTER SET utf8;
USE `computerdb`;

CREATE TABLE IF NOT EXISTS `computerdb`.`product` (
  `maker` VARCHAR(10) NOT NULL,
  `model` VARCHAR(50) NOT NULL,
  `type` ENUM("PC", "Laptop", "Printer") NOT NULL,
  PRIMARY KEY (`model`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `computerdb`.`pc` (
  `code` INT NOT NULL,
  `speed` SMALLINT(4) NOT NULL,
  `ram` SMALLINT(2) NOT NULL,
  `hdd` REAL NOT NULL,
  `cd` VARCHAR(10) NOT NULL,
  `price` DECIMAL(15,2) NULL,
  `model` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`code`),
  INDEX `fk_pc_product_idx` (`model` ASC),
  CONSTRAINT `fk_pc_product`
    FOREIGN KEY (`model`)
    REFERENCES `computerdb`.`product` (`model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `computerdb`.`laptop` (
  `code` INT NOT NULL,
  `speed` SMALLINT(4) NOT NULL,
  `ram` SMALLINT(2) NOT NULL,
  `hdd` REAL NOT NULL,
  `cd` VARCHAR(10) NOT NULL,
  `price` DECIMAL(15,2) NULL,
  `screen` TINYINT(2) NOT NULL,
  `model` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`code`),
  INDEX `fk_laptop_product1_idx` (`model` ASC),
  CONSTRAINT `fk_laptop_product1`
    FOREIGN KEY (`model`)
    REFERENCES `computerdb`.`product` (`model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `computerdb`.`printer` (
  `code` INT NOT NULL,
  `color` CHAR(1) NOT NULL,
  `type` ENUM("Laser", "Matrix", "Jet") NOT NULL,
  `price` DECIMAL(15,2) NULL,
  `model` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`code`),
  INDEX `fk_printer_product1_idx` (`model` ASC),
  CONSTRAINT `fk_printer_product1`
    FOREIGN KEY (`model`)
    REFERENCES `computerdb`.`product` (`model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('Asus', '1000H', 'Laptop');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('Apple', 'MacBook Pro', 'Laptop');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('Lenovo', 'X220', 'Laptop');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('MSI', 'PC 001', 'PC');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('Gigabyte', 'PC 002', 'PC');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('HP', '2012C', 'Printer');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('Kryocera', 'X2012', 'Printer');
INSERT INTO `computerdb`.`product` (`maker`, `model`, `type`) VALUES ('ASUS', 'PC 003', 'PC');

INSERT INTO `computerdb`.`laptop` (`code`, `speed`, `ram`, `hdd`, `cd`, `price`, `screen`, `model`) VALUES ('1', '1800', '4096', '40', '0x', '200', '10', '1000H');
INSERT INTO `computerdb`.`laptop` (`code`, `speed`, `ram`, `hdd`, `cd`, `price`, `screen`, `model`) VALUES ('2', '2800', '8192', '500', '0x', '1500', '14', 'MacBook Pro');
INSERT INTO `computerdb`.`laptop` (`code`, `speed`, `ram`, `hdd`, `cd`, `price`, `screen`, `model`) VALUES ('3', '2600', '6144', '320', '0x', '500', '12', 'X220');

INSERT INTO `computerdb`.`pc` (`code`, `speed`, `ram`, `hdd`, `cd`, `price`, `model`) VALUES ('1', '3000', '8096', '2000', '40x', '1200', 'PC 001');
INSERT INTO `computerdb`.`pc` (`code`, `speed`, `ram`, `hdd`, `cd`, `price`, `model`) VALUES ('2', '3300', '8096', '1000', '32X', '1000', 'PC 002');
INSERT INTO `computerdb`.`pc` (`code`, `speed`, `ram`, `hdd`, `cd`, `price`, `model`) VALUES ('3', '3000', '8096', '2000', '0x', '900', 'PC 003');

INSERT INTO `computerdb`.`printer` (`code`, `color`, `type`, `price`, `model`) VALUES ('1', 'y', 'Jet', '300', '2012C');
INSERT INTO `computerdb`.`printer` (`code`, `color`, `type`, `price`, `model`) VALUES ('2', 'n', 'Laser', '800', 'X2012');

SELECT model, speed, hdd FROM computerdb.pc WHERE price <= 1100;

SELECT product.maker FROM product INNER JOIN printer ON product.model = printer.model;

SELECT model, ram, screen FROM laptop WHERE price > 1000;

SELECT * FROM printer Where color = 'y';

SELECT model, speed, hdd FROM pc where (cd='40x' || cd='32x') && price <= 1000;

SELECT maker, speed, hdd  FROM laptop LEFT JOIN product ON laptop.model = product.model WHERE hdd > 10;

SELECT product.maker, product.model, (ifnull(pc.price,0)+ ifnull(laptop.price,0)+ ifnull(printer.price,0)) AS 'price'
  FROM product
  LEFT JOIN laptop ON product.model = laptop.model
  LEFT JOIN pc ON product.model = pc.model
  LEFT JOIN printer ON product.model = printer.model
  WHERE product.maker LIKE 'A%';
  
SELECT maker FROM product WHERE type!='laptop' GROUP BY maker;

SELECT product.maker, laptop.model, laptop.speed FROM laptop LEFT JOIN product ON laptop.model = product.model WHERE laptop.speed > 1800;

SELECT model, price FROM printer order by price DESC;

SELECT AVG(speed) as 'average CPU speed' FROM pc;

SELECT AVG(speed) as 'average CPU speed' FROM laptop WHERE price > 1000;

SELECT avg(pc.speed) as 'average PC speed' FROM product LEFT JOIN pc ON product.model = pc.model  WHERE product.maker LIKE "M%";

SELECT pc.speed, AVG(pc.price) AS 'average price' FROM pc GROUP BY pc.speed;

SELECT S.hdd FROM 
(SELECT pc.hdd, COUNT(*) FROM pc GROUP BY pc.hdd HAVING COUNT(*) > 1) AS S;

select product.type, laptop.model, laptop.speed FROM laptop LEFT JOIN product ON laptop.model = product.model
 WHERE laptop.speed < (SELECT MIN(pc.speed) FROM pc);
 
SELECT product.maker FROM printer LEFT JOIN product ON (printer.model = product.model)
WHERE printer.price = (SELECT MIN(printer.price) FROM printer) AND printer.color = 'y';

SELECT product.maker, AVG(laptop.screen) FROM laptop LEFT JOIN product ON laptop.model = product.model GROUP BY product.maker;

 SELECT product.maker  FROM
 (SELECT pc.model ,pc.speed  FROM pc WHERE speed > 750
 UNION
SELECT laptop.model, laptop.speed FROM laptop WHERE speed > 750) AS t1
 LEFT JOIN product ON t1.model = product.model GROUP BY product.maker;
