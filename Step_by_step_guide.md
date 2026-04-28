### 1. Przygotowanie hostów macOS

```bash
# Na każdym Mac Pro:

# 1a. Sudo bez hasła dla admin
echo 'admin ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/admin

# 1b. Wyłączenie usypiania
sudo pmset -a sleep 0 displaysleep 0 disksleep 0

# 1c. Ustawienie hostname
sudo scutil --set ComputerName XYZ
sudo scutil --set HostName XYZ
sudo scutil --set LocalHostName XYZ

# 1d. Homebrew + Lima + socket_vmnet
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install lima
brew install socket_vmnet
sudo brew services start socket_vmnet
```

### 2. Konfiguracja Lima networks.yaml

```bash
# Na każdym Mac Pro — ścieżka: ~/.lima/_config/networks.yaml
cat > ~/.lima/_config/networks.yaml << 'EOF'
paths:
  socketVMNet: "/opt/homebrew/socket_vmnet/bin/socket_vmnet"    ....COPY AND CHANGE PATHS!
  varRun: /private/var/run/lima
  sudoers: /private/etc/sudoers.d/lima

group: everyone

networks:
  bridged:
    mode: bridged
    interface: XYZ
EOF
```
### 3. Tworzenie VM z bridged networking

```bash
# Template VM: ~/.lima/opvmkub13.yaml
cat > ~/.lima/opvmkub13.yaml << 'EOF'
vmType: vz
arch: "aarch64"
cpus: 18
memory: "128GiB"
disk: "500GiB"

images:
  - location: "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-arm64.img"
    arch: "aarch64"

networks:
  - lima: bridged
    interface: "bond0"

provision:
  - mode: system
    script: |
      #!/bin/bash
      set -eux
      echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/90-k8s.conf
      echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.d/90-k8s.conf
      echo 'fs.inotify.max_user_instances=8192' >> /etc/sysctl.d/90-k8s.conf
      echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.d/90-k8s.conf
      sysctl --system || true
      modprobe br_netfilter || true
      modprobe overlay || true
EOF

limactl create --name=OPVMKUB13 ~/.lima/OPVMKUB13.yaml --tty=false
limactl start OPVMKUB13
```

### 4. Statyczny IP w VM (netplan)

```bash
/opt/homebrew/bin/limactl shell OPVMKUB13 -- sudo bash -c '
cat > /etc/netplan/99-bridged-static.yaml << EOF
network:
  version: 2
  ethernets:
    bond0:
      dhcp4: false
      addresses: [10.1.1.13/16]
      routes:
        - to: 0.0.0.0/0
          via: 10.1.0.1
          metric: 50
      nameservers:
        addresses: [10.1.53.53, 8.8.8.8]
EOF
chmod 600 /etc/netplan/99-bridged-static.yaml
netplan apply
'
```