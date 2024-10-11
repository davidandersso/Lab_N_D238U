docker exec dockerlab-n-firewall_technicians-1 ip route del default
docker exec dockerlab-n-firewall_technicians-1 ip route add default via 10.0.2.254 dev eth0
docker exec dockerlab-n-firewall_technicians-1 ip route

docker exec dockerlab-n-firewall_internal-1 ip route del default
docker exec dockerlab-n-firewall_internal-1 ip route add default via 10.0.1.254 dev eth1
docker exec dockerlab-n-firewall_internal-1 ip route add 10.0.12.0/24 via 10.0.2.252 dev eth0
docker exec dockerlab-n-firewall_internal-1 ip route

docker exec dockerlab-n-firewall_wan-1 ip route add 10.0.2.0/24 via 10.0.1.253 dev eth0

docker exec dockerlab-n-internal_db-1 ip route del default
docker exec dockerlab-n-internal_db-1 ip route add default via 10.0.2.254 dev eth0
docker exec dockerlab-n-internal_db-1 ip route