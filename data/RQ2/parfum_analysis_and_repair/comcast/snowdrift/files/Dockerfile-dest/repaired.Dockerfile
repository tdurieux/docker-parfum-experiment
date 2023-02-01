FROM alpine

RUN apk add --no-cache bash nginx iptables && \
	mkdir -p /run/nginx/ && \
	echo "cat /etc/motd" >> /root/.bashrc

#
# Run nginx in the foreground.
#
ENTRYPOINT /mnt/files/dest-entrypoint.sh



