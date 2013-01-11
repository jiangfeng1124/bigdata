-- MySQL dump 10.13  Distrib 5.5.28, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: graphdb
-- ------------------------------------------------------
-- Server version	5.5.28-0ubuntu0.12.10.2

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_425ae3c4` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_message`
--

DROP TABLE IF EXISTS `auth_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_message_403f60f` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_message`
--

LOCK TABLES `auth_message` WRITE;
/*!40000 ALTER TABLE `auth_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_1bb8f392` (`content_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add user',3,'add_user'),(8,'Can change user',3,'change_user'),(9,'Can delete user',3,'delete_user'),(10,'Can add message',4,'add_message'),(11,'Can change message',4,'change_message'),(12,'Can delete message',4,'delete_message'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session'),(19,'Can add publisher',7,'add_publisher'),(20,'Can change publisher',7,'change_publisher'),(21,'Can delete publisher',7,'delete_publisher'),(22,'Can add author',8,'add_author'),(23,'Can change author',8,'change_author'),(24,'Can delete author',8,'delete_author'),(25,'Can add book',9,'add_book'),(26,'Can change book',9,'change_book'),(27,'Can delete book',9,'delete_book'),(28,'Can add log entry',10,'add_logentry'),(29,'Can change log entry',10,'change_logentry'),(30,'Can delete log entry',10,'delete_logentry'),(31,'Can add site',11,'add_site'),(32,'Can change site',11,'change_site'),(33,'Can delete site',11,'delete_site'),(34,'Can add dataset',12,'add_dataset'),(35,'Can change dataset',12,'change_dataset'),(36,'Can delete dataset',12,'delete_dataset'),(37,'Can add program',13,'add_program'),(38,'Can change program',13,'change_program'),(39,'Can delete program',13,'delete_program'),(40,'Can add task',14,'add_task'),(41,'Can change task',14,'change_task'),(42,'Can delete task',14,'delete_task');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'jiangfeng','','','jiangfeng1124@gmail.com','pbkdf2_sha256$10000$kUrmu5VRECan$2EHS+PPnJ9G2TrofXhCvqSYhHnmsE1bKI/U9WKOuSCA=',1,1,1,'2012-12-22 15:58:16','2012-11-08 21:05:28'),(2,'huhupao','','','','sha1$b8bac$5954c1025b5d659d23cafa18c9a1d7b4bf41a586',0,1,0,'2012-11-10 14:19:05','2012-11-09 16:57:38'),(3,'car','','','','pbkdf2_sha256$10000$TNGutjhk4N8d$deYvG1v6X9vdPtwW5bCJH+7rDYgefnnc0xaBRGDOhcA=',0,1,0,'2012-12-13 19:14:44','2012-11-10 14:42:59'),(4,'han','','','','sha1$6897c$9f17128093306f4479d54630c72f4b4d13a63709',0,1,0,'2012-12-06 23:31:19','2012-11-10 14:44:34'),(5,'susu','','','','sha1$bd926$7bdd5a0bcb8f632cfe06c8d945ba13eeb454270d',0,1,0,'2012-11-10 14:52:01','2012-11-10 14:52:01'),(6,'mlkid','','','','sha1$af8e7$8f7e3b7ef932f79fba0655379e3e08e4b3d3cc4d',0,1,0,'2012-11-10 14:57:30','2012-11-10 14:57:30'),(7,'princeton','','','','pbkdf2_sha256$10000$BrlUA5uC9d3Y$btu7n238QPZLqAzG1u/dq58NWrEyDQB28cg9TvkbO40=',0,1,0,'2012-12-13 19:16:22','2012-11-10 15:01:23'),(8,'campus','','','','sha1$d6b8f$72ed386cc65aa25b89ebc3d1c2b00895acbd232c',0,1,0,'2012-11-10 15:02:18','2012-11-10 15:02:18'),(9,'vicky','','','','sha1$859e5$bc12c05d59bc4b61c94f0fb53950e7396f00a487',0,1,0,'2012-11-10 15:03:00','2012-11-10 15:03:00'),(10,'fan','','','','sha1$5ae0b$42a205dbfaf786906ff25089e41776b256f27602',0,1,0,'2012-11-27 17:32:29','2012-11-27 17:32:29'),(11,'orfe','','','','pbkdf2_sha256$10000$ayzbNCUDTwYc$nyPzqlSQ0fwzuMO/434utnDTK+YIThNMSC3u57dVmbw=',0,1,0,'2012-12-13 19:17:15','2012-12-13 19:17:15'),(12,'fanghan','','','','pbkdf2_sha256$10000$iKtF7ULGdxsx$Ksj5J/EIU9WC4Bad+7E3/NRwDrYmiEbHF5McjlfK+pk=',0,1,0,'2012-12-14 02:56:09','2012-12-14 02:56:09'),(13,'hanliu','','','','pbkdf2_sha256$10000$5U57yC4UTMyW$CHC5w3nZvPXnLZYbINKY4PCrhtWzga/kTIkhCe0Bonw=',0,1,0,'2012-12-14 02:56:15','2012-12-14 02:56:15'),(14,'tourzhao','','','','pbkdf2_sha256$10000$H0fqb4xPM39m$uYXM6zIgHXTVe9TSVIWbBsjv5zRJxe1o+ZyBuxuoK50=',0,1,0,'2012-12-14 03:16:10','2012-12-14 03:16:10'),(15,'shww','','','','pbkdf2_sha256$10000$EivxtTRc28lX$/ObBFv/VvGPTvS6j1Eb+X8M0+4mEoTghOYVJzBC3o3U=',0,1,0,'2012-12-14 06:18:15','2012-12-14 06:18:15');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_403f60f` (`user_id`),
  KEY `auth_user_groups_425ae3c4` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_403f60f` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books` (
  `name` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_author`
