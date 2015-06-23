#!/usr/bin/perl 
use strict;
#use warnings;

my $logfile = "/root/project/ec-snmp/log";
#my $base_oid = ".1.3.6.1.4.1.119.2.3.207.1.2.4";
#my $base_oid = ".1.3.6.1.4.1.8072.2.255";
my $base_oid = ".1.3.6.1.4.1.2021.255";
my ($opt, $oid)=@ARGV;
my ($type, $value, $tmp);
my (@grpname, @rscname, @rscstat);

@grpname = ();
@rscname = ();
@rscstat = ();

open OUT, ">> $logfile";
print OUT (localtime . " [D] IN  oid=[". $oid . "]\n");

#&test;
#exit;

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
		if (/^\s{6}(\S.*?)\s.*:\s(.*)$/){
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
		print OUT (localtime . " [D] resource name : $value\n");
	}
	if ($didx == 2){
		$value = $rscstat[$gidx-1][$ridx-1];
		print OUT (localtime . " [D] resource stat : $value\n");
	}
}else{
	print OUT "[D] else\n";
}
print OUT (localtime . " [D] OUT oid=[". $oid . "] type=[" . $type . "] value=[". $value . "]\n");
print "$oid\n$type\n$value\n";
exit;

sub test { 
	if($oid eq "$base_oid.1.1.1.1"){
		$type = "gauge";
		$value = int rand 100;
	}else{
		$type = "string";
		$value = ("Die!","Shit!","Fuck!")[rand 3];
	}
	print "$oid\n$type\n$value\n";
	print OUT (localtime . " OUT oid=[". $oid . "] type=[" . $type . "] value=[". $value . "]\n");
}

