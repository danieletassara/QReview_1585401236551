--
-- Database: `qreview_db`
--

CREATE DATABASE IF NOT EXISTS `qreview_db`;
USE `qreview_db`;


-- ENTITIES

--
-- Struttura della tabella `address`
--

CREATE TABLE IF NOT EXISTS `address` (
	`City` varchar(130) ,
	`Nation` varchar(130)  NOT NULL,
	`Number` numeric ,
	`Region` varchar(130) ,
	`Route` varchar(130) ,
	
	`_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT 

);


--
-- Struttura della tabella `restaurant`
--

CREATE TABLE IF NOT EXISTS `restaurant` (
	`Address` varchar(130)  NOT NULL,
	`Name` varchar(130)  NOT NULL,
	`Phone` numeric ,
	
	`_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT 

);


--
-- Struttura della tabella `review`
--

CREATE TABLE IF NOT EXISTS `review` (
	`Description` varchar(130)  NOT NULL,
	`Global` numeric  NOT NULL,
	`Title` varchar(130)  NOT NULL,
	`URID` varchar(130)  NOT NULL,
	
	`_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT 

);


--
-- Struttura della tabella `user`
--

CREATE TABLE IF NOT EXISTS `user` (
	`mail` varchar(130) ,
	`name` varchar(130) ,
	`password` varchar(130)  NOT NULL,
	`roles` varchar(130) ,
	`surname` varchar(130) ,
	`username` varchar(130)  NOT NULL,
	
	`_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT 

);


-- Security

ALTER TABLE `user` MODIFY COLUMN `password` varchar(128)  NOT NULL;

INSERT INTO `qreview_db`.`user` (`username`, `password`, `_id`) VALUES ('admin', '62f264d7ad826f02a8af714c0a54b197935b717656b80461686d450f7b3abde4c553541515de2052b9af70f710f0cd8a1a2d3f4d60aa72608d71a63a9a93c0f5', 1);

CREATE TABLE IF NOT EXISTS `roles` (
	`role` varchar(30) ,
	
	-- RELAZIONI

	`_user` int(11)  NOT NULL REFERENCES user(_id),
	`_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT 

);
INSERT INTO `qreview_db`.`roles` (`role`, `_user`, `_id`) VALUES ('ADMIN', '1', 1);





-- relation 1:m Address Address - Restaurant
ALTER TABLE `address` ADD COLUMN `Address` int(11)  REFERENCES restaurant(_id);

-- relation 1:m Review Restaurant - Review
ALTER TABLE `restaurant` ADD COLUMN `Review` int(11)  REFERENCES review(_id);


