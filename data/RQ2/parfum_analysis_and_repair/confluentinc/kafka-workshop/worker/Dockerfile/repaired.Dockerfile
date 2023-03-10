FROM ubuntu

COPY data/ .

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y autoremove
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y byobu && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y htop && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y man && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

WORKDIR /workshop
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Define default command.
CMD ["bash"]

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/confluentinc/demo-scene demo-scene
RUN cd demo-scene/streams-movie-demo && ./gradlew build

ARG COMMIT_ID=unknown
LABEL io.confluent.docker.git.id=$COMMIT_ID
ARG BUILD_NUMBER=-1
LABEL io.confluent.docker.build.number=$BUILD_NUMBER
LABEL io.confluent.docker=true

#WORKDIR /build
ENV VERSION=1.3.0-1

ENV BUILD_PACKAGES="build-essential cmake python git curl zlib1g-dev libsasl2-dev libssl-dev "
RUN echo "Building kafkacat ....." \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y $BUILD_PACKAGES \
    && git clone https://github.com/edenhill/kafkacat \
    && cd kafkacat \
    && git checkout tags/debian/$VERSION \
    && ./bootstrap.sh \
    && make install \
    && cd .. && rm -rf kafkacat-debian-$VERSION \
    && AUTO_ADDED_PACKAGES=`apt-mark showauto` \
    && apt-get remove --purge -y $BUILD_PACKAGES \

    && echo "Installing runtime dependencies for SSL and SASL support ...." \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        openssl \
        libssl1.0.0 \
        libsasl2-2 \
        libsasl2-modules-gssapi-mit \
        krb5-user \
        krb5-config \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
