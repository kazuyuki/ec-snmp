#!/usr/bin/perl 

#
# EXPRESSCLUSTER SNMP agent script for snmpd
#
# 2015.06.25 miyamoto KAZuyuki
# 2015.11.19 miyamoto KAZuyuki
#

use strict;
use warnings;

my $debug = 0;
my $logfile = "/var/log/ec-snmp.log";
my $base_oid = ".1.3.6.1.4.1.2021.255";
my ($opt, $oid)=@ARGV;
my ($type, $value, $tmp);

my $clustername = "";
my @srvname = ();
my @srvstat = ();
my @grpname = ();
my @grpstat = ();
my @grpcur  = ();	# current node of the group
my @rscname = ();
my @rscstat = ();
my @monname = ();
my @monstat = ();

if ( $debug == 1 ) {
	open OUT, ">> $logfile";
}
&dbgprint ("[D] IN  oid=[$oid] opt=[$opt]\n");
open IN, "/opt/nec/clusterpro/bin/clpstat --local|";

while(<IN>){
	if(/<server>/){ last; }
	elsif(/^  Cluster : (.*?)$/){
		$clustername = $1;
	}
}
while (<IN>){
	if (/<group>/){ last; }
	elsif(/^\s{6}/){ next; }
	elsif(/   .(\S.*?)\s\.*: (.*?)\s*$/){
		push @srvname, $1;
		push @srvstat, $2;
	}
}

