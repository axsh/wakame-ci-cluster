#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

ip_mng_br0="192.168.2.1/24"

network_wanedge="10.255.0.0/24"
ip_wanedge="10.255.0.1/24"

name_ovs_br0=vnet-itest-0
name_ovs_br1=vnet-itest-1
name_ovs_br2=vnet-itest-2
name_ovs_wanedge=vnet-wanedge
name_mng_br0=vnet-br0

sudo ip link set ${name_ovs_br0} down || true
sudo brctl delbr ${name_ovs_br0} || true
sudo brctl addbr ${name_ovs_br0}
sudo ip link set ${name_ovs_br0} up

sudo ip link set ${name_ovs_br1} down || true
sudo brctl delbr ${name_ovs_br1} || true
sudo brctl addbr ${name_ovs_br1}
sudo ip link set ${name_ovs_br1} up

sudo ip link set ${name_ovs_br2} down || true
sudo brctl delbr ${name_ovs_br2} || true
sudo brctl addbr ${name_ovs_br2}
sudo ip link set ${name_ovs_br2} up

sudo ip link set ${name_ovs_wanedge} down || true
sudo brctl delbr ${name_ovs_wanedge} || true
sudo brctl addbr ${name_ovs_wanedge}
sudo ip link set ${name_ovs_wanedge} up
sudo ip addr add ${ip_wanedge} dev ${name_ovs_wanedge}

sudo ip link set ${name_mng_br0} down || true
sudo brctl delbr ${name_mng_br0} || true
sudo brctl addbr ${name_mng_br0}
sudo ip link set ${name_mng_br0} up
sudo ip addr add ${ip_mng_br0} dev ${name_mng_br0}

sudo iptables -t nat -D POSTROUTING -s ${network_wanedge} -j MASQUERADE || :
sudo iptables -t nat -A POSTROUTING -s ${network_wanedge} -j MASQUERADE
