# Ustaw numer fizycznego noda (1, 2, 3 lub 4)
NODE_NUMBER=4 

if [ $NODE_NUMBER -eq 1 ]; then BASE=0; fi  # OPOVMKUB01 -> 10.1.1.1
if [ $NODE_NUMBER -eq 2 ]; then BASE=6; fi  # OPOVMKUB01 -> 10.1.1.7
if [ $NODE_NUMBER -eq 3 ]; then BASE=12; fi # OPOVMKUB01 -> 10.1.1.13
if [ $NODE_NUMBER -eq 4 ]; then BASE=18; fi # OPOVMKUB01 -> 10.1.1.19

for VM in $(limactl list --format '{{.Name}}'); do
  echo "Konfiguruję sieć dla: $VM"
  
  limactl shell $VM -- sudo bash -c "
    # Wyciąga cyfry z końca nazwy (np. 01, 02)
    VM_ID=\$(hostname | grep -o '[0-9]\+$')
    # Usuwa wiodące zero, aby Bash nie pomyślał, że to liczba ósemkowa
    VM_ID_CLEAN=\$((10#\$VM_ID))
    
    FINAL_IP=\$(( $BASE + VM_ID_CLEAN ))
    
    cat > /etc/netplan/99-bridged-static.yaml << EOF
network:
  version: 2
  ethernets:
    en1:
      dhcp4: false
      addresses: [10.1.1.\${FINAL_IP}/16]
      routes:
        - to: default
          via: 10.1.0.1
      nameservers:
        addresses: [10.1.53.53]
EOF
    chmod 600 /etc/netplan/99-bridged-static.yaml
    netplan apply
  "
done