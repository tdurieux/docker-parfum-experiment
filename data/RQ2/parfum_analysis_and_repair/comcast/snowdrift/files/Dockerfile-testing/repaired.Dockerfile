FROM alpine

#
# Install OpenSSH and set up display of out MOTD.
#
RUN apk add --no-cache openssh bash && \
	echo "cat /etc/motd" >> /root/.bashrc

ENTRYPOINT /mnt/files/testing-entrypoint.sh


