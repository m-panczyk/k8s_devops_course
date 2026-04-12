# 2025-03-23 09:16:18 by RouterOS 7.18.2
# software id = WFM1-CBPK
#
# model = CRS354-48G-4S+2Q+
# serial number = HK60AM6CECJ
/interface bridge
add name=bridge-wan
/interface ethernet
set [ find default-name=ether1 ] auto-negotiation=no comment=Node1-P1
set [ find default-name=ether2 ] auto-negotiation=no comment=Node2-P1
set [ find default-name=ether9 ] comment=PD1/124
set [ find default-name=ether11 ] comment=PD1/122
set [ find default-name=ether12 ] comment=PD1/123
set [ find default-name=ether13 ] auto-negotiation=no comment=Node1-P2
set [ find default-name=ether14 ] auto-negotiation=no comment=Node2-P2
set [ find default-name=ether21 ] comment=PD1/120
set [ find default-name=ether22 ] comment=PD1/121
set [ find default-name=ether23 ] comment=PD1/119
set [ find default-name=ether24 ] comment=PD1/118
set [ find default-name=ether25 ] auto-negotiation=no comment=Node3-P1
set [ find default-name=ether26 ] auto-negotiation=no comment=Node4-P1
set [ find default-name=ether37 ] auto-negotiation=no comment=Node3-P2
set [ find default-name=ether38 ] auto-negotiation=no comment=Node4-P2
set [ find default-name=ether48 ] comment=WAN-ETH
set [ find default-name=sfp-sfpplus1 ] comment=WAN-FIBRE
/interface bonding
add mode=802.3ad name=bond1 slaves=ether1,ether13 transmit-hash-policy=\
    layer-2-and-3
add mode=802.3ad name=bond2 slaves=ether2,ether14 transmit-hash-policy=\
    layer-2-and-3
add mode=802.3ad name=bond3 slaves=ether25,ether37 transmit-hash-policy=\
    layer-2-and-3
add mode=802.3ad name=bond4 slaves=ether26,ether38 transmit-hash-policy=\
    layer-2-and-3
/port
set 0 name=serial0
/interface bridge port
add bridge=bridge-wan interface=sfp-sfpplus1
add bridge=bridge-wan interface=bond1
add bridge=bridge-wan interface=bond2
add bridge=bridge-wan interface=bond3
add bridge=bridge-wan interface=bond4
add bridge=bridge-wan interface=ether12
add bridge=bridge-wan interface=ether11
add bridge=bridge-wan interface=ether48
add bridge=bridge-wan interface=ether23
add bridge=bridge-wan interface=ether24
add bridge=bridge-wan interface=ether9
add bridge=bridge-wan interface=ether22
add bridge=bridge-wan interface=ether21
/ip address
add address=10.1.53.53/16 interface=bridge-wan
/ip route
add gateway=10.1.0.1
/ip dns
set servers=8.8.8.8,1.1.1.1 allow-remote-requests=yes
/ip dns static
add name=ophwnode01.internal address=10.1.255.201 ttl=1d
add name=ophwnode02.internal address=10.1.255.202 ttl=1d
add name=ophwnode03.internal address=10.1.255.203 ttl=1d
add name=ophwnode04.internal address=10.1.255.204 ttl=1d
add name=opvmkub01.internal address=10.1.1.1 ttl=1d
add name=opvmkub02.internal address=10.1.1.2 ttl=1d
add name=opvmkub03.internal address=10.1.1.3 ttl=1d
add name=opvmkub04.internal address=10.1.1.4 ttl=1d
add name=opvmkub05.internal address=10.1.1.5 ttl=1d
add name=opvmkub06.internal address=10.1.1.6 ttl=1d
add name=opvmkub07.internal address=10.1.1.7 ttl=1d
add name=opvmkub08.internal address=10.1.1.8 ttl=1d
add name=opvmkub09.internal address=10.1.1.9 ttl=1d
add name=opvmkub10.internal address=10.1.1.10 ttl=1d
add name=opvmkub11.internal address=10.1.1.11 ttl=1d
add name=opvmkub12.internal address=10.1.1.12 ttl=1d
add name=opvmkub13.internal address=10.1.1.13 ttl=1d
add name=opvmkub14.internal address=10.1.1.14 ttl=1d
add name=opvmkub15.internal address=10.1.1.15 ttl=1d
add name=opvmkub16.internal address=10.1.1.16 ttl=1d
add name=opvmkub17.internal address=10.1.1.17 ttl=1d
add name=opvmkub18.internal address=10.1.1.18 ttl=1d
add name=opvmkub19.internal address=10.1.1.19 ttl=1d
add name=opvmkub20.internal address=10.1.1.20 ttl=1d
add name=opvmkub21.internal address=10.1.1.21 ttl=1d
add name=opvmkub22.internal address=10.1.1.22 ttl=1d
add name=opvmkub23.internal address=10.1.1.23 ttl=1d
add name=opvmkub24.internal address=10.1.1.24 ttl=1d
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/system note
set show-at-login=no
/system routerboard settings
set enter-setup-on=delete-key
