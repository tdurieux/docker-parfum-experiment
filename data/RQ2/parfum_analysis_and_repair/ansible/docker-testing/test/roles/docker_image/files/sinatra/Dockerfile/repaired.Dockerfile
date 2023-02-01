# taken from https://docs.docker.com/engine/userguide/containers/dockerimages/
FROM ubuntu:14.04
MAINTAINER Kate Smith <ksmith@example.com>
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install sinatra
