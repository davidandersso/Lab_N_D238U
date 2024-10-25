#!/bin/bash

docker exec dockerlab_n_firewall_technicians_1 ip route del default
docker exec dockerlab_n_firewall_technicians_1 ip route add default via 10.0.2.254 dev eth0
docker exec dockerlab_n_firewall_technicians_1 ip route

docker exec dockerlab_n_firewall_internal_1 ip route del default
docker exec dockerlab_n_firewall_internal_1 ip route add default via 10.0.1.254 dev eth1
docker exec dockerlab_n_firewall_internal_1 ip route add 10.0.12.0/24 via 10.0.2.252 dev eth0
docker exec dockerlab_n_firewall_internal_1 ip route

docker exec dockerlab_n_firewall_wan_1 ip route add 10.0.2.0/24 via 10.0.1.253 dev eth0

docker exec dockerlab_n_internal_db_1 ip route del default
docker exec dockerlab_n_internal_db_1 ip route add default via 10.0.2.254 dev eth0
docker exec dockerlab_n_internal_db_1 ip route