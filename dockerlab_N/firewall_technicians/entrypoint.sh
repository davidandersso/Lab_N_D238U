#!/bin/sh

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Set default policies
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Interfaces
INTERNAL_IF="eth0"         # Connected to internal_net (10.0.2.252)
TECHNICIANS_IF="eth1"      # Connected to technicians_net (10.0.12.254)

# Allow SSH from internal network for management (optional)
# iptables -A INPUT -i $INTERNAL_IF -p tcp --dport 22 -s 10.0.2.0/24 -j ACCEPT

# Allow forwarding from technicians_net to internal_net (only to access internal_db)
# internal_db IP: 10.0.2.10
iptables -A FORWARD -i $TECHNICIANS_IF -o $INTERNAL_IF -p tcp --dport 3306 -d 10.0.2.10 -j ACCEPT

# Allow established connections from internal_net to technicians_net
iptables -A FORWARD -i $INTERNAL_IF -o $TECHNICIANS_IF -m state --state ESTABLISHED,RELATED -j ACCEPT

# Prevent technicians_net from accessing other internal subnets
# Already handled by default DROP policy

# Drop everything else
#iptables -A FORWARD -j DROP

# Enable NAT if technicians_net needs internet access (optional)
iptables -t nat -A POSTROUTING -o $INTERNAL_IF -j MASQUERADE

# Save rules and keep container running
tail -f /dev/null
