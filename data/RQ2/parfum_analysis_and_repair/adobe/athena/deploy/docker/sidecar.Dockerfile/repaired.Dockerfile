FROM envoyproxy/envoy

RUN apt update -y \
    && apt -y upgrade \
    && apt -y --no-install-recommends install curl dirmngr apt-transport-https lsb-release ca-certificates \
    && curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt -y --no-install-recommends install nodejs \
    && apt -y --no-install-recommends install sudo \
    && apt -y --no-install-recommends install iptables && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --disabled-login --gecos "" sidecar && echo "sidecar:sidecar" | chpasswd && adduser sidecar sudo
RUN echo "sidecar ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER sidecar

WORKDIR /etc/app
COPY . .
RUN sudo npm install && npm cache clean --force;

# TODO: Fix this.
EXPOSE 5000-5100

CMD ["sudo", "npm", "run", "create-cluster"]