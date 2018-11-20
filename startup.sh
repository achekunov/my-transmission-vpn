#!/bin/sh

# template out all the config files using env vars
sed -i 's/right=.*/right='$VPN_SERVER_IPV4'/' /etc/ipsec.conf
echo ': PSK "'$VPN_PSK'"' > /etc/ipsec.secrets
sed -i 's/lns = .*/lns = '$VPN_SERVER_IPV4'/' /etc/xl2tpd/xl2tpd.conf
sed -i 's/name .*/name '$VPN_USERNAME'/' /etc/ppp/options.l2tpd.client
sed -i 's/password .*/password '$VPN_PASSWORD'/' /etc/ppp/options.l2tpd.client
sed -i 's/HOST=.*/HOST='$VPN_LOCAL_GW_IP'/' /status.sh

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo $TZ > /etc/timezone
echo $TZ > /etc/TZ
unset TZ

cat >/route.sh <<EOL
#!/bin/sh
sleep 20
ip route add ${VPN_SERVER_IPV4}/32 via ${DOCKER_NET_GW}
ip route del default
ip route add default via ${VPN_LOCAL_GW_IP}
ip route add ${LOCAL_NETWORK} via ${DOCKER_NET_GW}
EOL

# startup ipsec tunnel
PIDFILE=/var/run/charon.pid /usr/sbin/ipsec start
sleep 2
ipsec up L2TP-PSK
sleep 2
ipsec statusall
sleep 2

/route.sh &
# startup xl2tpd ppp daemon then send it a connect command
(sleep 3 && echo "c myVPN" > /var/run/xl2tpd/l2tp-control) &
/usr/sbin/xl2tpd -p /var/run/xl2tpd.pid -c /etc/xl2tpd/xl2tpd.conf -C /var/run/xl2tpd/l2tp-control -D
