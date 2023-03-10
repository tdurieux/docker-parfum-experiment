FROM ubuntu

RUN apt update \
	&& apt install --no-install-recommends -y openssh-server \
	&& echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config \
	&& echo 'Port 22' >> /etc/ssh/sshd_config \
	&& echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config \
	&& systemctl enable ssh.socket \
	&& mkdir /root/.ssh \
	&& mkdir /run/sshd \
	&& rm -rf /var/lib/apt/lists/*

COPY ssh-key.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


## Build and Run
# docker build . -f Dockerfile.ssh-ubuntu -t testenv:ssh-ubuntu
# docker run -d --name ssh-ubuntu1 testenv:ssh-ubuntu
# docker run -d --name ssh-ubuntu2 testenv:ssh-ubuntu
# docker run -d --name ssh-ubuntu3 testenv:ssh-ubuntu
