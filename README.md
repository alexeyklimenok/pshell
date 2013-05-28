Pshell
======

Pshell is perl script that allows you to login on your servers via SSH just entering the server hostname. All needed info like server IP, SSH port, password etc. is stored in MySQL database.

##Requirements
- ** Ubuntu >= 12.04 (Scrips were not tested on other Linux distributions, but probably will work)
- ** MySQL server >=5.0 with InnoDB support
- ** Perl DBI, Expect modules
- ** Brain to get the things working )))
##Installation
Unfortunately all steps should be done manually, because package isn't ready yet.

Download the latest stable release of Pshell from github:
```
cd /root/
git clone https://github.com/alexeyklimenok/pshell.git
```
Create a new MySQL database and user to store information about the servers
```
mysql -e "create database server;"
mysql -e "CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON \`servers\`.* TO 'newuser'@'localhost'"
```
Import SQL dump with the tables structure
```
mysql server < /root/pshell/servers.sql
```
Copy necessary Pshell files to perl include path. Here is example for Ubuntu:
```
cp /root/pshell/{Pshell.pm,settings.pl} /etc/perl/
```
Edit database connection settings in /etc/perl/settings.pl
```
Edit database connection settings in /etc/perl/settings.pl
```
vim /etc/perl/settings.pl
```
Also you can modify Pshell profile (it contains all aliases and environment settings that are imported when you login on a server. Syntax the same as in bashrc). Path to the profile can be changed in /etc/perl/settings.pl. By default it's set to:
```
/root/pshell/.pshell_profile
```
Add /root/pshell/ to $PATH
```
export PATH=$PATH:/root/pshell/
```
Have fun)))
