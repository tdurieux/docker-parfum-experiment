ARG registry
FROM $registry/labtainer.base2
LABEL description="This is base Docker image for networking Parameterized labs"
ARG lab
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    openssh-server \
    openvpn \
    wget \
    tcpdump \
    update-inetd \
    xinetd \
    iptables \
    dnsutils \
    dnsmasq \
    nmap \
    netcat-openbsd && rm -rf /var/lib/apt/lists/*;

# step around app armor or whatever
RUN sudo mv /usr/sbin/tcpdump /usr/bin/tcpdump
#
# /run/sshd created when parameterizing
#
RUN systemctl disable dnsmasq
RUN rm /etc/systemd/system/multi-user.target.wants/openvpn.service
RUN rm /etc/systemd/system/multi-user.target.wants/ssh.service
