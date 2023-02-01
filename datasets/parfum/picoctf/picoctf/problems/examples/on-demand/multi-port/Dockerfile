FROM ubuntu:18.04

# install challenge dependencies within the image
RUN apt-get update && apt-get install -y \
    openssh-server \
    socat

WORKDIR /challenge

# create a user with an authorized ssh key
RUN useradd -U challenge -d /challenge -s /bin/bash && \
    ssh-keygen -f /opt/challenge -C challenge@target -P "" && \
    mkdir -p /challenge/.ssh && \
    cat /opt/challenge.pub > /challenge/.ssh/authorized_keys &&  \
    chown -R challenge:challenge /challenge/.ssh && \
    chmod 600 /challenge/.ssh/authorized_keys

# disable motd
RUN sed -i '/^session    optional     pam_motd.so/d' /etc/pam.d/sshd

# the flag file is templated by pico prior to being copied in
COPY flag /challenge/flag

COPY start.sh /opt/start.sh

EXPOSE 22
EXPOSE 5555
CMD ["/opt/start.sh"]
