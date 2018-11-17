FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ENV LANG C.UTF-8
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN set -x && \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	jq \
	openssl \
	p7zip \
	rsync \
	tar \
	transmission-cli \
	transmission-daemon \
	unrar \
	unzip \
        strongswan \
        xl2tpd \
        ppp \
    && mkdir -p /var/run/xl2tpd \
    && touch /var/run/xl2tpd/l2tp-control

# copy local files
COPY root/ /
COPY ipsec.conf /etc/ipsec.conf
COPY ipsec.secrets /etc/ipsec.secrets
COPY xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY options.l2tpd.client /etc/ppp/options.l2tpd.client
COPY startup.sh /
COPY route.sh /
COPY status.sh /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch

CMD ["/startup.sh"]
