-- Demo API test database
-- Version 1.1.4
-- Copyright (c) 2016 HostM Web Hosting
-- https://www.hostm.com/
--
-- Feel free to use or extract any portion of this code, whether or not you’re
-- a hosting client. If you’re looking for solid, reliable LiveCode hosting,
-- we hope you’ll consider joining us!


SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(88) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(88) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('Active','Disabled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Active',
  `first_name` varchar(88) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(88) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `status`, `first_name`, `last_name`) VALUES
(1, 'test@example.com', 'tVTQEDvg6uHq8cLvaEinAb', 'Active', 'Example', '例子');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


