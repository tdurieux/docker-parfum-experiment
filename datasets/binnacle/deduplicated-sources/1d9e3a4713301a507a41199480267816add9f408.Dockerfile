#
# Dockerfile for fteproxy
#

FROM debian:jessie
MAINTAINER kev<noreply@easypi.pro>

ENV FTE_VER 0.2.18
ENV FTE_SYS linux
ENV FTE_ARCH x86_64
ENV FTE_URL https://fteproxy.org/dist/${FTE_VER}/fteproxy-${FTE_VER}-${FTE_SYS}-${FTE_ARCH}.tar.gz
ENV FTE_FILE fteproxy.tar.gz
ENV FTE_MD5 81e1f941df9fa202c08dd73d5def0d33

RUN apt-get update \
    && apt-get install -y curl \
    && curl -sSL ${FTE_URL} -o ${FTE_FILE} \
    && echo "${FTE_MD5} ${FTE_FILE}" | md5sum -c \
    && mkdir -p /fteproxy \
    && tar xzf ${FTE_FILE} --strip 1 -C /fteproxy \
    && rm -rf ${FTE_FILE} /var/lib/apt/lists/*

ENV MODE server
ENV UPSTREAM_FORMAT manual-http-request
ENV DOWNSTREAM_FORMAT manual-http-response
ENV CLIENT_IP 127.0.0.1
ENV CLIENT_PORT 8079
ENV SERVER_IP 127.0.0.1
ENV SERVER_PORT 8080
ENV PROXY_IP 127.0.0.1
ENV PROXY_PORT 8081
ENV RELEASE 20131224
ENV KEY FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000

CMD /fteproxy/fteproxy.bin --mode $MODE \
                           --upstream-format $UPSTREAM_FORMAT \
                           --downstream-format $DOWNSTREAM_FORMAT \
                           --client_ip $CLIENT_IP \
                           --client_port $CLIENT_PORT \
                           --server_ip $SERVER_IP \
                           --server_port $SERVER_PORT \
                           --proxy_ip $PROXY_IP \
                           --proxy_port $PROXY_PORT \
                           --release $RELEASE \
                           --key $KEY

