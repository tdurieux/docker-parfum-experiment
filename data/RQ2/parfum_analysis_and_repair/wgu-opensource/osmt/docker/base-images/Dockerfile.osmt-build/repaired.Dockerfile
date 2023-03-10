FROM wguopensource/osmt-base:latest as osmt-build

ENV M2_VERSION=3.8.4
ENV M2_HOME=/usr/local/maven
ENV PATH=${M2_HOME}/bin:${PATH}

# Download / Install Maven
ADD https://dlcdn.apache.org/maven/maven-3/${M2_VERSION}/binaries/apache-maven-${M2_VERSION}-bin.tar.gz /usr/share/src/

WORKDIR /usr/share/src

RUN tar -xf apache-maven-${M2_VERSION}-bin.tar.gz \
    && mv apache-maven-${M2_VERSION} ${M2_HOME}/ && rm apache-maven-${M2_VERSION}-bin.tar.gz

