NODE_NUMBER=1 

if [ $NODE_NUMBER -eq 1 ]; then BASE=0; fi
if [ $NODE_NUMBER -eq 2 ]; then BASE=6; fi
if [ $NODE_NUMBER -eq 3 ]; then BASE=12; fi
if [ $NODE_NUMBER -eq 4 ]; then BASE=18; fi

for VM in $(limactl list --format '{{.Name}}'); do
  echo "Konfiguruję sieć dla: $VM"
  
  # Używamy \$, aby bash na Macu nie zamienił tego na pustkę, 
  # zanim wyśle komendę do VM
  limactl shell $VM -- sudo bash -c "
    VM_ID=\$(hostname | grep -o '[0-9]\+$')
    FINAL_IP=\$(( $BASE + VM_ID ))
    
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
        addresses: [10.1.0.1]
EOF
    chmod 600 /etc/netplan/99-bridged-static.yaml
    netplan apply
  "
done