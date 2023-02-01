FROM ubuntu:jammy

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y \
	build-essential \
	git \
	curl \
	wget \
	tar \
	libssl-dev \
	libreadline-dev \
	sqlite3 \
	libsqlite3-dev \
	dnsutils \
	xvfb \
	jq \
	# Needed for `realpath`
	coreutils \
	libpq-dev \
	rsyslog \
	libcurl4-openssl-dev \
	python3-pip \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir awscli

ENV RUBY_INSTALL_VERSION=0.8.3 RUBY_VERSION=3.1.2

# Install ruby-install
RUN cd /tmp && \
    wget -nv -O ruby-install-$RUBY_INSTALL_VERSION.tar.gz https://github.com/postmodern/ruby-install/archive/v$RUBY_INSTALL_VERSION.tar.gz && \
    wget -nv https://raw.github.com/postmodern/ruby-install/master/pkg/ruby-install-$RUBY_INSTALL_VERSION.tar.gz.asc && \
    tar -xzvf ruby-install-$RUBY_INSTALL_VERSION.tar.gz && \
    cd ruby-install-$RUBY_INSTALL_VERSION/ && \
    make install && \
    rm -rf /tmp/ruby-install-$RUBY_INSTALL_VERSION && rm /tmp/* && rm ruby-install-$RUBY_INSTALL_VERSION.tar.gz

# Install Ruby
RUN ruby-install --jobs=2 --cleanup --system ruby "$RUBY_VERSION" -- --disable-install-rdoc
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN ruby -v && gem update --system && rm -rf /root/.gem;
