#!/usr/bin/perl 

#
# EXPRESSCLUSTER SNMP agent script for snmpd
#
# 2015.06.25 miyamoto KAZuyuki
#
# OID structure
# -------------
#
#           +--------- group resource table
#           | +------- index of failover group
#           | | +----- index of resource
#           | | | +--- 1:resource name 2:resource status
#           | | | |
#
# $base_oid.1.1.1.1
#
#           +--------- monitor resource table
#           | +------- index of monitor resource
#           | | +----- 1:monitor name 2:monitor status
#           | | |
#
# $base_oid.2.1.1
#

use strict;
use warnings;

my $debug = 0;
my $logfile = "/var/log/ec-snmp.log";
my $base_oid = ".1.3.6.1.4.1.2021.255";
my ($opt, $oid)=@ARGV;
my ($type, $value, $tmp);
my @grpname = ();
my @rscname = ();
my @rscstat = ();
my @monname = ();
my @monstat = ();

if ( $debug == 1 ) {
	open OUT, ">> $logfile";
}
&dbgprint ("[D] IN  oid=[$oid] opt=[$opt]\n");
open IN, "/opt/nec/clusterpro/bin/clpstat --local|";

while (<IN>){
	if (/<group>/){ last; }
}
while(<IN>){
	chomp;
	if(/<monitor>/){ last; }
	elsif(/^\s{4}(\S.*?)\s\.*:/){
		push @grpname, $1;
	}
	elsif(/^\s{6}(\S.*?)\s.*:\s(.*?)\s*$/){
		if(/^\s{6}current        :/){ next; }
		push @{$rscname[$#grpname]}, $1;
		push @{$rscstat[$#grpname]}, $2;
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
	# for group resource
	if    ( $oid =~ /$base_oid$/ )                         { $oid = $base_oid . ".1.1.1.1"; }
	elsif ( $oid =~ /$base_oid\.1$/ )                      { $oid = $base_oid . ".1.1.1.1"; }
	elsif ( $oid =~ /$base_oid\.1\.(\d+)$/ )               { $oid = $base_oid . ".1.$1.1.1"; }
	elsif ( $oid =~ /$base_oid\.1\.(\d+)\.(\d+)$/ )        { $oid = $base_oid . ".1.$1.$2.1"; }
	elsif ( $oid =~ /$base_oid\.1\.(\d+)\.(\d+)\.(\d+)$/ ) {
		if    ( $3 < 2 )             { $oid = $base_oid . ".1.$1.$2." . ($3+1); }
		elsif ( $2 < $#rscname + 1 ) { $oid = $base_oid . ".1.$1." . ($2+1) . ".1"; }
		elsif ( $1 < $#grpname + 1 ) { $oid = $base_oid . ".1." . ($1+1) . ".1.1"; }
		else                         { $oid = $base_oid . ".2.1.1"; }
	}
	# for monitor resource
	elsif ( $oid =~ /$base_oid\.2$/ )               { $oid = $base_oid . ".2.1.1"; }
	elsif ( $oid =~ /$base_oid\.2\.(\d+)$/ )        { $oid = $base_oid . ".2.$1.1"; }
	elsif ( $oid =~ /$base_oid\.2\.(\d+)\.(\d+)$/ ) {
		if    ( $2 < 2 )             { $oid = $base_oid . ".2.$1." . ($2+1); }
		elsif ( $1 < $#monname + 1 ) { $oid = $base_oid . ".2." . ($1+1) . ".1"; }
		else {
			&dbgprint ("[D] no next OID\n");
			exit;
		}
	}
}

#
# Processing OID
#
if ($oid =~ /$base_oid\.1\.(\d+)\.(\d+)\.(\d+)/){
	# index for failover-Group, group-Resource, resource-Detail(name & status)
	my $gidx = $1;
	my $ridx = $2;
	my $didx = $3;
	if (($gidx - 1 > $#grpname) or ($gidx -1 < 0)){
		&dbgprint ("[E] group index [". $gidx . "] is out of range for N of groups [" . ($#grpname + 1) . "]\n");
		exit;
	}
	if (($ridx - 1 > $#{$rscname[$#grpname]}) or ($ridx - 1 < 0)){
		&dbgprint ("[E] resource index [". $ridx . "] is out of range for N of groups [" . ($#{$rscname[$#grpname]} + 1) . "]\n");
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
elsif ($oid =~ /$base_oid\.2\.(\d+)\.(\d+)/){
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
