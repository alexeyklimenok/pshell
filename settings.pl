#!/usr/bin/perl
use DBI;

#timeout to wait for a SSH
$timeout=1;
#MySQL server address
$HOST='localhost';
#MySQL server port
$PORT=3306;
#Servers Inventory database name
$DBNAME='mydb';
#MySQL user for connection to Servers Inventory database
$USER="user";
#MySQL user pass for connection to Servers Inventory database 
$PASS="password";
#MySQL connection string
$db = DBI->connect("dbi:mysql:$DBNAME:$HOST:$PORT",$USER,$PASS) or die "Cannot connect to $DBNAME: $!\n";

#################################################################################################################
#################################################################################################################
# "Pshell" operates with the following variables to login on the server:
# $ipaddr - a server IP address
# $login - login used to access a server
# $password - password used to access a server
# $port - SSH connection port
# $keyauth - could be 0 or 1. If it's set to 1, RSA key should be use to login, otherwise login and pass
# $keypath - exact path to the RSA pub key if $keyauth is set to "1"
#
# To allow "Pshell" get proper values for these variables from the database you need need to 
# define relations between attribute name and attribute ID, which is defined in "attributes" MySQL table
#
# For example:
# if you defined a new attriute in "attributes" MySQL table:
#
# Attribute name: mysuperlogin
# ID=17
#
# And you want to use value of this attribute to login on the server you should set the following
# in this configuration file:
# $login_attr_id = "17"
#
# I know this is a bit complicated, but you are free to modify "Pshell" and its database according to your needs
# Have fun)))) 
#################################################################################################################

$ip_attr_id="1";
$login_attr_id = "2";
$pass_attr_id="3";
$port_attr_id="4";
$keyauth_attr_id="5";
$keypath_attr_id="6";
