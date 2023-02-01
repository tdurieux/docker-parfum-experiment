FROM alpine
RUN apk update
RUN apk add --no-cache haproxy
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
VOLUME /etc/haproxy/
CMD /usr/sbin/haproxy -fdV /etc/haproxy/haproxy.cfg
