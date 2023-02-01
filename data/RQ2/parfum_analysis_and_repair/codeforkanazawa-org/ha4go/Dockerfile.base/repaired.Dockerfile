FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get -y --no-install-recommends install \
    build-essential \
    curl \
    git-core \
    libcurl4-openssl-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev && \
    curl -f -O http://ftp.ruby-lang.org/pub/ruby/2.6/ruby-2.6.2.tar.gz && \
    tar -zxvf ruby-2.6.2.tar.gz && \
    cd ruby-2.6.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-install-doc && \
    make && \
    make install && \
    cd .. && \
    rm -r ruby-2.6.2 ruby-2.6.2.tar.gz && \
    echo 'gem: --no-document' > /usr/local/etc/gemrc && rm -rf /var/lib/apt/lists/*;

# Install Bundler for each version of ruby
RUN \
  echo 'gem: --no-rdoc --no-ri' >> /.gemrc && \
  gem install bundler

# install sqlite3
RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libmysqld-dev libpq-dev && rm -rf /var/lib/apt/lists/*;

# Install Node.js and npm
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
