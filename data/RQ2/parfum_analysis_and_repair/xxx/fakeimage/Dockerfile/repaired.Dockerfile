FROM library/ruby:3.1.2-alpine
MAINTAINER Michael Dungan <mpd@jesters-court.net>
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update bundler && \
    apk add --no-cache \
      build-base \
      dumb-init \
      gcc \
      git \
      imagemagick \
      imagemagick-dev \
      wget && \
    mkdir /srv/fakeimage && rm -rf /root/.gem;

COPY Gemfile \
     Gemfile.lock \
     fakeimage.gemspec \
     /srv/fakeimage/
WORKDIR /srv/fakeimage
RUN bundle config github.https true && \
    bundle install && \
    apk del build-base gcc wget

COPY . /srv/fakeimage

EXPOSE 4567

CMD ["dumb-init", "ruby", "fakeimage.rb", "-o", "0.0.0.0"]
