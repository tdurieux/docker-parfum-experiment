FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2016-06-01

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install ruby ruby-dev libffi-dev build-essential nodejs && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-rdoc --no-ri jekyll -v 2.5.3

VOLUME /data
VOLUME /var/www/html
WORKDIR /data

ENTRYPOINT [ "jekyll", "build", "--destination=/var/www/html" ]
