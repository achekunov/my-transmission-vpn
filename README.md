2 projects linuxserver/docker-transmission and ubergarm/l2tp-ipsec-vpn-client in one container

## Build

docker build -t my-transmission-vpn .

## Run
Setup environment variables for your credentials and config:

    export VPN_SERVER_IPV4='1.2.3.4'
    export VPN_PSK='my pre shared key'
    export VPN_USERNAME='myuser@myhost.com'
    export VPN_PASSWORD='mypass'
    export DOCKER_NET_GW='172.17.0.1'
    export VPN_LOCAL_GW_IP='192.168.66.1'
    export LOCAL_NETWORK='192.168.56.0/24'

Now run it (you can daemonize of course after debugging):

    docker run --rm -it --privileged \
               -v /lib/modules:/lib/modules:ro \
               -v <path to data>:/config \
               -v <path to downloads>:/downloads \
               -v <path to watch folder>:/watch \
               -e VPN_SERVER_IPV4 \
               -e VPN_PSK \
               -e VPN_USERNAME \
               -e VPN_PASSWORD \
               -e DOCKER_NET_GW \
               -e VPN_LOCAL_GW_IP \
               -e LOCAL_NETWORK \
               -e PGID=<gid> -e PUID=<uid> \
               -e TZ=<timezone> \
               -p 9091:9091 -p 51413:51413 \
               -p 51413:51413/udp \
                  my-transmission-vpn


-v /config - where transmission should store config files and logs

-v /downloads - local path for downloads

-v /watch - watch folder for torrent files

-e PGID for GroupID

-e PUID for UserID 

Sometimes when using data volumes (-v flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user PUID and group PGID. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

-e TZ for timezone information, eg Europe/London

