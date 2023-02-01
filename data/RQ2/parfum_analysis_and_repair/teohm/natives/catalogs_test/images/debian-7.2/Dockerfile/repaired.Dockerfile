FROM tianon/debian:7.2

MAINTAINER Huiming Teo (@teohm)

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install ruby1.9.1-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler
RUN gem install natives
