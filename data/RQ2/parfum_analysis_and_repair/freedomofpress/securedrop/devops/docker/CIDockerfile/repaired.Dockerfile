FROM debian:stretch


ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VER 17.05.0-ce
ENV DOCKER_SHA256_x86_64 340e0b5a009ba70e1b644136b94d13824db0aeb52e09071410f35a95d94316d9

RUN apt-get update && \
    apt-get install --no-install-recommends -y flake8 make virtualenv ccontrol libpython2.7-dev \
            libffi-dev libssl-dev libyaml-dev python-pip curl git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L -o /tmp/docker-${DOCKER_VER}.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VER}.tgz; \
	echo "${DOCKER_SHA256_x86_64}  /tmp/docker-${DOCKER_VER}.tgz" | sha256sum -c -; \
	cd /tmp && tar -xz -f /tmp/docker-${DOCKER_VER}.tgz; rm /tmp/docker-${DOCKER_VER}.tgz \
	mv /tmp/docker/* /usr/bin

CMD /bin/bash
