FROM ruby:2.4.10-buster

RUN apt-get update && apt-get install --no-install-recommends -y \
  qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x && rm -rf /var/lib/apt/lists/*;

WORKDIR /firehose/
COPY . /firehose/
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system 3.2.3 && rm -rf /root/.gem;
RUN gem install bundler:2.3.6
RUN bundle

EXPOSE 7474
CMD bundle exec firehose server
