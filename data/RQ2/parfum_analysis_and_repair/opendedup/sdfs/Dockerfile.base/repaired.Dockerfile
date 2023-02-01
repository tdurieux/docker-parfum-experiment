FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
LABEL email=sam.silverberg@gmail.com
LABEL author="Sam Silverberg"
RUN DEBIAN_FRONTEND="noninteractive" apt update && DEBIAN_FRONTEND="noninteractive" apt upgrade -y && DEBIAN_FRONTEND="noninteractive" apt --no-install-recommends install -y \
		openjdk-11-jdk \
        maven \
        libfuse2 \
        ssh \
        openssh-server \
        jsvc \
        libxml2 \
        ruby-dev \
        build-essential \
        libxml2-utils \
        fuse \
        alien \
        git && rm -rf /var/lib/apt/lists/*;

RUN gem install fpm
COPY .git /sdfs-build/
COPY pom.xml /sdfs-build/
WORKDIR "/sdfs-build"
ENV VERSION=master
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
WORKDIR "/sdfs-build/"
RUN mvn dependency:copy-dependencies
ENTRYPOINT ls -lah