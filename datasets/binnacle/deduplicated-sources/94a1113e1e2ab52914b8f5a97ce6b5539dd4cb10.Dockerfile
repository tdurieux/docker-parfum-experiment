FROM gliderlabs/alpine:3.2
MAINTAINER jari@kontena.io

RUN apk update && apk --update add ruby ruby-dev ca-certificates \
    libssl1.0 openssl libstdc++ tzdata

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies build-base openssl-dev && \
    gem install bundler && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody

ENV RACK_ENV production
EXPOSE 9292

WORKDIR /app

CMD ["bundle", "exec", "rackup"]
