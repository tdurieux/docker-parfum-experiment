# appserver for https://github.com/nemoo/play-slick-example
#
# VERSION               0.0.1

FROM      ubuntu:14.04

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends git default-jre htop unzip wget && rm -rf /var/lib/apt/lists/*;

ADD /myapp.zip /
RUN unzip myapp.zip

CMD play-slick-example-1.0-SNAPSHOT/bin/play-slick-example -DapplyEvolutions.default=true

EXPOSE 9000