#!/usr/bin/perl
package Pshell;

use Exporter;

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw( get_server_id  );

# these are exported by default.
our @EXPORT = qw( get_server_id get_login_string list_all_servers add_server del_server add_attr add_attr_val);

sub get_server_id{
        my $rval='false';
        my $query = $_[0]->prepare("SELECT server_id,hostname FROM servers");
        $query->execute() or die($_[0]->errstr);
        while ( my ($id,$hostname) = $query->fetchrow_array()){
                if ($hostname =~ /$_[1]/){
                        $rval=$id;
                        last;
                }
        }
#	$db->disconnect();
        return $rval;
}

sub get_login_string{
        my $serverid=$_[1];
	my $ip_attr_id=$_[2];
	my $login_attr_id=$_[3];
	my $pass_attr_id=$_[4];
	my $port_attr_id=$_[5];
	my $keyauth_attr_id=$_[6];
	my $keypath_attr_id=$_[7];
	my ($ipaddr,$login,$password,$port)=(0,0,0,0);
	
	# Checking if RSA key auth is set for this server:
	my $query = $_[0]->prepare("SELECT attr_val FROM attr_val WHERE server_id = $serverid and attr_id = '$keyauth_attr_id'");
	$query->execute() or die($_[0]->errstr);
	my $keyauth = $query->fetchrow();

	# Getting the server IP:
	$query = $_[0]->prepare("SELECT attr_val FROM attr_val WHERE server_id = $serverid and attr_id = '$ip_attr_id'");
	$query->execute() or die($_[0]->errstr);
	$ipaddr = $query->fetchrow();

	# Getting the server login:
	$query = $_[0]->prepare("SELECT attr_val FROM attr_val WHERE server_id = $serverid and attr_id = '$login_attr_id'");
	$query->execute() or die($_[0]->errstr);
	$login = $query->fetchrow();

	# Getting the server pass:
	$query = $_[0]->prepare("SELECT attr_val FROM attr_val WHERE server_id = $serverid and attr_id = '$pass_attr_id'");
	$query->execute() or die($_[0]->errstr);
	$password = $query->fetchrow();

	# Getting SSH connection port:
	$query = $_[0]->prepare("SELECT attr_val FROM attr_val WHERE server_id = $serverid and attr_id = '$port_attr_id'");
	$query->execute() or die($_[0]->errstr);
	$port = $query->fetchrow();

	if ( "$keyauth" eq "NO"){
		$keypath = "false";
		return ($ipaddr,$login,$password,$port,$keypath);
	}
	elsif ( "$keyauth" eq "YES"){
		#Getting path to the RSA key on the file system
		$query = $_[0]->prepare("SELECT attr_val FROM attr_val WHERE server_id = $serverid and attr_id = '$keypath_attr_id'");
		$query->execute() or die($_[0]->errstr);
		$keypath = $query->fetchrow();
		return ($ipaddr,$login,$password,$port,$keypath);
	}
	else {
		print "Unknown value in attr_val table for atrribute $keyauth_attr_id for server with $serverid\n";
	}

}

sub list_all_servers{
	my $query = $_[0]->prepare("SELECT server_id,hostname FROM servers");
	$query->execute() or die($db->errstr);
	print "|-----------------------------|\n";
	print "| Server ID | Server Hostname |\n";
	print "|-----------------------------|\n";
	while ( my ($server_id,$hostname) = $query->fetchrow_array()){
	        print "| $server_id | "."$hostname |\n";
	}
	print "|-----------------------------|\n";
}

sub add_server{
        if ( @_  != "2" ){
                print "**        To add a new server to the database please use the foolowing command format:\n";
                print "          pshell-console add <hostname>\n";
	}	
        else {
		my $query = $_[0]->prepare("INSERT INTO servers(hostname) values('$_[1]')");
		$query->execute() or die($db->errstr);
       }
}

sub del_server{
        my $query = $_[0]->prepare("SELECT hostname FROM servers WHERE server_id = $_[1]");
        $query->execute() or die($_[0]->errstr);
        my ($hostname) = $query->fetchrow_array();
	print "The following server will be deleted:\n";
	print "$hostname\n";
	print "Are you sure you want to delete it [Y/N]?";
	my $answer = <STDIN>;
	chomp($answer);
	if ($answer eq "Y"){
		my $query = $_[0]->prepare("DELETE FROM servers WHERE server_id = $_[1]");
		$query->execute() or die($_[0]->errstr);
	}
	print "$hostname has been deleted\n"
}

sub add_attr{
        if ( @_  != "3" ){
                print "**        To add a new attribute to the database please use the foolowing command format:\n";
                print "          pshell-console add-attr <attribute name> <attribute description>";
        }
        else {
                my $query = $_[0]->prepare("INSERT INTO attributes (attr_name,attr_desc) VALUES ('$_[1]','$_[2]')");
                $query->execute() or die($db->errstr);
        }
}

sub add_attr_val{
	my $query = $_[0]->prepare("INSERT INTO attr_val(server_id,attr_id,attr_val) values('$_[1]','$_[2]','$_[3]')");
	$query->execute() or die($db->errstr);
}

1;
