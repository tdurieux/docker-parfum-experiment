FROM docker:dind
RUN apk add --no-cache perl openssh sudo curl docker-compose
# Used: perl -e 'use Crypt::PasswdMD5; print crypt("Redfish@TSS19", "\$6\$rl1WNGdr\$"),"\n"' to create the Password
RUN adduser -D dock
RUN perl -pi -e 's|^dock:!:|dock:\$6\$rl1WNGdr\$qHyKDW/prwoj5qQckWh13UH3uE9Sp7w43jPzUI9mEV6Y1gZ3MbDDMUX/1sP7ZRnItnGgBEklmsD8vAKgMszkY.:|' /etc/shadow
RUN perl -pi -e 's|^dock:|docker:|' /etc/group
RUN echo "dock   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
COPY ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
COPY ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
COPY ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
RUN chmod 600 /etc/ssh/ssh_host_*
ENV PATH $PATH:/usr/local/bin
ENTRYPOINT /usr/sbin/sshd && dockerd-entrypoint.sh
WORKDIR /home/dock
#USER dock
