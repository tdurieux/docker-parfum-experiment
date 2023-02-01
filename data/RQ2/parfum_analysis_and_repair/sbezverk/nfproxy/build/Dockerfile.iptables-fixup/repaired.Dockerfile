FROM alpine

RUN	set -ex;			\
	apk add --no-cache iptables 

COPY ./build/iptables-fixup.sh /iptables-fixup.sh
RUN chmod +x /iptables-fixup.sh

CMD ["/iptables-fixup.sh"]