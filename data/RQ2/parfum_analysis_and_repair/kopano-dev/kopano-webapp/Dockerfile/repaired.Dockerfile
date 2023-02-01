FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y chromium-browser phpmd \
			ant ant-optional libxml2-utils gettext \
			openjdk-11-jdk php-xml php-zip php-common php-gettext \
			wget apt-transport-https gnupg2 make python && rm -rf /var/lib/apt/lists/*;
# Latest nodejs
RUN wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_9.x bionic main" > /etc/apt/sources.list.d/node.list
RUN apt-get update && apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# Set timezone for JS unit tests
RUN ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata

# Add user
RUN useradd -m -u 107 jenkins

# Cleanup
RUN apt-get remove -y gnupg2 apt-transport-https wget
RUN apt-get clean -y && \
  apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /usr/share/locale/* && \
  rm -rf /var/cache/debconf/*-old && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/share/doc/*
