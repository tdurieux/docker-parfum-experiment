FROM stackbrew/debian:7.4
MAINTAINER Mesosphere support@mesosphere.io

RUN apt-get update && apt-get -y --no-install-recommends install \
  git \
  make \
  sudo \
  ruby-dev \
  python-pip \
  python-dev \
  libz-dev \
  protobuf-compiler \
  python-protobuf && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm
RUN pip install --no-cache-dir bbfreeze

ENV LC_ALL C.UTF-8
WORKDIR /container
ENTRYPOINT ["make"]
CMD ["deb"]
