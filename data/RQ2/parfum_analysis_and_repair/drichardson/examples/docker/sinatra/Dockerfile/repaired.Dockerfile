# Example Dockerfile from
# https://docs.docker.com/userguide/dockerimages/
FROM ubuntu:14.04
MAINTAINER Doug Richardson <dougie.richardson@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install sinatra

