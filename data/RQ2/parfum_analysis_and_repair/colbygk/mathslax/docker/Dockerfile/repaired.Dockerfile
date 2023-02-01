FROM ubuntu:xenial

MAINTAINER Colby Gutierrez-Kraybill <colbygk@media.mit.edu>

RUN apt-get -qq update

# Install Node.js
RUN apt-get -qq --no-install-recommends install --yes curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -qq --no-install-recommends install --yes nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends install --yes build-essential && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qq install -y \
  default-jre \
  git \
  openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

ENV SERVER fqdn
ENV PORT 8099

EXPOSE 8099

RUN git clone https://github.com/colbygk/mathslax.git
WORKDIR /mathslax
RUN make install

ENTRYPOINT ["/usr/bin/node"]
CMD ["server.js"]

