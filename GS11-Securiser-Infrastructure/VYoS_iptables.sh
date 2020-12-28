#!/bin/bash
# => /config/scripts/vyos-postconfig-bootup.script

echo Local firewall :: IPTables Setup

# CLEAR
iptables -F INPUT
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Fichier Généré par la commande iptables-save sur le routeur VYoS
# Les filtrages effectués par le firewall sont présentées en détail dans le fichier de configuration "configuration_FW.txt".

# Generated by iptables-save v1.4.20 on Sat Dec 26 17:45:50 2020
*nat
:PREROUTING ACCEPT [5222:549433]
:INPUT ACCEPT [19:1280]
:OUTPUT ACCEPT [7127:428000]
:POSTROUTING ACCEPT [10070:611871]
:VYATTA_PRE_DNAT_HOOK - [0:0]
:VYATTA_PRE_SNAT_HOOK - [0:0]
-A PREROUTING -j VYATTA_PRE_DNAT_HOOK
-A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -m comment --comment DST-NAT-10 -j DNAT --to-destination 192.168.101.1
-A PREROUTING -i eth0 -p tcp -m tcp --dport 443 -m comment --comment DST-NAT-11 -j DNAT --to-destination 192.168.101.1
-A PREROUTING -i eth2.2 -p tcp -m tcp --dport 80 -m comment --comment DST-NAT-102 -j DNAT --to-destination 192.168.101.1
-A PREROUTING -i eth2.5 -p tcp -m tcp --dport 80 -m comment --comment DST-NAT-105 -j DNAT --to-destination 192.168.101.1
-A PREROUTING -i eth2.99 -p tcp -m tcp --dport 80 -m comment --comment DST-NAT-109 -j DNAT --to-destination 192.168.101.1
-A PREROUTING -i eth2.100 -p tcp -m tcp --dport 80 -m comment --comment DST-NAT-110 -j DNAT --to-destination 192.168.101.1
-A POSTROUTING -j VYATTA_PRE_SNAT_HOOK
-A POSTROUTING -s 192.168.2.0/24 -o eth0 -m comment --comment SRC-NAT-2 -j MASQUERADE
-A POSTROUTING -s 192.168.5.0/24 -o eth0 -m comment --comment SRC-NAT-5 -j MASQUERADE
-A POSTROUTING -s 192.168.99.0/24 -o eth0 -m comment --comment SRC-NAT-9 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -m comment --comment SRC-NAT-10 -j MASQUERADE
-A POSTROUTING -s 192.168.101.0/24 -o eth0 -m comment --comment SRC-NAT-11 -j MASQUERADE
-A POSTROUTING -s 192.168.101.0/24 -d 192.168.101.0/24 -o eth2.2 -p tcp -m comment --comment SRC-NAT-102 -j MASQUERADE
-A POSTROUTING -s 192.168.101.0/24 -d 192.168.101.0/24 -o eth2.5 -p tcp -m comment --comment SRC-NAT-105 -j MASQUERADE
-A POSTROUTING -s 192.168.101.0/24 -d 192.168.101.0/24 -o eth2.99 -p tcp -m comment --comment SRC-NAT-109 -j MASQUERADE
-A POSTROUTING -s 192.168.101.0/24 -d 192.168.101.0/24 -o eth2.100 -p tcp -m comment --comment SRC-NAT-110 -j MASQUERADE
-A VYATTA_PRE_DNAT_HOOK -j RETURN
-A VYATTA_PRE_SNAT_HOOK -j RETURN
COMMIT
# Completed on Sat Dec 26 17:45:50 2020
# Generated by iptables-save v1.4.20 on Sat Dec 26 17:45:50 2020
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:DMZ-IN - [0:0]
:DMZ-LOCAL - [0:0]
:DMZ-OUT - [0:0]
:LAN-IN - [0:0]
:LAN-LOCAL - [0:0]
:LAN-OUT - [0:0]
:VYATTA_FW_IN_HOOK - [0:0]
:VYATTA_FW_LOCAL_HOOK - [0:0]
:VYATTA_FW_OUT_HOOK - [0:0]
:VYATTA_POST_FW_FWD_HOOK - [0:0]
:VYATTA_POST_FW_IN_HOOK - [0:0]
:VYATTA_POST_FW_OUT_HOOK - [0:0]
:VYATTA_PRE_FW_FWD_HOOK - [0:0]
:VYATTA_PRE_FW_IN_HOOK - [0:0]
:VYATTA_PRE_FW_OUT_HOOK - [0:0]
:WAN-LOCAL - [0:0]
-A INPUT -j VYATTA_PRE_FW_IN_HOOK
-A INPUT -j VYATTA_FW_LOCAL_HOOK
-A INPUT -j VYATTA_POST_FW_IN_HOOK
-A FORWARD -j VYATTA_PRE_FW_FWD_HOOK
-A FORWARD -j VYATTA_FW_IN_HOOK
-A FORWARD -j VYATTA_FW_OUT_HOOK
-A FORWARD -j VYATTA_POST_FW_FWD_HOOK
-A OUTPUT -j VYATTA_PRE_FW_OUT_HOOK
-A OUTPUT -j VYATTA_POST_FW_OUT_HOOK
-A DMZ-IN -m comment --comment DMZ-IN-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A DMZ-IN -m comment --comment DMZ-IN-1011 -m state --state INVALID -j DROP
-A DMZ-IN -m comment --comment "DMZ-IN-10000 default-action drop" -j DROP
-A DMZ-LOCAL -m comment --comment DMZ-LOCAL-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A DMZ-LOCAL -m comment --comment DMZ-LOCAL-1011 -m state --state INVALID -j DROP
-A DMZ-LOCAL -p icmp -m comment --comment DMZ-LOCAL-1020 -m state --state NEW -m icmp --icmp-type 8 -j RETURN
-A DMZ-LOCAL -m comment --comment "DMZ-LOCAL-10000 default-action drop" -j DROP
-A DMZ-OUT -m comment --comment DMZ-OUT-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A DMZ-OUT -m comment --comment DMZ-OUT-1011 -m state --state INVALID -j DROP
-A DMZ-OUT -p icmp -m comment --comment DMZ-OUT-1020 -m state --state NEW -m icmp --icmp-type 8 -j RETURN
-A DMZ-OUT -d 192.168.101.1/32 -p tcp -m comment --comment DMZ-OUT-4000 -m state --state NEW -m multiport --dports 80,443 -j RETURN
-A DMZ-OUT -d 192.168.101.1/32 -p tcp -m comment --comment DMZ-OUT-5000 -m state --state NEW -m set --match-set NET-MANAGEMENT src -m tcp --dport 22 -j RETURN
-A DMZ-OUT -m comment --comment "DMZ-OUT-10000 default-action drop" -j DROP
-A LAN-IN -m comment --comment LAN-IN-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A LAN-IN -m comment --comment LAN-IN-1011 -m state --state INVALID -j DROP
-A LAN-IN -d 192.168.100.1/32 -p udp -m comment --comment LAN-IN-2010 -m state --state NEW -m set --match-set NET-LAN src -m multiport --dports 67,68 -j RETURN
-A LAN-IN -d 192.168.0.0/16 -m comment --comment LAN-IN-9000 -m set --match-set NET-GUESTS src -j DROP
-A LAN-IN -d 172.16.0.0/12 -m comment --comment LAN-IN-9001 -m set --match-set NET-GUESTS src -j DROP
-A LAN-IN -d 10.0.0.0/8 -m comment --comment LAN-IN-9002 -m set --match-set NET-GUESTS src -j DROP
-A LAN-IN -m comment --comment LAN-IN-9003 -m state --state NEW -m set --match-set NET-GUESTS src -j RETURN
-A LAN-IN -m comment --comment LAN-IN-9010 -m state --state NEW -m set --match-set NET-USER-SERV-MGMT src -j RETURN
-A LAN-IN -m comment --comment "LAN-IN-10000 default-action drop" -j DROP
-A LAN-LOCAL -m comment --comment LAN-LOCAL-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A LAN-LOCAL -m comment --comment LAN-LOCAL-1011 -m state --state INVALID -j DROP
-A LAN-LOCAL -p icmp -m comment --comment LAN-LOCAL-1020 -m state --state NEW -m icmp --icmp-type 8 -j RETURN
-A LAN-LOCAL -p tcp -m comment --comment LAN-LOCAL-1100 -m state --state NEW -m set --match-set NET-MANAGEMENT src -m tcp --dport 22 -j RETURN
-A LAN-LOCAL -p udp -m comment --comment LAN-LOCAL-1110 -m state --state NEW -m set --match-set NET-MANAGEMENT src -m udp --dport 161 -j RETURN
-A LAN-LOCAL -m comment --comment "LAN-LOCAL-10000 default-action drop" -j DROP
-A LAN-OUT -m comment --comment LAN-OUT-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A LAN-OUT -m comment --comment LAN-OUT-1011 -m state --state INVALID -j DROP
-A LAN-OUT -p icmp -m comment --comment LAN-OUT-1020 -m state --state NEW -m icmp --icmp-type 8 -j RETURN
-A LAN-OUT -d 192.168.100.1/32 -p udp -m comment --comment LAN-OUT-2010 -m state --state NEW -m set --match-set NET-LAN src -m multiport --dports 67,68 -j RETURN
-A LAN-OUT -d 192.168.100.1/32 -p tcp -m comment --comment LAN-OUT-2020 -m state --state NEW -m set --match-set NET-LAN src -m tcp --dport 53 -j RETURN
-A LAN-OUT -d 192.168.100.1/32 -p udp -m comment --comment LAN-OUT-2020 -m state --state NEW -m set --match-set NET-LAN src -m udp --dport 53 -j RETURN
-A LAN-OUT -d 192.168.100.1/32 -p tcp -m comment --comment LAN-OUT-2030 -m state --state NEW -m set --match-set NET-USER-SERV-MGMT src -m multiport --dports 88,135,139,389,445,464,636,3268,3269,49152:65535 -j RETURN
-A LAN-OUT -d 192.168.100.1/32 -p udp -m comment --comment LAN-OUT-2031 -m state --state NEW -m set --match-set NET-USER-SERV-MGMT src -m multiport --dports 88,123,137,138,389,636 -j RETURN
-A LAN-OUT -p tcp -m comment --comment LAN-OUT-2099 -m state --state NEW -m set --match-set NET-MANAGEMENT src -m multiport --dports 135,444,3389,5985 -m set --match-set NET-SERVERS dst -j RETURN
-A LAN-OUT -d 192.168.100.1/32 -m comment --comment LAN-OUT-2900 -j DROP
-A LAN-OUT -m comment --comment "LAN-OUT-10000 default-action drop" -j DROP
-A VYATTA_FW_IN_HOOK -i eth2.2 -j LAN-IN
-A VYATTA_FW_IN_HOOK -i eth2.5 -j LAN-IN
-A VYATTA_FW_IN_HOOK -i eth2.100 -j LAN-IN
-A VYATTA_FW_IN_HOOK -i eth2.99 -j LAN-IN
-A VYATTA_FW_IN_HOOK -i eth1 -j DMZ-IN
-A VYATTA_FW_LOCAL_HOOK -i eth2.5 -j LAN-LOCAL
-A VYATTA_FW_LOCAL_HOOK -i eth2.99 -j LAN-LOCAL
-A VYATTA_FW_LOCAL_HOOK -i eth2.100 -j LAN-LOCAL
-A VYATTA_FW_LOCAL_HOOK -i eth2.2 -j LAN-LOCAL
-A VYATTA_FW_LOCAL_HOOK -i eth0 -j WAN-LOCAL
-A VYATTA_FW_LOCAL_HOOK -i eth1 -j DMZ-LOCAL
-A VYATTA_FW_OUT_HOOK -o eth2.5 -j LAN-OUT
-A VYATTA_FW_OUT_HOOK -o eth2.99 -j LAN-OUT
-A VYATTA_FW_OUT_HOOK -o eth2.100 -j LAN-OUT
-A VYATTA_FW_OUT_HOOK -o eth2.2 -j LAN-OUT
-A VYATTA_FW_OUT_HOOK -o eth1 -j DMZ-OUT
-A VYATTA_POST_FW_FWD_HOOK -j ACCEPT
-A VYATTA_POST_FW_IN_HOOK -j ACCEPT
-A VYATTA_POST_FW_OUT_HOOK -j ACCEPT
-A VYATTA_PRE_FW_FWD_HOOK -j RETURN
-A VYATTA_PRE_FW_IN_HOOK -j RETURN
-A VYATTA_PRE_FW_OUT_HOOK -j RETURN
-A WAN-LOCAL -m comment --comment WAN-LOCAL-1010 -m state --state RELATED,ESTABLISHED -j RETURN
-A WAN-LOCAL -m comment --comment WAN-LOCAL-1011 -m state --state INVALID -j DROP
-A WAN-LOCAL -p icmp -m comment --comment WAN-LOCAL-1020 -m state --state NEW,RELATED,ESTABLISHED -m icmp --icmp-type 8 -j RETURN
-A WAN-LOCAL -m comment --comment "WAN-LOCAL-10000 default-action drop" -j DROP
COMMIT
# Completed on Sat Dec 26 17:45:50 2020
# Generated by iptables-save v1.4.20 on Sat Dec 26 17:45:50 2020
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:FW_CONNTRACK - [0:0]
:NAT_CONNTRACK - [0:0]
:VYATTA_CT_HELPER - [0:0]
:VYATTA_CT_IGNORE - [0:0]
:VYATTA_CT_OUTPUT_HOOK - [0:0]
:VYATTA_CT_PREROUTING_HOOK - [0:0]
:VYATTA_CT_TIMEOUT - [0:0]
-A PREROUTING -j VYATTA_CT_IGNORE
-A PREROUTING -j VYATTA_CT_HELPER
-A PREROUTING -j VYATTA_CT_TIMEOUT
-A PREROUTING -j VYATTA_CT_PREROUTING_HOOK
-A PREROUTING -j FW_CONNTRACK
-A PREROUTING -j NAT_CONNTRACK
-A PREROUTING -j NOTRACK
-A OUTPUT -j VYATTA_CT_IGNORE
-A OUTPUT -j VYATTA_CT_HELPER
-A OUTPUT -j VYATTA_CT_TIMEOUT
-A OUTPUT -j VYATTA_CT_OUTPUT_HOOK
-A OUTPUT -j FW_CONNTRACK
-A OUTPUT -j NAT_CONNTRACK
-A OUTPUT -j NOTRACK
-A FW_CONNTRACK -j ACCEPT
-A NAT_CONNTRACK -j ACCEPT
-A VYATTA_CT_HELPER -p tcp -m tcp --dport 1525 -j CT --helper tns
-A VYATTA_CT_HELPER -p tcp -m tcp --dport 1521 -j CT --helper tns
-A VYATTA_CT_HELPER -p udp -m udp --dport 111 -j CT --helper rpc
-A VYATTA_CT_HELPER -p tcp -m tcp --dport 111 -j CT --helper rpc
-A VYATTA_CT_HELPER -j RETURN
-A VYATTA_CT_IGNORE -j RETURN
-A VYATTA_CT_OUTPUT_HOOK -j RETURN
-A VYATTA_CT_PREROUTING_HOOK -j RETURN
-A VYATTA_CT_TIMEOUT -j RETURN
COMMIT
# Completed on Sat Dec 26 17:45:50 2020