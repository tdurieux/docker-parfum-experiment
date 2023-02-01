FROM ubuntu:xenial

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y --no-install-recommends install \
    curl wget build-essential ruby ruby-dev unzip git && rm -rf /var/lib/apt/lists/*;

COPY Gemfile /tmp
COPY Gemfile.lock /tmp

RUN gem install bundler \
  && bundle install --gemfile=/tmp/Gemfile \
  && rm /tmp/Gemfile /tmp/Gemfile.lock

COPY container-build.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/container-build.sh", "-d", "xenial", "-i"]
