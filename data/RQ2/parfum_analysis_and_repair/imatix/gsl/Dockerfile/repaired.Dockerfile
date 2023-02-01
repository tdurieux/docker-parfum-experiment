FROM ubuntu:trusty
MAINTAINER Godefroid Chapelle <gotcha@bubblenet.be>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q --force-yes build-essential && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q --force-yes libpcre3-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /tmp/gsl
COPY src /tmp/gsl/src
COPY pcre /tmp/gsl/pcre
WORKDIR /tmp/gsl/src
RUN make
RUN make install
ENTRYPOINT ["/usr/local/bin/gsl"]
