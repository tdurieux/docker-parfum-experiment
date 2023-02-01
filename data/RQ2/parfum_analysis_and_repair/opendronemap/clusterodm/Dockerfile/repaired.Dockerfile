FROM node:14
MAINTAINER Piero Toffanin <pt@masseranolabs.com>

EXPOSE 3000

USER root

RUN apt update && apt install --no-install-recommends -y telnet curl && \
    base=https://gitlab-docker-machine-downloads.s3.amazonaws.com/main && \
    curl -f -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && \
    install /tmp/docker-machine /usr/local/bin/docker-machine && \
    curl -f -L https://github.com/scaleway/docker-machine-driver-scaleway/releases/download/v1.6/docker-machine-driver-scaleway_1.6_linux_amd64.tar.gz | tar -xz --directory=/tmp && \
    install --mode +x /tmp/docker-machine-driver-scaleway /usr/local/bin/ && \
    curl -f -L https://github.com/JonasProgrammer/docker-machine-driver-hetzner/releases/download/2.0.1/docker-machine-driver-hetzner_2.0.1_linux_amd64.tar.gz | tar -xz --directory=/tmp && \
    install --mode +x /tmp/docker-machine-driver-hetzner /usr/local/bin/ && rm -rf /var/lib/apt/lists/*;

RUN mkdir /var/www
WORKDIR "/var/www"
COPY --chown=node:node . /var/www

RUN npm install && npm cache clean --force;

RUN chown -R node:node /var/www

USER node

VOLUME ["/var/www/data"]
ENTRYPOINT ["/usr/local/bin/node", "/var/www/index.js"]
