# This Dockerfile is used to build an image that I can use to build a kernel with my scripts
FROM moul/kernel-builder
MAINTAINER Jared Hulbert <jaredeh@gmail.com>

RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN gem install open4
