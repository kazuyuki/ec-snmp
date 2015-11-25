test-script:
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.3.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.3.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.3.1.3
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.1.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.1.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.5.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.5.1.2

test-walk:
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.3
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.4
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.5
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.6
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2.3
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.3.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.3.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.4.1.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.4.1.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.5.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.5.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.5.3
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.5.4
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.5.5

test-next:
	./ec-snmp.pl -n .1.3.6.1.4.1.2021.255.1
	./ec-snmp.pl -n .1.3.6.1.4.1.2021.255.5.4.1
	./ec-snmp.pl -n .1.3.6.1.4.1.2021.255.5.4.2

test:
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.1.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.1.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.1.2.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.1.2.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.2.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.2.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.2.3
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.3.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.2.3.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.3.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.3.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.4.3.1.3
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.1.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.1.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.2.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.2.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.3.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2.3.2
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.1
	./ec-snmp.pl -g .1.3.6.1.4.1.2021.255.2

test-net-snmp:
	./ec-snmp.pl -g .1.3.6.1.4.1.8072.2.255.1
	./ec-snmp.pl -g .1.3.6.1.4.1.8072.2.255.2
	./ec-snmp.pl -g .1.3.6.1.4.1.8072.2.255.3
	./ec-snmp.pl -g .1.3.6.1.4.1.119.2.3.207.1.2.4.1024

