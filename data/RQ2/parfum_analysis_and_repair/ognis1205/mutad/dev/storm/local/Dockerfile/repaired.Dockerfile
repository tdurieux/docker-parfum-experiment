FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y unzip && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y python && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64


ARG SPARK_DISTRO=apache-storm-2.2.0

RUN set -ex; \
    wget -q "https://www.apache.org/dist/storm/$SPARK_DISTRO/$SPARK_DISTRO.tar.gz"; \
    export GNUPGHOME="$(mktemp -d)"; rm -rf -d \
    tar -xzf "$SPARK_DISTRO.tar.gz"; \
    rm "$SPARK_DISTRO.tar.gz";

ENV PATH $PATH:/$SPARK_DISTRO/bin


COPY IndexDirectory.zip /IndexDirectory.zip

RUN IndexDirectory.zip && \
    rm IndexDirectory.zip

COPY worldcities.csv.zip /worldcities.csv.zip

RUN unzip worldcities.csv.zip && \
    rm worldcities.csv.zip


RUN mkdir /storm

WORKDIR /storm

COPY start.sh /storm/start.sh

CMD /storm/start.sh