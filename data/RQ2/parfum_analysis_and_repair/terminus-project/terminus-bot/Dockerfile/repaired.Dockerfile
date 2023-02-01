FROM phusion/baseimage:0.9.17

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install ruby ruby-dev build-essential ruby-bundler git libssl-dev && rm -rf /var/lib/apt/lists/*;

ADD . /terminus-bot
RUN useradd --create-home terminus-bot

WORKDIR /terminus-bot
RUN cd /terminus-bot
RUN bundle install

ADD doc/runit/ /etc/service

VOLUME /var/lib/terminus-bot

CMD ["/sbin/my_init"]
