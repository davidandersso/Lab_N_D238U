#!/bin/sh

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Interfaces
INTERNAL_IF="eth0"    # Connected to internal_net (10.0.2.253)
FINANCE_IF="eth1"     # Connected to finance_net (10.0.11.254)

# Allow SSH from internal network for management (optional)
# iptables -A INPUT -i $INTERNAL_IF -p tcp --dport 22 -s 10.0.2.0/24 -j ACCEPT

# Allow forwarding from finance_net to internal_net (only to access internal_db)
# internal_db IP: 10.0.2.10
iptables -A FORWARD -i $FINANCE_IF -o $INTERNAL_IF -p tcp --dport 3306 -d 10.0.2.10 -j ACCEPT

# Allow established connections from internal_net to finance_net
iptables -A FORWARD -i $INTERNAL_IF -o $FINANCE_IF -m state --state ESTABLISHED,RELATED -j ACCEPT

# Prevent finance_net from accessing other internal subnets
# Already handled by default DROP policy

# Drop everything else
iptables -A FORWARD -j DROP

# Enable NAT if finance_net needs internet access (optional)
iptables -t nat -A POSTROUTING -o $INTERNAL_IF -j MASQUERADE

# Save rules and keep container running
tail -f /dev/null
