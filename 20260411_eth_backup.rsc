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
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/system note
set show-at-login=no
/system routerboard settings
set enter-setup-on=delete-key
