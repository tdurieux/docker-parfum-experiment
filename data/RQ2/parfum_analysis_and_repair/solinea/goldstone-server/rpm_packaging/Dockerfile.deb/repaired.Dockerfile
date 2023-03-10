FROM library/ubuntu:14.04.3

# initial installation
RUN apt-get -y update && apt-get install --no-install-recommends -y git wget tar sysstat rsyslog ruby \
    ruby-dev gcc make gdebi curl && rm -rf /var/lib/apt/lists/*;

# install fpm for packaging
RUN gem install --no-ri --no-rdoc fpm

# install bats integration framework
RUN git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local

WORKDIR /opt/goldstone
ADD . /opt/goldstone
