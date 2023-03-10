FROM ruby:2.6.6

ENV LANG C.UTF-8
ENV ENTRYKIT_VERSION 0.4.0

RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;

RUN wget -O entrykit.tar.gz https://github.com/progrium/entrykit/archive/v${ENTRYKIT_VERSION}.tar.gz \
  && tar -zxvf entrykit.tar.gz \
  && rm entrykit.tar.gz \
  && cd entrykit-${ENTRYKIT_VERSION} \
  && go mod init go-tools \
  && go mod tidy \
  && go build ./... \
  && go build -a -installsuffix cgo -ldflags "-X main.Version=${ENTRYKIT_VERSION}" -o entrykit ./cmd \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
  && cd .. \
  && rm -rf entrykit-${ENTRYKIT_VERSION} \
  && apt-get remove --purge -y golang \
  && apt-get -y autoremove

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
  && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install --no-install-recommends -y \
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libcurl4-openssl-dev libxml2-dev \
  default-mysql-client \
  nodejs vim \
  povray povray-includes \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /src
WORKDIR /src

RUN useradd -m --shell /bin/bash --uid 1000 ruby
USER ruby

ENV EDITOR vim
ENV BUNDLE_PATH vendor/bundle

RUN bundle config --global retry 5 \
  && bundle config --global path vendor/bundle

ENTRYPOINT [ \
  "prehook", \
  "ruby -v",\
  "npm install", \
  "bundle install", "--" \
  ]
