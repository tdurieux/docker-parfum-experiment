FROM ubuntu:16.04
LABEL maintainer="https://blog.csdn.net/qq_41453285"
ENV REFRESHED_AT 2020-07-27

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install ruby ruby-dev libffi-dev build-essential nodejs && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-rdoc --no-ri jekyll -v 2.5.3

VOLUME /data
VOLUME /var/www/html
WORKDIR /data

ENTRYPOINT [ "jekyll", "build", "--destination=/var/www/html" ]