while(<IN>){
	chomp;
	if(/<monitor>/){ last; }
	elsif(/^\s{4}(\S.*?)\s\.*: (.*?)\s*$/){
		push @grpname, $1;
		push @grpstat, $2;
	}
	elsif(/^\s{6}current        : (.*?)\s*$/){
		push @grpcur,  $1;
	}
	elsif(/^\s{6}(\S.*?)\s.*:\s(.*?)\s*$/){
		push @{$rscname[$#grpname]}, $1;
		push @{$rscstat[$#grpname]}, $2;
	}
	else{
		&dbgprint("[D] Unkown line in output of clpstat. [$_]\n");
	}
}

while(<IN>){
	chomp;
	if(/^ =+$/){ last; }
	m/^\s{4}(\S.*?)\s.*: (.*?)\s*$/;
	push @monname, $1;
	push @monstat, $2;
}

#
# Processing "-n" (next) option
#
if ( $opt eq "-n" ) {
	# for cluster name
	if ( $oid =~ /$base_oid$/ )			{ $oid = $base_oid . ".1"; }
	elsif ( $oid =~ /$base_oid\.1$/)		{ $oid = $base_oid . ".2.1.1"; }

	# for server
	elsif ( $oid =~ /$base_oid\.2$/ )               { $oid = $base_oid . ".2.1.1"; }
	elsif ( $oid =~ /$base_oid\.2\.(\d+)$/ )        { $oid = $base_oid . ".2.$1.1"; }
	elsif ( $oid =~ /$base_oid\.2\.(\d+)\.(\d+)$/ ) {
		if    ( $2 < 2 )             		{ $oid = $base_oid . ".2.$1." . ($2+1); }
		elsif ( $1 < $#srvname + 1 )		{ $oid = $base_oid . ".2." . ($1+1) . ".1"; }
		else					{ $oid = $base_oid . ".3.1.1"; }
	}

	# for group
	elsif ( $oid =~ /$base_oid\.3$/ )               { $oid = $base_oid . ".3.1.1"; }
	elsif ( $oid =~ /$base_oid\.3\.(\d+)$/ )        { $oid = $base_oid . ".3.$1.1"; }
	elsif ( $oid =~ /$base_oid\.3\.(\d+)\.(\d+)$/ ) {
		if    ( $2 < 3 )             		{ $oid = $base_oid . ".3.$1." . ($2+1); }
		elsif ( $1 < $#grpname + 1 )		{ $oid = $base_oid . ".3." . ($1+1) . ".1"; }
		else					{ $oid = $base_oid . ".4.1.1.1"; }
	}

	# for group resource
	elsif ( $oid =~ /$base_oid$/ )			{ $oid = $base_oid . ".4.1.1.1"; }
	elsif ( $oid =~ /$base_oid\.4$/ )		{ $oid = $base_oid . ".4.1.1.1"; }
	elsif ( $oid =~ /$base_oid\.4\.(\d+)$/ )	{ $oid = $base_oid . ".4.$1.1.1"; }
	elsif ( $oid =~ /$base_oid\.4\.(\d+)\.(\d+)$/ )	{ $oid = $base_oid . ".4.$1.$2.1"; }
	elsif ( $oid =~ /$base_oid\.4\.(\d+)\.(\d+)\.(\d+)$/ ) {
		if    ( $3 < 2 )			{ $oid = $base_oid . ".4.$1.$2." . ($3+1);}
		elsif ( $2 < @{$rscname[($1 - 1)]} ) 	{ $oid = $base_oid . ".4.$1." . ($2+1) . ".1";}
		elsif ( $1 < $#grpname + 1 ) 		{ $oid = $base_oid . ".4." . ($1+1) . ".1.1";}
		else					{ $oid = $base_oid . ".5.1.1"; }
	}
	# for monitor resource
	elsif ( $oid =~ /$base_oid\.5$/ )               { $oid = $base_oid . ".5.1.1"; }
	elsif ( $oid =~ /$base_oid\.5\.(\d+)$/ )        { $oid = $base_oid . ".5.$1.1"; }
	elsif ( $oid =~ /$base_oid\.5\.(\d+)\.(\d+)$/ ) {
		if    ( $2 < 2 )			{ $oid = $base_oid . ".5.$1." . ($2+1); }
		elsif ( $1 < $#monname + 1 )		{ $oid = $base_oid . ".5." . ($1+1) . ".1"; }
		else {
			&dbgprint ("[D] no next OID for monitor resource \n");
			exit;
		}
	}
	else {
		&dbgprint ("[D] no next OID\n");
		exit;
	}
}

#
# Processing OID
#
if ($oid =~ /$base_oid\.1$/){
	$type = "string";
	$value = $clustername;
}
elsif ($oid =~ /$base_oid\.2\.(\d+)\.(\d+)$/){
	# index for server, server detail (name and status) 
	my $sidx = $1;
	my $didx = $2;
	if (($sidx -1 > $#srvname) or ($sidx -1 < 0)){
		&dbgprint ("[E] server index [". $sidx . "] is out of range for N of servers [" . ($#srvname + 1) . "]\n");
		exit;
	}
	$type = "string";
	if    ($didx == 1){ $value = $srvname[$sidx-1]; }
	elsif ($didx == 2){ $value = $srvstat[$sidx-1]; }
	else {
		dbgprint ("[E] server detail index [$didx] is out of range (1..2)\n");
		exit;
	}
}
elsif ($oid =~ /$base_oid\.3\.(\d+)\.(\d+)$/){
	my $gidx = $1;
	my $didx = $2;
	if (($gidx -1 > $#grpname) or ($gidx -1 < 0)){
		&dbgprint ("[E] group index [". $gidx . "] is out of range for N of groups [" . ($#grpname + 1) . "]\n");
		exit;
	}
	$type = "string";
	if    ($didx == 1){ $value = $grpname[$gidx-1]; }
	elsif ($didx == 2){ $value = $grpstat[$gidx-1]; }
	elsif ($didx == 3){ $value = $grpcur[$gidx-1]; }
	else {
		&dbgprint ("[E] group detail index [". $gidx . "] is out of range for N of groups [" . ($#grpname + 1) . "]\n");
		exit;
	}
}
elsif ($oid =~ /$base_oid\.4\.(\d+)\.(\d+)\.(\d+)$/){
	# index for failover-Group, group-Resource, resource-Detail(name & status)
	my $gidx = $1;
	my $ridx = $2;
	my $didx = $3;
	if (($gidx - 1 > $#grpname) or ($gidx -1 < 0)){
		&dbgprint ("[E] group index [". $gidx . "] is out of range for N of groups [" . ($#grpname + 1) . "]\n");
		exit;
	}
	if (($ridx - 1 > $#{$rscname[$gidx -1]}) or ($ridx - 1 < 0)){
		&dbgprint ("[E] resource index [". $ridx . "] is out of range for N of resources [" . ($#{$rscname[$gidx - 1]} + 1) . "]\n");
		exit;
	}
	$type = "string";
	if    ( $didx == 1 ){ $value = $rscname[$gidx-1][$ridx-1]; }
	elsif ( $didx == 2 ){ $value = $rscstat[$gidx-1][$ridx-1]; }
	else {
		dbgprint ("[E] detail index [$didx] is out of range (1..2)\n");
		exit;
	}
}
elsif ($oid =~ /$base_oid\.5\.(\d+)\.(\d+)$/){
	# index for monitor, detail (name & status)
	my $midx = $1;
	my $didx = $2;
	while(<IN>){
		if(/<monitor>/){ last; }
	}
	if(($midx - 1 > $#monname) or ($midx - 1 < 0)){
		dbgprint ("[E] monitor index [" . $midx . "] is out of range for N of monitors [" . ($#monname + 1) ."]\n");
		exit;
	}
	$type = "string";
	if    ( $didx == 1 ) { $value = $monname[$midx - 1]; }
	elsif ( $didx == 2 ) { $value = $monstat[$midx - 1]; }
	else {
		dbgprint ("[E] detail index [$didx] is out of range (1..2)\n");
		exit;
	}
}else{
	&dbgprint ("[D] else\n");
	exit;
}
&dbgprint ("[D] OUT oid=[". $oid . "] type=[" . $type . "] value=[". $value . "]\n");
print "$oid\n$type\n$value\n";
exit;

#
# Debug logging
#
sub dbgprint {
	if ($debug == 1) {
		print OUT (localtime . " " . $_[0]);
	}
}
