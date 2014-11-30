#!/bin/bash

wget -q -O- http://downloads.opennebula.org/repo/Ubuntu/repo.key | apt-key add -
echo "deb http://downloads.opennebula.org/repo/Ubuntu/12.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

apt-get update
apt-get install -y opennebula opennebula-sunstone nfs-kernel-server

sed -i "s/:host: 127.0.0.1/:host: 0.0.0.0/" /etc/one/sunstone-server.conf
/etc/init.d/opennebula-sunstone restart

su oneadmin -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys"
su oneadmin -c "oneuser passwd oneadmin oneadmin"

cat << EOT > /tmp/config
Host *
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
EOT
chmod 600 /tmp/config
chown oneadmin:oneadmin /tmp/config
su oneadmin -c "mv /tmp/config ~/.ssh/config"

apt-get install -y opennebula-node nfs-common bridge-utils
cat << EOL /etc/network/interfaces
auto lo
iface lo inet loopback

auto br0
	iface br0 inet static
	address 192.168.0.10
	network 192.168.0.0
	netmask 255.255.255.0
	broadcast 192.168.0.255
	gateway 192.168.0.1
	bridge_ports eth0
	bridge_fd 9
	bridge_hello 2
	bridge_maxage 12
	bridge_stp off
EOL
/etc/init.d/networking restart

cat << EOT > /etc/libvirt/qemu.conf
user = "oneadmin"
group = "oneadmin"
dynamic_ownership = 0
EOT
