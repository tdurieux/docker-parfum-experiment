FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2014-06-01

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install ruby ruby-dev build-essential redis-tools && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-rdoc --no-ri sinatra json redis

RUN mkdir -p /opt/webapp

EXPOSE 4567

CMD [ "/opt/webapp/bin/webapp" ]
