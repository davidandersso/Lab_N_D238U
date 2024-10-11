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
WAN_IF="eth0"        # Connected to wan_net (10.0.1.253)
INTERNAL_IF="eth1"   # Connected to internal_net (10.0.2.254)

# Allow SSH from internal network for management (optional)
# iptables -A INPUT -i $INTERNAL_IF -p tcp --dport 22 -s 10.0.2.0/24 -j ACCEPT

# Allow forwarding from internal_net to wan_net
iptables -A FORWARD -i $INTERNAL_IF -o $WAN_IF -j ACCEPT

# Allow forwarding from wan_net to internal_net only for established connections
iptables -A FORWARD -i $WAN_IF -o $INTERNAL_IF -m state --state ESTABLISHED,RELATED -j ACCEPT

# Drop everything else

# Enable NAT for outbound traffic
iptables -t nat -A POSTROUTING -o $WAN_IF -j MASQUERADE

tail -f /dev/null
