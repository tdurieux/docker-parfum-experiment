ARG RUSTBIN_TAG=latest
FROM curiefense/curiefense-rustbuild-bionic:${RUSTBIN_TAG} AS rustbin
FROM docker.io/openresty/openresty:1.19.9.1-1-bionic
COPY conf.d /etc/nginx/conf.d
COPY curieproxy/lua /lua
COPY curieproxy/lua/shared-objects/*.so /usr/local/lib/lua/5.1/
COPY --from=rustbin /root/curiefense.so /usr/local/lib/lua/5.1/

COPY curieproxy/cf-config /bootstrap-config/config

RUN apt-get update && apt-get install -y libhyperscan4 rsyslog
RUN mkdir /cf-config && chmod a+rwxt /cf-config
RUN openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=fr/O=curiefense/CN=testsystem" -keyout /etc/ssl/certificate.key -out /etc/ssl/certificate.crt

RUN mkfifo /nginx-accesslogs

COPY start.sh /usr/bin/
COPY rsyslog.conf /etc/rsyslog.conf
CMD /bin/bash /usr/bin/start.sh
