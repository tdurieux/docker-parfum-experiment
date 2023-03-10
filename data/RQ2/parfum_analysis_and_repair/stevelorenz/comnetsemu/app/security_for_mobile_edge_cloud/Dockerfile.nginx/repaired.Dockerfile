#
# About: nginx image for test scenarios
#

FROM nginx:1.17.1-alpine

RUN apk update
# For an interactive shell
RUN apk add --no-cache bash
# For tc and interface CRUD
RUN apk add --no-cache iproute2 nftables tcpdump ca-certificates curl wget busybox-extras iperf


COPY nginx-content /usr/share/nginx/html

CMD ["nginx"]
