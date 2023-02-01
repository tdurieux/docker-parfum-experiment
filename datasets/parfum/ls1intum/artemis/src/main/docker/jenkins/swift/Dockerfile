FROM jenkins/jenkins:lts

LABEL description="Jenkins with maven, python3.6, gcc and swift libraries pre-installed for Artemis"

USER root

RUN apt update

# Install Java and Maven dependencies
RUN apt-get install -y maven
RUN cd /usr/lib/jvm && \
    wget https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16%2B36/OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz && \
    tar -zxf OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz \
    && mv jdk-16+36 java-16-openjdk-amd64 \
    && rm OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz
RUN chown -R root:root /usr/lib/jvm/java-16-openjdk-amd64
RUN JAVA_HOME="/usr/lib/jvm/java-16-openjdk-amd64" && export JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-16-openjdk-amd64

# Install C dependencies
RUN apt install -y gcc gdb make libubsan0 liblsan0 libtsan0

# Some packages need to be installed to avoid some known problems for python3.6, see: https://github.com/pyenv/pyenv/wiki/Common-build-problems
RUN apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev

# Install Python3.8
RUN wget https://www.python.org/ftp/python/3.8.6/Python-3.8.6.tgz && \
    tar xvf Python-3.8.6.tgz \
    && cd Python-3.8.6 \
    && ./configure --enable-shared \
    && make -j8 \
    && make altinstall
RUN apt install -y python3 python3-pip
RUN cd ..
RUN rm -r -f Python3.8.6/ && rm -f Python-3.8.6.tgz

# Install pytest for python exercises
RUN pip3 install -U pytest

# Install Swift and SwiftLint (adapted from norionomura/swift and norionomura/swiftlint)
ENV SWIFT_BRANCH swift-5.3.1-release
ENV SWIFT_PLATFORM ubuntu18.04
ENV SWIFT_VERSION 5.3.1-RELEASE
RUN apt-get install -y --no-install-recommends \
    gnupg2 \
    libcurl4-openssl-dev \
    libxml2-dev \
    && rm -r /var/lib/apt/lists/*
# Install Swift keys
RUN curl https://swift.org/keys/all-keys.asc | gpg2 --import -
# Install Swift toolchain
# -> https://swift.org/builds/swift-5.3.1-release/ubuntu1804/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-ubuntu18.04.tar.gz
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM && \
    SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/swift-$SWIFT_VERSION/$SWIFT_ARCHIVE_NAME.tar.gz && \
    curl -O $SWIFT_URL && \
    curl -O $SWIFT_URL.sig && \
    gpg2 --verify $SWIFT_ARCHIVE_NAME.tar.gz.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz --directory / --strip-components=1 && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/* && \
    chmod -R o+r /usr/lib/swift
# Install SwiftLint
RUN git clone --branch master https://github.com/realm/SwiftLint.git && \
    cd SwiftLint && \
    swift build --configuration release -Xswiftc -static-stdlib && \
    mv $(swift build --configuration release -Xswiftc -static-stdlib --show-bin-path)/swiftlint /usr/bin && \
    cd .. && \
    rm -rf SwiftLint

# Install third-party plugins required by Artemis
COPY ../plugins.yml /usr/share/jenkins/ref/plugins.yml
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yml

# Install docker client (if you want a local build agent)
# (Uncomment this line if you want to use a local docker build agent e.g for development purposes)
#RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz | tar xvz --directory /tmp && mv -v /tmp/docker/docker /usr/local/bin/docker && chmod +x /usr/local/bin/docker && rm -rf /tmp/docker

# Disables the first-time setup wizard of Jenkins
# (Uncomment this line if you're using jenknis-casc-config.yml for auto-configuration)
#ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER jenkins
