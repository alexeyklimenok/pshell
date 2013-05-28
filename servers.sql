CREATE TABLE servers(
server_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
hostname VARCHAR(80) NOT NULL,
PRIMARY KEY (server_id)
) ENGINE=InnoDB;

CREATE TABLE attributes(
attr_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
attr_name VARCHAR(30) NOT NULL,
attr_desc VARCHAR(50) NULL,
PRIMARY KEY (attr_id)
) ENGINE=InnoDB;

CREATE TABLE attr_val(
server_id INT(10) UNSIGNED NOT NULL,
attr_id INT(10) UNSIGNED NOT NULL,
attr_val VARCHAR(80),
FOREIGN KEY (server_id) REFERENCES servers(server_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
FOREIGN KEY (attr_id) REFERENCES attributes(attr_id)
ON UPDATE CASCADE
ON DELETE CASCADE
) ENGINE = InnoDB;

/*!40000 ALTER TABLE `attributes` DISABLE KEYS */;
INSERT INTO `attributes` VALUES (1,'ipaddr','A server IP address'),(2,'login','A login to access server'),(3,'password','A password to access server'),(4,'port','SSH connection port'),(5,'keyauth','Connection using RSA key'),(6,'keypath','Path to RSA key');
/*!40000 ALTER TABLE `attributes` ENABLE KEYS */;
