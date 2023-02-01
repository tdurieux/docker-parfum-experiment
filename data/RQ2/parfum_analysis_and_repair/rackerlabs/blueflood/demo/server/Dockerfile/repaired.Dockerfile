FROM ubuntu:20.04

# Tell the apt installs not to wait for user input
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -f --no-install-recommends -y install \
    curl \
    git \
    gnupg \
    maven \
    net-tools \
    openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

RUN update-java-alternatives -s java-1.8.0-openjdk-amd64

RUN git clone http://github.com/rackerlabs/blueflood.git /src/blueflood && \
    cd /src/blueflood && \
    mvn package -Dmaven.javadoc.skip -Pskip-unit-tests -Pskip-integration-tests

RUN curl -f -L https://debian.datastax.com/debian/repo_key | apt-key add - && \
    echo "deb http://debian.datastax.com/community/ stable main" >> /etc/apt/sources.list.d/datastax.list && \
    apt-get update && \
    apt-get -y --no-install-recommends install cassandra && rm -rf /var/lib/apt/lists/*;

ADD . /src
EXPOSE 9160
EXPOSE 7199
EXPOSE 19000
EXPOSE 20000
CMD ["/src/start.sh"]
