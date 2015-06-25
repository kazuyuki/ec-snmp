#!/usr/bin/perl 
use strict;
#use warnings;

my $logfile = "/root/project/ec-snmp/log";
my $base_oid = ".1.3.6.1.4.1.2021.255";
my ($opt, $oid)=@ARGV;
my ($type, $value, $tmp);
my @grpname = ();
my @rscname = ();
my @rscstat = ();

open OUT, ">> $logfile";
print OUT (localtime . " [D] IN  oid=[". $oid . "]\n");
open IN, "/opt/nec/clusterpro/bin/clpstat --local|";
if ($oid =~ /$base_oid\.1\.(\d+)\.(\d+)\.(\d+)/){
	# index for group, resource, detail(name & status)
	my $gidx = $1;
	my $ridx = $2;
	my $didx = $3;
	while (<IN>){
		if (/<group>/){
			last;
		}
	}
	while(<IN>){
		chomp;
		if(/<monitor>/){
			last;
		}
		if (/^\s{4}(\S.*?)\s\.*:/){
			push @grpname, $1;
		}
		if (/^\s{6}(\S.*?)\s.*:\s(.*?)\s*$/){
			if (/^\s{6}current        :/){
				next;
			}
			push @{$rscname[$#grpname]}, $1;
			push @{$rscstat[$#grpname]}, $2;
		}
	}
	if (($gidx - 1 > $#grpname) or ($gidx -1 < 0)){
		printf OUT (localtime . " [E] group index [%d] is out of range for N of groups [%d]\n", $gidx, $#grpname + 1);
		exit;
	}
	if (($ridx - 1 > $#{$rscname[$#grpname]}) or ($ridx - 1 < 0)){
		printf OUT (localtime . " [E] resource index [%d] is out of range for N of resources [%d]\n", $ridx, $#{$rscname[$#grpname]} + 1);
		exit;
	}
	$type = "string";
	if ($didx == 1){
		$value = $rscname[$gidx-1][$ridx-1];
	}
	elsif ($didx == 2){
		$value = $rscstat[$gidx-1][$ridx-1];
	}
	else {
		printf OUT (localtime . " [E] detail index [$didx] is out of range (1..2)\n");
	}
}
elsif ($oid =~ /$base_oid\.2\.(\d+)\.(\d+)/){
	# index for monitor, detail (name & status)
	my $midx = $1;
	my $didx = $2;
	while(<IN>){
		if(/<monitor>/){
			last;
		}
	}
	my @monname = ();
	my @monstat = ();
	while(<IN>){
		chomp;
		if(/^ =+$/){
			last;
		}
		m/^\s{4}(\S.*?)\s.*: (.*?)\s*$/;
		push @monname, $1;
		push @monstat, $2;
	}
	if(($midx - 1 > $#monname) or ($midx - 1 < 0)){
		printf OUT (localtime . " [E] monitor index [%d] is out of range for N of monitors [%d]\n", $midx, $#monname + 1);
		exit;
	}
	$type = "string";
	if ($didx == 1){
		$value = $monname[$midx - 1];
	}
	if ($didx == 2){
		$value = $monstat[$midx - 1];
	}
}else{
	print OUT (localtime . " [D] else\n");
	exit;
}
print OUT (localtime . " [D] OUT oid=[". $oid . "] type=[" . $type . "] value=[". $value . "]\n");
print "$oid\n$type\n$value\n";
exit;
