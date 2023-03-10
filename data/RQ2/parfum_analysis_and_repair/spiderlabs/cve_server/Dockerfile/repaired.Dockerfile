FROM ruby:2.2.3
MAINTAINER Jonathan Claudius
COPY . /app
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libreadline-dev libssl-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf curl zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev curl zlib1g-dev rubygems ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bc git mongodb && rm -rf /var/lib/apt/lists/*;
CMD service mongodb start && \
    mkdir test && \
    cd test && \
    curl --ssl -s https://raw.githubusercontent.com/SpiderLabs/cve_server/master/scripts/install.sh | bash -
