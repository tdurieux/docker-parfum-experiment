FROM debian:jessie

RUN mkdir /deb
WORKDIR /deb

RUN apt-get update && \
    apt-get install -y \
      git \
      ruby \
      ruby-dev \
      libmysqlclient-dev \
      libpq-dev \
      libevent-dev \
      libxml2-dev \
      libxslt1-dev \
      libreadline-dev \
      build-essential \
      curl

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

RUN npm install -g yarn

RUN gem install pkgr bundler --no-rdoc --no-ri

RUN mkdir -p /tmp/pkgr-cache

COPY . /deb
CMD ./build debian-8 jessie
