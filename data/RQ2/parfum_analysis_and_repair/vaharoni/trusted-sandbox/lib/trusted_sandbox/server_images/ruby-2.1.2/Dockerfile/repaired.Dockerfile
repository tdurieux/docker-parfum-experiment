FROM ubuntu:14.04
MAINTAINER Amit Aharoni <amit.sites@gmail.com>

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev wget && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && wget https://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && tar -xvzf ruby-2.1.2.tar.gz && rm ruby-2.1.2.tar.gz
RUN cd /tmp/ruby-2.1.2/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && make && make install

RUN groupadd app && useradd -m -G app -d /home/sandbox sandbox

RUN gem install bundler
ADD Gemfile /home/sandbox/Gemfile
ADD bundle_config /home/sandbox/.bundle/config
RUN chown sandbox /home/sandbox/Gemfile && \
    chown sandbox /home/sandbox/.bundle && \
    chown sandbox /home/sandbox/.bundle/config && \
    sudo -u sandbox -i bundle install

ADD entrypoint.sh entrypoint.sh
ADD run.rb /home/sandbox/run.rb
RUN chown sandbox /home/sandbox/run.rb

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]