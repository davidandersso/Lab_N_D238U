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
WAN_IF="eth1"       # Connected to wan_net (10.0.1.254)
EXTERNAL_IF="eth0"  # Connected to macvlan_net (10.80.76.101)

# Allow SSH from internal network for management (optional)
# iptables -A INPUT -i $EXTERNAL_IF -p tcp --dport 22 -s 10.0.1.0/24 -j ACCEPT

# Allow HTTP and FTP from external network to internal servers
# Assuming internal servers are on wan_net, e.g., 10.0.1.100 (HTTP) and 10.0.1.101 (FTP)
iptables -A FORWARD -i $EXTERNAL_IF -o $WAN_IF -p tcp --dport 80 -d 10.0.1.100 -j ACCEPT
iptables -A FORWARD -i $EXTERNAL_IF -o $WAN_IF -p tcp --dport 21 -d 10.0.1.101 -j ACCEPT

# Allow return traffic
iptables -A FORWARD -i $WAN_IF -o $EXTERNAL_IF -m state --state ESTABLISHED,RELATED -j ACCEPT


# Enable NAT for outbound traffic if necessary
iptables -t nat -A POSTROUTING -o $EXTERNAL_IF -j MASQUERADE

# Save rules and keep container running
tail -f /dev/null