--

DROP TABLE IF EXISTS `books_author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books_author` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `salutation` varchar(10) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(40) NOT NULL,
  `email` varchar(75) NOT NULL,
  `headshot` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_author`
--

LOCK TABLES `books_author` WRITE;
/*!40000 ALTER TABLE `books_author` DISABLE KEYS */;
INSERT INTO `books_author` VALUES (1,'Mr.','jiang','guo','jiangfeng1124@gmail.com','/home/jiangfeng/Work/demo/graphmodels/graphmodels/images/d100_n200.jpeg');
/*!40000 ALTER TABLE `books_author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_book`
--

DROP TABLE IF EXISTS `books_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `publisher_id` int(11) NOT NULL,
  `publication_date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `books_book_22dd9c39` (`publisher_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_book`
--

LOCK TABLES `books_book` WRITE;
/*!40000 ALTER TABLE `books_book` DISABLE KEYS */;
INSERT INTO `books_book` VALUES (1,'convex optimization',1,'2012-11-08');
/*!40000 ALTER TABLE `books_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_book_authors`
--

DROP TABLE IF EXISTS `books_book_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books_book_authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `book_id` (`book_id`,`author_id`),
  KEY `books_book_authors_752eb95b` (`book_id`),
  KEY `books_book_authors_337b96ff` (`author_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_book_authors`
--

LOCK TABLES `books_book_authors` WRITE;
/*!40000 ALTER TABLE `books_book_authors` DISABLE KEYS */;
INSERT INTO `books_book_authors` VALUES (1,1,1);
/*!40000 ALTER TABLE `books_book_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_publisher`
--

DROP TABLE IF EXISTS `books_publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books_publisher` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(60) NOT NULL,
  `state_province` varchar(30) NOT NULL,
  `country` varchar(50) NOT NULL,
  `website` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_publisher`
--

LOCK TABLES `books_publisher` WRITE;
/*!40000 ALTER TABLE `books_publisher` DISABLE KEYS */;
INSERT INTO `books_publisher` VALUES (1,'Springer','unknown','Princeton','New Jersey','USA','http://www.springer.com/'),(2,'huhupao','harbin','harbin','heilongjiang','china','http://www.huhupao.com/');
/*!40000 ALTER TABLE `books_publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataset_dataset`
--

DROP TABLE IF EXISTS `dataset_dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_dataset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `path` varchar(200) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `dim` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `access` varchar(10) NOT NULL,
  `sep` varchar(10) DEFAULT NULL,
  `header` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dataset_dataset_5d52dd10` (`owner_id`)
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataset_dataset`
--

LOCK TABLES `dataset_dataset` WRITE;
/*!40000 ALTER TABLE `dataset_dataset` DISABLE KEYS */;
INSERT INTO `dataset_dataset` VALUES (46,1,'jiangfeng/sample_scale-free.csv','sample_scale-free.csv','a sample dataset of scale-free graph',50,200,'public','tab',0),(47,1,'jiangfeng/sample-random.csv','sample-random.csv','a sample dataset of random graph',50,200,'public','tab',0),(48,1,'jiangfeng/sample_hub.csv','sample_hub.csv','a sample dataset of hub graph',50,200,'public','tab',0),(49,1,'jiangfeng/hub_5.csv','hub_5.csv','hub graph',100,200,'public','tab',0),(50,1,'jiangfeng/abalone.csv','abalone.csv','abalone data',8,4177,'public','tab',1);
/*!40000 ALTER TABLE `dataset_dataset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_403f60f` (`user_id`),
  KEY `django_admin_log_1bb8f392` (`content_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=181 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2012-11-08 22:16:23',1,7,'1','Springer',1,''),(2,'2012-11-08 22:22:49',1,8,'1','jiang guo',1,''),(3,'2012-11-08 22:23:20',1,9,'1','convex optimization',1,''),(4,'2012-11-13 11:25:13',1,13,'1','correlation',1,''),(5,'2012-11-13 11:33:37',1,13,'2','glasso',1,''),(6,'2012-11-13 11:35:56',1,13,'3','clime',1,''),(7,'2012-11-13 11:37:59',1,13,'4','tiger',1,''),(8,'2012-11-13 14:58:30',1,14,'11','jiangfeng_sample.dat_correlation',3,''),(9,'2012-11-13 14:58:30',1,14,'10','jiangfeng_sample.dat_correlation',3,''),(10,'2012-11-13 14:58:30',1,14,'9','jiangfeng_sample.dat_correlation',3,''),(11,'2012-11-13 14:58:30',1,14,'8','jiangfeng_sample.dat_correlation',3,''),(12,'2012-11-13 14:58:30',1,14,'7','jiangfeng_sample.dat_correlation',3,''),(13,'2012-11-13 14:58:30',1,14,'6','jiangfeng_sample.dat_correlation',3,''),(14,'2012-11-13 14:58:30',1,14,'5','jiangfeng_sample.dat_correlation',3,''),(15,'2012-11-13 14:58:30',1,14,'4','jiangfeng_sample.dat_correlation',3,''),(16,'2012-11-13 14:58:30',1,14,'3','jiangfeng_sample.dat_correlation',3,''),(17,'2012-11-13 14:58:30',1,14,'2','jiangfeng_sample.dat_correlation',3,''),(18,'2012-11-13 14:58:30',1,14,'1','jiangfeng_sample.dat_correlation',3,''),(19,'2012-11-14 12:12:05',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(20,'2012-11-15 17:43:54',1,12,'1','sample.dat',2,'Changed path.'),(21,'2012-11-15 17:44:02',1,12,'2','regression.csv',2,'Changed path.'),(22,'2012-11-15 18:29:12',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(23,'2012-11-15 20:13:13',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(24,'2012-11-15 20:18:14',1,13,'1','correlation',2,'Changed options.'),(25,'2012-11-15 21:42:00',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(26,'2012-11-15 21:43:09',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(27,'2012-11-15 22:10:30',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(28,'2012-11-15 22:11:13',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(29,'2012-11-15 22:11:45',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(30,'2012-11-15 22:14:20',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(31,'2012-11-15 22:15:01',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(32,'2012-11-15 22:16:12',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(33,'2012-11-15 22:18:45',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(34,'2012-11-15 22:20:38',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(35,'2012-11-15 22:21:01',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(36,'2012-11-15 22:23:51',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(37,'2012-11-15 22:25:27',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(38,'2012-11-15 22:26:38',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed progress.'),(39,'2012-11-17 16:32:20',1,13,'1','correlation',2,'Changed language.'),(40,'2012-11-17 16:32:25',1,13,'2','glasso',2,'Changed language.'),(41,'2012-11-17 16:32:30',1,13,'4','tiger',2,'Changed language.'),(42,'2012-11-17 16:32:37',1,13,'3','clime',2,'Changed language.'),(43,'2012-11-17 17:02:26',1,14,'12','jiangfeng_sample.dat_correlation',2,'Changed options.'),(44,'2012-11-18 15:37:08',1,14,'17','jiangfeng_sammon_simplex.txt_correlation',3,''),(45,'2012-11-18 15:37:08',1,14,'16','jiangfeng_sammon_simplex.txt_correlation',3,''),(46,'2012-11-18 15:37:08',1,14,'15','jiangfeng_sammon_simplex_itisa_long_long_filename.txt_correlation',3,''),(47,'2012-11-18 15:37:08',1,14,'14','jiangfeng_sammon_linear.txt_correlation',3,''),(48,'2012-11-18 15:37:08',1,14,'13','jiangfeng_sammon_linear.txt_correlation',3,''),(49,'2012-11-18 15:37:08',1,14,'12','jiangfeng_sample.dat_correlation',3,''),(50,'2012-11-18 15:41:07',1,12,'1','sample.dat',2,'Changed dim and size.'),(51,'2012-11-18 22:46:48',1,13,'4','tiger',2,'Changed options.'),(52,'2012-11-18 22:47:22',1,13,'4','tiger',2,'Changed options.'),(53,'2012-11-18 22:56:42',1,13,'4','tiger',2,'Changed path.'),(54,'2012-11-19 10:04:56',1,13,'2','glasso',2,'Changed options.'),(55,'2012-11-19 10:34:54',1,13,'3','clime',2,'Changed options.'),(56,'2012-11-19 13:14:32',1,14,'67','jiangfeng_random.csv_glasso',3,''),(57,'2012-11-19 13:14:32',1,14,'66','jiangfeng_scale-free.csv_glasso',3,''),(58,'2012-11-19 13:14:32',1,14,'58','jiangfeng_hub.csv_tiger',3,''),(59,'2012-11-19 13:14:32',1,14,'57','jiangfeng_hub.csv_glasso',3,''),(60,'2012-11-19 13:14:32',1,14,'56','jiangfeng_cluster.csv_glasso',3,''),(61,'2012-11-19 13:14:32',1,14,'52','jiangfeng_band.csv_glasso',3,''),(62,'2012-11-19 13:14:32',1,14,'49','jiangfeng_band.csv_correlation',3,''),(63,'2012-11-19 13:14:32',1,14,'48','jiangfeng_sample.dat_clime',3,''),(64,'2012-11-19 13:14:32',1,14,'47','jiangfeng_sammon_linear.txt_glasso',3,''),(65,'2012-11-19 13:14:32',1,14,'39','jiangfeng_sample.dat_glasso',3,''),(66,'2012-11-19 13:14:32',1,14,'38','jiangfeng_sample.dat_glasso',3,''),(67,'2012-11-19 13:14:32',1,14,'37','jiangfeng_sammon_linear.txt_tiger',3,''),(68,'2012-11-19 13:14:32',1,14,'34','jiangfeng_sample.dat_tiger',3,''),(69,'2012-11-19 13:14:32',1,14,'33','jiangfeng_sample.dat_tiger',3,''),(70,'2012-11-19 13:14:32',1,14,'32','jiangfeng_sample.dat_tiger',3,''),(71,'2012-11-19 13:14:32',1,14,'31','jiangfeng_sammon_linear.txt_correlation',3,''),(72,'2012-11-19 13:14:32',1,14,'30','jiangfeng_sample.dat_correlation',3,''),(73,'2012-11-19 13:14:32',1,14,'29','jiangfeng_sammon_simplex_itisa_long_long_filename.txt_correlation',3,''),(74,'2012-11-19 13:14:32',1,14,'27','jiangfeng_sammon_nonlinear.txt_correlation',3,''),(75,'2012-11-19 13:14:32',1,14,'26','jiangfeng_sammon_nonlinear.txt_correlation',3,''),(76,'2012-11-19 13:15:04',1,14,'65','jiangfeng_scale-free.csv_glasso',3,''),(77,'2012-11-19 13:15:04',1,14,'64','jiangfeng_scale-free.csv_glasso',3,''),(78,'2012-11-19 13:15:04',1,14,'63','jiangfeng_scale-free.csv_glasso',3,''),(79,'2012-11-19 13:15:04',1,14,'62','jiangfeng_scale-free.csv_glasso',3,''),(80,'2012-11-19 13:15:04',1,14,'61','jiangfeng_scale-free.csv_glasso',3,''),(81,'2012-11-19 13:15:04',1,14,'60','jiangfeng_scale-free.csv_glasso',3,''),(82,'2012-11-19 13:15:04',1,14,'59','jiangfeng_scale-free.csv_glasso',3,''),(83,'2012-11-19 13:15:04',1,14,'55','jiangfeng_cluster.csv_glasso',3,''),(84,'2012-11-19 13:15:04',1,14,'54','jiangfeng_cluster.csv_glasso',3,''),(85,'2012-11-19 13:15:04',1,14,'53','jiangfeng_cluster.csv_glasso',3,''),(86,'2012-11-19 13:15:04',1,14,'51','jiangfeng_band.csv_glasso',3,''),(87,'2012-11-19 13:15:04',1,14,'50','jiangfeng_band.csv_glasso',3,''),(88,'2012-11-19 13:15:04',1,14,'46','jiangfeng_sammon_linear.txt_glasso',3,''),(89,'2012-11-19 13:15:04',1,14,'45','jiangfeng_sammon_linear.txt_glasso',3,''),(90,'2012-11-19 13:15:04',1,14,'44','jiangfeng_sammon_linear.txt_glasso',3,''),(91,'2012-11-19 13:15:04',1,14,'43','jiangfeng_sammon_linear.txt_glasso',3,''),(92,'2012-11-19 13:15:04',1,14,'42','jiangfeng_sammon_linear.txt_glasso',3,''),(93,'2012-11-19 13:15:04',1,14,'41','jiangfeng_sammon_linear.txt_glasso',3,''),(94,'2012-11-19 13:15:04',1,14,'40','jiangfeng_sammon_linear.txt_glasso',3,''),(95,'2012-11-19 13:15:04',1,14,'36','jiangfeng_sammon_linear.txt_tiger',3,''),(96,'2012-11-19 13:15:04',1,14,'35','jiangfeng_sammon_linear.txt_tiger',3,''),(97,'2012-11-19 13:15:04',1,14,'28','jiangfeng_sammon_simplex_itisa_long_long_filename.txt_correlation',3,''),(98,'2012-11-19 13:15:04',1,14,'25','jiangfeng_sammon_linear.txt_correlation',3,''),(99,'2012-11-19 13:15:04',1,14,'24','jiangfeng_sammon_linear.txt_correlation',3,''),(100,'2012-11-19 13:15:04',1,14,'23','jiangfeng_sammon_linear.txt_correlation',3,''),(101,'2012-11-19 13:15:04',1,14,'22','jiangfeng_sammon_linear.txt_correlation',3,''),(102,'2012-11-19 13:15:04',1,14,'21','jiangfeng_sammon_linear.txt_correlation',3,''),(103,'2012-11-19 13:15:04',1,14,'20','jiangfeng_sammon_linear.txt_correlation',3,''),(104,'2012-11-19 13:15:04',1,14,'19','jiangfeng_sammon_linear.txt_correlation',3,''),(105,'2012-11-19 13:15:04',1,14,'18','jiangfeng_sample.dat_correlation',3,''),(106,'2012-11-19 15:07:58',1,13,'4','tiger',2,'Changed options.'),(107,'2012-11-19 15:08:02',1,13,'3','clime',2,'Changed options.'),(108,'2012-11-19 15:08:06',1,13,'2','glasso',2,'Changed options.'),(109,'2012-11-19 15:08:10',1,13,'1','correlation',2,'Changed options.'),(110,'2012-11-19 19:36:30',1,14,'103','jiangfeng_cluster_2.csv_correlation',3,''),(111,'2012-11-19 19:36:30',1,14,'102','jiangfeng_cluster_2.csv_correlation',3,''),(112,'2012-11-19 19:36:30',1,14,'101','jiangfeng_cluster_2.csv_correlation',3,''),(113,'2012-11-19 19:36:30',1,14,'100','jiangfeng_cluster_2.csv_correlation',3,''),(114,'2012-11-19 19:37:27',1,14,'95','jiangfeng_hub_2.csv_correlation',3,''),(115,'2012-11-19 19:37:27',1,14,'92','jiangfeng_scale-free_2.csv_correlation',3,''),(116,'2012-11-19 19:37:27',1,14,'85','jiangfeng_hub_2.csv_correlation',3,''),(117,'2012-11-20 14:06:24',1,12,'30','cluster_2.csv',2,'Changed dim.'),(118,'2012-11-20 14:06:32',1,12,'31','band_3.csv',2,'Changed dim.'),(119,'2012-11-20 14:09:36',1,14,'115','jiangfeng_cluster_3.csv_tiger',3,''),(120,'2012-11-20 14:12:00',1,12,'32','cluster_3.csv',2,'Changed sep.'),(121,'2012-11-20 14:12:08',1,12,'33','hub_3.csv',2,'Changed dim and sep.'),(122,'2012-11-20 14:48:19',1,14,'127','jiangfeng_cluster_4.csv_glasso',3,''),(123,'2012-11-20 14:48:19',1,14,'126','jiangfeng_cluster_4.csv_glasso',3,''),(124,'2012-11-20 14:48:19',1,14,'125','jiangfeng_cluster_4.csv_clime',3,''),(125,'2012-11-20 14:48:19',1,14,'124','jiangfeng_cluster_4.csv_glasso',3,''),(126,'2012-11-20 14:48:19',1,14,'123','jiangfeng_cluster_4.csv_tiger',3,''),(127,'2012-12-02 16:14:18',1,13,'4','tiger',2,'Changed create_date.'),(128,'2012-12-02 16:14:28',1,13,'3','clime',2,'Changed create_date.'),(129,'2012-12-02 16:14:34',1,13,'2','glasso',2,'Changed create_date.'),(130,'2012-12-02 16:14:42',1,13,'1','correlation',2,'Changed create_date.'),(131,'2012-12-02 21:49:55',1,13,'4','tiger',2,'Changed options_desc.'),(132,'2012-12-06 23:25:57',1,14,'138','han_band_6.csv_tiger',2,'Changed progress.'),(133,'2012-12-06 23:28:04',1,14,'138','han_band_6.csv_tiger',2,'Changed progress.'),(134,'2012-12-06 23:31:04',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(135,'2012-12-07 23:08:48',1,14,'129','jiangfeng_band_6.csv_tiger',2,'Changed progress.'),(136,'2012-12-08 17:52:36',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(137,'2012-12-08 17:54:17',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(138,'2012-12-08 18:05:10',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(139,'2012-12-08 18:05:59',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(140,'2012-12-09 16:33:35',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(141,'2012-12-09 16:35:49',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(142,'2012-12-09 16:38:22',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(143,'2012-12-09 16:44:11',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(144,'2012-12-09 16:54:45',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(145,'2012-12-09 17:00:23',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(146,'2012-12-09 17:28:45',1,14,'137','jiangfeng_hub_6.csv_tiger',2,'Changed progress.'),(147,'2012-12-09 21:03:21',1,14,'133','han_scale-free.csv_clime',2,'Changed options.'),(148,'2012-12-10 16:41:11',1,14,'143','jiangfeng_abalone.csv_tiger',2,'Changed progress.'),(149,'2012-12-10 16:44:26',1,14,'143','jiangfeng_abalone.csv_tiger',2,'Changed progress.'),(150,'2012-12-10 16:47:11',1,14,'144','jiangfeng_abalone.csv_glasso',2,'Changed progress.'),(151,'2012-12-10 16:49:27',1,14,'145','jiangfeng_abalone.csv_clime',3,''),(152,'2012-12-10 16:49:27',1,14,'144','jiangfeng_abalone.csv_glasso',3,''),(153,'2012-12-10 17:19:31',1,14,'141','jiangfeng_hub_2.csv_tiger',2,'Changed progress.'),(154,'2012-12-13 00:37:45',1,14,'147','jiangfeng_abalone.csv_tiger',3,''),(155,'2012-12-13 00:42:00',1,13,'4','tiger',2,'Changed path.'),(156,'2012-12-13 00:42:10',1,13,'3','clime',2,'Changed path.'),(157,'2012-12-13 00:42:19',1,13,'2','glasso',2,'Changed path.'),(158,'2012-12-13 00:42:26',1,13,'1','correlation',2,'Changed path.'),(159,'2012-12-13 00:42:56',1,14,'149','jiangfeng_test_hub.csv_tiger',2,'Changed progress.'),(160,'2012-12-13 00:43:36',1,14,'148','jiangfeng_abalone.csv_glasso',3,''),(161,'2012-12-13 00:49:19',1,14,'149','jiangfeng_test_hub.csv_tiger',2,'Changed progress.'),(162,'2012-12-13 01:40:55',1,14,'149','jiangfeng_test_hub.csv_tiger',2,'Changed progress.'),(163,'2012-12-13 01:42:02',1,14,'149','jiangfeng_test_hub.csv_tiger',2,'Changed progress.'),(164,'2012-12-13 01:58:23',1,14,'149','jiangfeng_test_hub.csv_tiger',2,'Changed progress.'),(165,'2012-12-13 02:16:48',1,14,'151','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(166,'2012-12-13 02:17:13',1,14,'151','jiangfeng_test_hub.csv_glasso',3,''),(167,'2012-12-13 02:17:13',1,14,'150','jiangfeng_test_hub.csv_glasso',3,''),(168,'2012-12-13 06:07:28',1,14,'153','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(169,'2012-12-13 06:08:03',1,14,'153','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(170,'2012-12-13 06:22:26',1,14,'153','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(171,'2012-12-13 06:23:13',1,14,'153','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(172,'2012-12-13 06:26:02',1,14,'153','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(173,'2012-12-13 06:34:25',1,14,'153','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(174,'2012-12-13 06:36:11',1,14,'154','jiangfeng_test_hub.csv_clime',2,'Changed progress.'),(175,'2012-12-13 06:41:35',1,14,'154','jiangfeng_test_hub.csv_clime',3,''),(176,'2012-12-13 06:41:35',1,14,'153','jiangfeng_test_hub.csv_glasso',3,''),(177,'2012-12-13 06:41:35',1,14,'152','jiangfeng_test_hub.csv_glasso',3,''),(178,'2012-12-13 06:41:51',1,14,'155','jiangfeng_test_hub.csv_glasso',3,''),(179,'2012-12-13 07:11:45',1,14,'157','jiangfeng_test_hub.csv_glasso',2,'Changed progress.'),(180,'2012-12-13 07:16:05',1,14,'157','jiangfeng_test_hub.csv_glasso',2,'Changed progress.');
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'user','auth','user'),(4,'message','auth','message'),(5,'content type','contenttypes','contenttype'),(6,'session','sessions','session'),(7,'publisher','books','publisher'),(8,'author','books','author'),(9,'book','books','book'),(10,'log entry','admin','logentry'),(11,'site','sites','site'),(12,'dataset','dataset','dataset'),(13,'program','program','program'),(14,'task','task','task');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_3da3d3d8` (`expire_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('100769982be95df1bb47cc2b2026dafd','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2012-11-22 21:56:27'),('9b05497f64f7ed1543ab17488f3517b3','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2012-12-22 14:50:44'),('1bad18e5838e95af233cf0ae92063ab4','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2012-12-23 20:47:47'),('ec9426d31c31f0136b791ce5c47786c0','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2012-12-26 23:15:48'),('7050e854585b9dc5579f227b64fccf94','NTIyYmZhNTE5OGY5NDMzMTRiMmViYjAzZWM2NTFkOGMwYjk4NzgzZjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQ91Lg==\n','2012-12-28 06:18:15'),('0c95d6087c786b1811626bfd73d8eddb','NjRiZDY0M2YzYTc4YTc0MDI0ZGYwZTNlYzQ4MDE4MmRmZDZlMDk2YTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQ51Lg==\n','2012-12-28 03:16:10'),('1f28b057093d2bc63dd7fff34f97e2f8','ZWEwMDU0ZDZhYjdjOWY3ZWQ2ZGMzMjhiNDBmMDkwNjBlMzkwOWViYjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQN1Lg==\n','2012-12-27 19:14:44'),('530becad967b9f69be601ba4b953770a','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2012-12-27 18:44:45'),('918eab944e97aaf54828243ed53fd117','NDE3ZTY1ZmZhM2I0MDA0MTdlNzk4Mjc1ODAzYTI0MjQ0OTMwYzM1MzqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQx1Lg==\n','2012-12-28 02:56:09'),('87fdf23b562a1f8c5194a90471914699','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2013-01-05 15:58:16'),('dee14b914c00c578abcef9b4266b02f3','MGFmNzJjZGI5MmFmZmZkZjJjMTMyNGE0YTc0MmJmOGIyNWY4MGZjNzqAAn1xAShVCnRlc3Rjb29r\naWVVBndvcmtlZFUSX2F1dGhfdXNlcl9iYWNrZW5kcQJVKWRqYW5nby5jb250cmliLmF1dGguYmFj\na2VuZHMuTW9kZWxCYWNrZW5kcQNVDV9hdXRoX3VzZXJfaWRxBIoBDXUu\n','2012-12-28 02:56:15'),('f805b7db661a200ec0e93513f077aaf2','MjM1OGU5OTdhNWUyZmVhOGJjZTljZGI0NTY0YTIwNDFjNzgwMjg1NjqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n','2012-12-31 18:54:16'),('ff70cd2c735ea1c5596dc29d1f7037d9','MGMxYThiZTMzNzNkYzEzYjExZDJhNjYwZThkODllMTI4YTVmZDY3MjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2013-01-01 00:00:21'),('ab6475df9384414bf274e872a80ad925','MjM1OGU5OTdhNWUyZmVhOGJjZTljZGI0NTY0YTIwNDFjNzgwMjg1NjqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n','2013-01-01 17:45:14');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_program`
--

DROP TABLE IF EXISTS `program_program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `program_program` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `path` varchar(200) NOT NULL,
  `name` varchar(50) NOT NULL,
  `options` varchar(100) DEFAULT NULL,
  `description` varchar(500) NOT NULL,
  `language` varchar(20) NOT NULL,
  `access` varchar(10) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `task_num` int(11) DEFAULT NULL,
  `options_desc` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `program_program_5d52dd10` (`owner_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_program`
--

LOCK TABLES `program_program` WRITE;
/*!40000 ALTER TABLE `program_program` DISABLE KEYS */;
INSERT INTO `program_program` VALUES (1,1,'/jiangfeng/correlation','correlation','','The correlation model estimates a sparse inverse covariance matrix using a thresholding correlation matrix.','R','public','2012-12-02 17:14:41',11,''),(2,1,'/jiangfeng/glasso','glasso','','The Glasso model estimates a sparse inverse covariance matrix using a lasso(L1) penalty.','R','public','2012-12-02 17:14:33',19,''),(3,1,'/jiangfeng/clime','clime','','The CLIME model applies a constrained l1 minimization approach to sparse precision matrix estimation.','R','public','2012-12-02 17:14:27',14,''),(4,1,'/jiangfeng/tiger','tiger','','The TIGER model applies a Tuning-Insensitive approach for estimating a sparse precision matrix.','R','public','2012-12-02 17:14:15',34,'-l LAMBDA, --lambda=LAMBDA parameter to control the regularization');
/*!40000 ALTER TABLE `program_program` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_task`
--

DROP TABLE IF EXISTS `task_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `data_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `progress` varchar(20) NOT NULL,
  `result_dir` varchar(200) NOT NULL,
  `options` varchar(100) DEFAULT NULL,
  `access` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_task_5d52dd10` (`owner_id`),
  KEY `task_task_2e8ca968` (`data_id`),
  KEY `task_task_7eef53e3` (`program_id`)
) ENGINE=MyISAM AUTO_INCREMENT=170 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_task`
--

LOCK TABLES `task_task` WRITE;
/*!40000 ALTER TABLE `task_task` DISABLE KEYS */;
INSERT INTO `task_task` VALUES (164,1,46,4,'2012-12-14 02:28:26','visualized','164','','public'),(165,1,47,4,'2012-12-14 02:34:03','visualized','165','','public'),(166,1,48,4,'2012-12-14 02:36:55','visualized','166','','public'),(167,1,50,4,'2012-12-14 02:38:04','visualized','167','','public'),(168,1,49,4,'2012-12-14 02:47:36','visualized','168','','public');
/*!40000 ALTER TABLE `task_task` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-28 16:49:10
