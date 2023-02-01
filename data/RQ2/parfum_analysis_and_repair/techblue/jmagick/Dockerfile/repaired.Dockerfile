FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y openjdk-7-jdk libmagickcore-dev libmagickwand-dev make && rm -rf /var/lib/apt/lists/*;

ADD docker/build.sh /
RUN chmod +x /build.sh
WORKDIR /src
VOLUME /src
VOLUME /build
CMD /build.sh



