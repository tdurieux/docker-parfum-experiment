from alpine:3.9

RUN apk add --no-cache bash openssh findutils git emacs
#    apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ emacs && \
#    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing global cscope

RUN echo "export TERM=xterm" >> /root/.bashrc

COPY emacs.sh /usr/bin/e
RUN chmod -R 777 /usr/bin/e
RUN cd /root && mkdir .ssh && chmod -R 700 /root/.ssh
RUN echo "PasswordAuthentication no" > /etc/ssh/sshd_config
RUN touch /authorized_keys

# docker
RUN apk add --no-cache ca-certificates

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.09.6

RUN set -eux; \ 
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64) dockerArch='x86_64' ;; \
		armhf) dockerArch='armel' ;; \
		aarch64) dockerArch='aarch64' ;; \
		ppc64le) dockerArch='ppc64le' ;; \
		s390x) dockerArch='s390x' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	\
	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version


RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && echo "root:root" | chpasswd

COPY cargo /usr/bin/cargo
RUN cp /usr/local/bin/docker /usr/bin/docker

CMD /usr/sbin/sshd -D
