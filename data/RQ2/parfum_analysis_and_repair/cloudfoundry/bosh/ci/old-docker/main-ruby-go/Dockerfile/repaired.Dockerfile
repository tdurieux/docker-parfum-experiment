FROM ubuntu:xenial

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8

RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y \
	build-essential \
	git \
	curl \
	wget \
	tar \
	libssl-dev \
	libreadline-dev \
	dnsutils \
	xvfb \
	jq \
	realpath \
	libpq-dev \
	rsyslog \
	libcurl4-openssl-dev \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*;

# Nokogiri dependencies
RUN apt-get install --no-install-recommends -y libxslt-dev libxml2-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD install-ruby.sh /tmp/install-ruby.sh
RUN chmod a+x /tmp/install-ruby.sh
RUN cd /tmp && ./install-ruby.sh && rm install-ruby.sh

COPY --from=golang:1 /usr/local/go /usr/local/go
ENV GOROOT=/usr/local/go PATH=/usr/local/go/bin:$PATH
ENV PATH /opt/rubies/ruby-2.6.3/bin:/opt/rubies/ruby-2.4.5/bin:$PATH
