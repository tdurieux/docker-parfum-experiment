FROM alpine

RUN apk add --no-cache openssh-server \
	&& echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config \
	&& echo 'Port 22' >> /etc/ssh/sshd_config \
	&& echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config \
	&& mkdir /root/.ssh \
	&& /usr/bin/ssh-keygen -A

COPY ssh-key.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


## Build and Run
# docker build . -f Dockerfile.ssh-alpine -t testenv:ssh-alpine
# docker run -d --name ssh-alpine1 testenv:ssh-alpine
# docker run -d --name ssh-alpine2 testenv:ssh-alpine
# docker run -d --name ssh-alpine3 testenv:ssh-alpine