-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: movieticket
-- ------------------------------------------------------
-- Server version	5.7.17-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_username` varchar(45) DEFAULT NULL,
  `password` varchar(60) NOT NULL,
  `c_fname` varchar(45) NOT NULL,
  `c_lname` varchar(45) NOT NULL,
  `c_email` varchar(45) NOT NULL,
  `role` varchar(45) NOT NULL,
  `card_id` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `c_username_UNIQUE` (`c_username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'admin','$2a$10$sdl.q1TXhlQPM.A87BM/XOikxWzs/MwDDjrcKGOQLRb2HV1iqXP7y','Chayanin','khaw','asddasdas','admin',NULL);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall`
--

DROP TABLE IF EXISTS `hall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hall` (
  `hall_id` int(11) NOT NULL,
  `hall_name` varchar(45) NOT NULL,
  `Theatre_theatre_id` varchar(45) NOT NULL,
  PRIMARY KEY (`Theatre_theatre_id`,`hall_id`),
  CONSTRAINT `fk_Hall_Theatre1` FOREIGN KEY (`Theatre_theatre_id`) REFERENCES `theatre` (`theatre_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall`
--

LOCK TABLES `hall` WRITE;
/*!40000 ALTER TABLE `hall` DISABLE KEYS */;
INSERT INTO `hall` VALUES (1,'Hall1','1'),(2,'Hall2','1'),(3,'Hall3','1'),(4,'Hall4','1'),(5,'Hall5','1'),(6,'Hall6','1'),(1,'Hall1','2'),(2,'Hall2','2'),(3,'Hall2','2'),(1,'Hall1','5'),(2,'Hall2','5'),(1,'Hall1','9');
/*!40000 ALTER TABLE `hall` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `timestamp` int(11) NOT NULL,
  `Tickets_ticket_no` int(11) NOT NULL,
  PRIMARY KEY (`Tickets_ticket_no`),
  CONSTRAINT `fk_log_Tickets1` FOREIGN KEY (`Tickets_ticket_no`) REFERENCES `tickets` (`ticket_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movie` (
  `m_id` int(11) NOT NULL,
  `m_name` varchar(45) NOT NULL,
  `actors` varchar(45) NOT NULL,
  `director` varchar(45) NOT NULL,
  `release_date` varchar(45) NOT NULL,
  `movie_pic` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`m_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (1,'Doraemon','Nobita','Fujiko','24/5/60',NULL),(2,'Fast8','Dom','Dom','24/5/60',NULL),(3,'Your Name','Unknown','Unknown','24/5/60',NULL),(4,'Conan','Unknown','Unknown','24/5/60',NULL),(9,'sad','dsad','dsad','dsad',NULL);
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seats`
--

DROP TABLE IF EXISTS `seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seats` (
  `seat_id` varchar(45) NOT NULL,
  `seat_name` varchar(45) DEFAULT NULL,
  `seat_num` varchar(45) DEFAULT NULL,
  `Hall_Theatre_theatre_id` varchar(45) NOT NULL,
  `Hall_hall_id` int(11) NOT NULL,
  PRIMARY KEY (`Hall_Theatre_theatre_id`,`Hall_hall_id`,`seat_id`),
  CONSTRAINT `fk_Seats_Hall1` FOREIGN KEY (`Hall_Theatre_theatre_id`, `Hall_hall_id`) REFERENCES `hall` (`Theatre_theatre_id`, `hall_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seats`
--

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
INSERT INTO `seats` VALUES ('1','1','1','1',1),('A1','A','1','1',1),('A2','A','2','1',1),('B1','B','1','1',1),('B2','B','2','1',1),('A1','A','1','1',2),('A1','A','1','2',1),('A2','A','2','2',1),('B1','B','1','2',1),('B2','B','2','2',1),('B3','B','3','2',1),('A1','A','1','2',2);
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shows`
--

DROP TABLE IF EXISTS `shows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shows` (
  `show_id` varchar(45) NOT NULL,
  `st_time` time NOT NULL,
  `end_time` time NOT NULL,
  `language` varchar(45) NOT NULL,
  `Movie_m_id` int(11) NOT NULL,
  `Hall_Theatre_theatre_id` varchar(45) NOT NULL,
  `Hall_hall_id` int(11) NOT NULL,
  PRIMARY KEY (`show_id`),
  KEY `fk_Show_Movie1_idx` (`Movie_m_id`),
  KEY `fk_Show_Hall1_idx` (`Hall_Theatre_theatre_id`,`Hall_hall_id`),
  CONSTRAINT `fk_Show_Hall1` FOREIGN KEY (`Hall_Theatre_theatre_id`, `Hall_hall_id`) REFERENCES `hall` (`Theatre_theatre_id`, `hall_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Show_Movie1` FOREIGN KEY (`Movie_m_id`) REFERENCES `movie` (`m_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shows`
--

LOCK TABLES `shows` WRITE;
/*!40000 ALTER TABLE `shows` DISABLE KEYS */;
INSERT INTO `shows` VALUES ('1','10:00:00','12:00:00','TH',1,'1',1),('2','13:00:00','15:00:00','TH',1,'1',1),('3','16:00:00','18:00:00','TH',2,'2',2),('4','20:00:00','22:00:00','ENG',9,'2',2);
/*!40000 ALTER TABLE `shows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theatre`
--

DROP TABLE IF EXISTS `theatre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theatre` (
  `theatre_id` varchar(45) NOT NULL,
  `location` varchar(45) NOT NULL,
  PRIMARY KEY (`theatre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theatre`
--

LOCK TABLES `theatre` WRITE;
/*!40000 ALTER TABLE `theatre` DISABLE KEYS */;
INSERT INTO `theatre` VALUES ('1','Bkk'),('2','paris'),('3','puket'),('4','ww'),('5','NY'),('6','GM'),('9','rr');
/*!40000 ALTER TABLE `theatre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `ticket_no` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `show_date` date NOT NULL,
  `show_id` varchar(45) NOT NULL,
  `Customer_id` int(10) unsigned NOT NULL,
  `Show_show_id` varchar(45) NOT NULL,
  `Seats_Hall_Theatre_theatre_id` varchar(45) NOT NULL,
  `Seats_Hall_hall_id` int(11) NOT NULL,
  `Seats_seat_id` varchar(45) NOT NULL,
  PRIMARY KEY (`ticket_no`),
  KEY `fk_Tickets_Customer_idx` (`Customer_id`),
  KEY `fk_Tickets_Show1_idx` (`Show_show_id`),
  KEY `fk_Tickets_Seats1_idx` (`Seats_Hall_Theatre_theatre_id`,`Seats_Hall_hall_id`,`Seats_seat_id`),
  CONSTRAINT `fk_Tickets_Customer` FOREIGN KEY (`Customer_id`) REFERENCES `customer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tickets_Seats1` FOREIGN KEY (`Seats_Hall_Theatre_theatre_id`, `Seats_Hall_hall_id`, `Seats_seat_id`) REFERENCES `seats` (`Hall_Theatre_theatre_id`, `Hall_hall_id`, `seat_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tickets_Show1` FOREIGN KEY (`Show_show_id`) REFERENCES `shows` (`show_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-28 20:35:26
