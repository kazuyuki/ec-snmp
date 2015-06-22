#!/usr/bin/perl 
use strict;
#use warnings;

my $logfile = "/root/project/ec-snmp/log";
#my $base_oid = ".1.3.6.1.4.1.119.2.3.207.1.2.4";
#my $base_oid = ".1.3.6.1.4.1.8072.2.255";
my $base_oid = ".1.3.6.1.4.1.2021.255";

my ($opt, $oid)=@ARGV;
my ($type, $value, @grpname);
push @grpname, "";

open OUT, ">> $logfile";
print OUT (localtime . " IN  oid=[". $oid . "]\n");

#&test;
#exit;

if ($oid =~ /$base_oid\.(\d+)$/){
	my $idx = $1;

	open IN, "/opt/nec/clusterpro/bin/clpstat --local|";
	while(<IN>){
		if(/<group>/){
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
	}

	$type = "string";
	$value = $grpname[$idx];

	#print OUT "[D]====\n$oid\n$type\n$value\n[D]====\n";
	print OUT (localtime . " OUT oid=[". $oid . "] type=[" . $type . "] value=[". $value . "]\n");
	print "$oid\n$type\n$value\n";
}else{
	print "[D] else\n";
}

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

