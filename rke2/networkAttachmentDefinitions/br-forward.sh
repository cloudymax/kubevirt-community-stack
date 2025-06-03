#!/bin/bash
# save to /usr/local/sbin/br-forward.sh
# make sure to mark it executable:
#  chmod u+x /usr/local/sbin/br-forward.sh
sudo iptables -F FORWARD && \
sudo iptables -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT && \
sudo sysctl -w net.ipv4.ip_forward=1
