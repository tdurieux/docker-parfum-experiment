FROM debian:latest

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

ENV DOCKER_COMPOSE_VERSION 1.28.5
ENV GOTTY_VERSION 1.0.1
RUN apt-get update --quiet > /dev/null \
    && apt-get install -y --no-install-recommends --assume-yes -qq \
      curl \
      gnupg \
      software-properties-common \

    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update --quiet > /dev/null \
    && apt-get install -y --no-install-recommends --assume-yes -qq \
      apt-transport-https \
      ca-certificates \
      build-essential \
      byobu \
      curl \
      docker-ce \
      fonts-firacode \
      git \
      gcc \
      gosu \
      libssl-dev \
      locales \
      locales-all \
      lsb-release \
      netcat \
      net-tools \
      procps \
      ssh-client \
      sudo \
      wget \
      vim \
      zsh \

    #
    # GoTTY
    && curl -f -sLk https://github.com/yudai/gotty/releases/download/v${GOTTY_VERSION}/gotty_linux_amd64.tar.gz \
      | tar xzC /usr/local/bin \
    #
    # docker-compose
    && curl -f -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && locale-gen en_US.UTF-8 \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV ZSH_IN_DOCKER_VERSION 1.1.1
ADD ./files/zsh-in-docker.sh /zsh-in-docker.sh
ADD ./files/setup-zsh.sh /setup-zsh.sh
RUN chmod +x /*.sh \
    && /setup-zsh.sh

ENV SHELL /bin/zsh
SHELL ["/bin/zsh", "-c"]
EXPOSE 8080

ADD ./files/.gotty /.gotty
ADD ./files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SUDO_WITHOUT_PASSWORD true

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/usr/bin/byobu"]
