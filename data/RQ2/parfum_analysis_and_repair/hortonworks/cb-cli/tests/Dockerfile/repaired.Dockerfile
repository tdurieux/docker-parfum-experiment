FROM alpine:edge
MAINTAINER Hortonworks

RUN apk --no-cache --update add \
    ruby-dev \
    ruby \
    ruby-irb \
    ruby-rake \
    ruby-io-console \
    ruby-bigdecimal \
    libstdc++ tzdata \
    sudo \
    openjdk8-jre-base \
    git \
    curl \
    libressl \
    libressl-dev \
    dumb-init \
    tar \
    unzip \
    bash \
    build-base \
    libc-dev \
    linux-headers \
    libxml2-dev \
    libgcrypt-dev \
    libxslt-dev \
    libffi-dev \
    wget \
    ca-certificates

RUN update-ca-certificates

RUN gem install bundler --no-ri --no-rdoc \
  && rm -r /root/.gem \
  && find / -name '*.gem' | xargs rm

RUN echo "gem: --no-document" >> /etc/gemrc \
  && gem update --system \
  && gem install \
    pkg-config \
    rspec \
    aruba \
    aruba-rspec \
    json \
    oauth \
    rspec-json_expectations \
    rspec_junit_formatter \
    rest-client \
    allure-rspec && rm -rf /root/.gem;

RUN curl -f -o allure-2.7.0.zip -Ls https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.7.0/allure-2.7.0.zip \
  && unzip allure-2.7.0.zip -d /opt/ \
  && ln -s /opt/allure-2.7.0/bin/allure /usr/bin/allure \
  && allure --version

RUN rm -rf /var/cache/apk/*

COPY /scripts/aruba-docker.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /aruba/
ENV HOME /aruba

ENTRYPOINT ["/entrypoint.sh"]