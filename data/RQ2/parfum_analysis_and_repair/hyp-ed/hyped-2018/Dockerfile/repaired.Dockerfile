FROM resin/beaglebone-black-debian
RUN [ "cross-build-start" ]
RUN apt-get update && apt-get install --no-install-recommends -y build-essential python && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /test
WORKDIR /test
RUN [ "cross-build-end" ]