(0) [Prerequisite

- Disable SELinux.
- Disable firewalld or open the ports.

(1) Create the scrips to get group resources and monitor resources.

	/opt/nec/clusterpro/bin/ec-snmp.pl

(2) Modify /etc/snmp/snmpd.conf as below.

	rocommunity  public
	pass  .1.3.6.1.4.1.2021.255 /usr/bin/perl /opt/nec/clusterpro/bin/ec-snmp.pl
	dlmod clusterManagementMIB /opt/nec/clusterpro/lib/libclpmgtmib.so

(3) Type the following command.

	# snmpget -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.1.1.1
	UCD-SNMP-MIB::ucdavis.255.1.1.1.1 = STRING: "exec-B"

	# snmpget -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.1.1.2
	UCD-SNMP-MIB::ucdavis.255.1.1.1.2 = STRING: "Online"

	# snmpget -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2.1.1
	UCD-SNMP-MIB::ucdavis.255.2.1.1 = STRING: "fipw1"

	# snmpget -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2.1.2
	UCD-SNMP-MIB::ucdavis.255.2.1.2 = STRING: "Online"

	# snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255
	UCD-SNMP-MIB::ucdavis.255.1.1.1.1 = STRING: "exec-B"
	UCD-SNMP-MIB::ucdavis.255.1.1.1.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.1.1.2.1 = STRING: "fip-B"
	UCD-SNMP-MIB::ucdavis.255.1.1.2.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.1.2.1.1 = STRING: "exec-A"
	UCD-SNMP-MIB::ucdavis.255.1.2.1.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.1.2.2.1 = STRING: "md"
	UCD-SNMP-MIB::ucdavis.255.1.2.2.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.2.1.1 = STRING: "fipw1"
	UCD-SNMP-MIB::ucdavis.255.2.1.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.2.2.1 = STRING: "mdnw1"
	UCD-SNMP-MIB::ucdavis.255.2.2.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.2.3.1 = STRING: "mdw1"
	UCD-SNMP-MIB::ucdavis.255.2.3.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.2.4.1 = STRING: "miiw"
	UCD-SNMP-MIB::ucdavis.255.2.4.2 = STRING: "Online"
	UCD-SNMP-MIB::ucdavis.255.2.5.1 = STRING: "userw"
	UCD-SNMP-MIB::ucdavis.255.2.5.2 = STRING: "Online"

