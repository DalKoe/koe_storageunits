CREATE TABLE IF NOT EXISTS `storageunits` (
  `id` int(11) NOT NULL,
  `identifier` varchar(250) DEFAULT NULL,
  `pin` longtext DEFAULT NULL,
  `stashsave` longtext DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `storageunits` (`id`, `identifier`, `pin`, `stashsave`) VALUES
	(1, NULL, NULL, '999999'),
	(2, NULL, NULL, '999998'),
	(3, NULL, NULL, '999997'),
	(4, NULL, NULL, '999996'),
	(5, NULL, NULL, '999995'),
	(6, NULL, NULL, '999994'),
	(7, NULL, NULL, '999993'),
	(8, NULL, NULL, '999992'),
	(9, NULL, NULL, '999991'),
	(10, NULL, NULL, '999990'),
	(11, NULL, NULL, '999989'),
	(12, NULL, NULL, '999988'),
	(13, NULL, NULL, '999987',
	(14, NULL, NULL, '999986');
