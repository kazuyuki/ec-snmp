# EXPRESSCLUSTER X and net-snmp conbination HOWTO

----

This document describes the procedure for stetting up EXPRESSCLUSTER X for net-snmp (snmpd) on Linux.

----

## Setup procedure

0. Install EXPRESSCLUSTER and configure the cluster. Install net-snmp package.

1. Put ec-snmp.pl to the path below.

		/opt/nec/clusterpro/bin/ec-snmp.pl

2. Modify /etc/snmp/snmpd.conf as below.

		rocommunity  public
		pass  .1.3.6.1.4.1.2021.255 /usr/bin/perl /opt/nec/clusterpro/bin/ec-snmp.pl

3. Restart snmpd

		# systemctl restart snmpd.service

4. Type the following command for testing.

		# snmpget -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1
		UCD-SNMP-MIB::ucdavis.255.1 = STRING: "cluster-k"

		# snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255
		UCD-SNMP-MIB::ucdavis.255.1 = STRING: "cluster-k"
		UCD-SNMP-MIB::ucdavis.255.2.1.1 = STRING: "cent71"
		UCD-SNMP-MIB::ucdavis.255.2.1.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.2.2.1 = STRING: "cent72"
		UCD-SNMP-MIB::ucdavis.255.2.2.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.3.1.1 = STRING: "grp-A"
		UCD-SNMP-MIB::ucdavis.255.3.1.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.3.1.3 = STRING: "cent71"
		UCD-SNMP-MIB::ucdavis.255.3.2.1 = STRING: "grp-B"
		UCD-SNMP-MIB::ucdavis.255.3.2.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.3.2.3 = STRING: "cent71"
		UCD-SNMP-MIB::ucdavis.255.4.1.1.1 = STRING: "exec-A"
		UCD-SNMP-MIB::ucdavis.255.4.1.1.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.4.1.2.1 = STRING: "md"
		UCD-SNMP-MIB::ucdavis.255.4.1.2.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.4.2.1.1 = STRING: "exec-B-1"
		UCD-SNMP-MIB::ucdavis.255.4.2.1.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.4.2.2.1 = STRING: "exec-B-2"
		UCD-SNMP-MIB::ucdavis.255.4.2.2.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.4.2.3.1 = STRING: "exec-B-3"
		UCD-SNMP-MIB::ucdavis.255.4.2.3.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.5.1.1 = STRING: "mdnw1"
		UCD-SNMP-MIB::ucdavis.255.5.1.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.5.2.1 = STRING: "mdw1"
		UCD-SNMP-MIB::ucdavis.255.5.2.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.5.3.1 = STRING: "miiw"
		UCD-SNMP-MIB::ucdavis.255.5.3.2 = STRING: "Online"
		UCD-SNMP-MIB::ucdavis.255.5.4.1 = STRING: "userw"
		UCD-SNMP-MIB::ucdavis.255.5.4.2 = STRING: "Online"

## OID structure

				     +--------- cluster name
				     |

		1.3.6.1.4.1.2021.255.1

				     +--------- server table
				     | +------- index of server
				     | | +----- 1:server name 2:server status
				     | | |

		1.3.6.1.4.1.2021.255.2.1.1

				     +--------- group table
				     | +------- index of group
				     | | +----- 1:group name 2:group status 3:current server
				     | | |

		1.3.6.1.4.1.2021.255.3.1.1

				     +--------- group resource table
				     | +------- index of failover group
				     | | +----- index of group resource in failover group
				     | | | +--- 1:resource name 2:resource status
				     | | | |

		1.3.6.1.4.1.2021.255.4.1.1.1

				     +--------- monitor resource table
				     | +------- index of monitor resource
				     | | +----- 1:monitor name 2:monitor status
				     | | |

		1.3.6.1.4.1.2021.255.5.1.1

## Revision history

	2015.06.25	miyamoto KAZuyuki	1st commit.
	2015.11.19	miyamoto Kazuyuki	Supporting Cluster name, Server name and status, Group name, status and current server.
