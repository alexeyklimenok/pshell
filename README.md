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
vim /etc/perl/settings.pl
```
Also you can modify Pshell profile (it contains all aliases and environment settings that are imported when you login on a server. Syntax the same as in bashrc). Path to the profile can be changed in /etc/perl/settings.pl. By default it's set to:
```
/root/pshell/.pshell_profile
```
Add /root/pshell/ to $PATH
```
export PATH=$PATH:/root/pshell
```
Have fun)))

##Basic usage examples

Adding a new server to the database:
```
pshell-console add server.domain.com 192.168.1.1 root mysuperpass 22 NO
```
Adding the server with RSA key authorization:
```
pshell-console add host.site.com 10.10.1.1 root UNDEFINED 22 YES "/path/to/RSA/key/"
```
List all servers stored in database:
```
pshell-console list
```
Get all info about a server
```
pshell-console get-info host.site
```
Login on a server
```
pshell server.domain.com
```

Please note it's not necessary to pass exact server hostname to pshell. For example if your server hostname is server1.domain.com you can access it:
```
pshell server1
pshell server1.domain
pshell server1.domain.com
```
So, you just need to pass some unique part of server hostname to pshell to access it))
