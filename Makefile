test-walk:
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.3
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.3
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.1.1
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.1.2
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.1.1.3
	snmpwalk -v 2c localhost -c public .1.3.6.1.4.1.2021.255.3.3.3


test-next:
	./ecgrprsc.pl -n .1.3.6.1.4.1.2021.255.1.1.1.2
	#./ecgrprsc.pl -n .1.3.6.1.4.1.2021.255.1

test-mon:
	./ecgrprsc.pl -n .1.3.6.1.4.1.2021.255.2

test:
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.1.1.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.1.1.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.1.2.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.1.2.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.1.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.1.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.2.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.2.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.2.3
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.3.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.2.3.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.3.1.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.3.1.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1.3.1.3
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.1.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.1.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.2.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.2.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.3.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.3.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.4.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.4.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.5.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.5.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.6.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2.6.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.2021.255.3

test-net-snmp:
	./ecgrprsc.pl -g .1.3.6.1.4.1.8072.2.255.1
	./ecgrprsc.pl -g .1.3.6.1.4.1.8072.2.255.2
	./ecgrprsc.pl -g .1.3.6.1.4.1.8072.2.255.3
	./ecgrprsc.pl -g .1.3.6.1.4.1.119.2.3.207.1.2.4.1024

