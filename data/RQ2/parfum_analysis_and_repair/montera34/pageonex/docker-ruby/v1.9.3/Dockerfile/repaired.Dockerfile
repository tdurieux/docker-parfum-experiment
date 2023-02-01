FROM debian:jessie-slim

ENV RUBY_VERSION 1.9.3-p551
ENV RUBY_SHA1SUM 5cf6c9383444163a3f753b50c35e441988189258

RUN BUILD_DIR="/tmp/ruby-build" \
 && apt-get update \
 && apt-get -y --no-install-recommends install \
               wget \
               build-essential \
               zlib1g-dev \
               libssl-dev \
               libreadline6-dev \
               libyaml-dev \
               tzdata \
               libmysqlclient-dev \
               mysql-client \
								libpq-dev \
								libxml2-dev \
								libxslt1-dev \
								nodejs \
								libmagickwand-dev \
								libsqlite3-dev \
 && mkdir -p "$BUILD_DIR" \
 && cd "$BUILD_DIR" \
 && wget -q "https://cache.ruby-lang.org/pub/ruby/ruby-${RUBY_VERSION}.tar.gz" \
 && echo "${RUBY_SHA1SUM}  ruby-${RUBY_VERSION}.tar.gz" | sha1sum -c - \
 && tar xzf "ruby-${RUBY_VERSION}.tar.gz" \
 && cd "ruby-${RUBY_VERSION}" \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --prefix=/usr \
 && make \
 && make install \
 && cd / \
 && rm -r "$BUILD_DIR" \
 && rm -rf /var/lib/apt/lists/* && rm "ruby-${RUBY_VERSION}.tar.gz"
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system \
    && gem install --force bundler \
    && gem install debugger-ruby_core_source && rm -rf /root/.gem;
