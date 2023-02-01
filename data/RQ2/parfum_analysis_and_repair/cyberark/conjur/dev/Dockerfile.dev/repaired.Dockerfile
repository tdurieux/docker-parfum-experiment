FROM cyberark/phusion-ruby-fips:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    ldap-utils \
    git \
    jq \
    tzdata \
    libfontconfig1 \
    libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    unattended-upgrades \
    vim \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /src/conjur-server

ADD .pryrc /root

WORKDIR /src/conjur-server

COPY Gemfile \
     Gemfile.lock ./
COPY gems/ gems/

RUN bundle

# removing CA bundle of httpclient gem
RUN find / -name httpclient -type d -exec find {} -name *.pem -type f -delete \;

RUN rm /etc/service/sshd/down
RUN ln -sf /src/conjur-server/bin/conjurctl /usr/local/bin/
RUN rm /etc/my_init.d/10_syslog-ng.init

ENV PORT 3000
ENV TERM xterm

EXPOSE 3000
