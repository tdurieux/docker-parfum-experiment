FROM ubuntu:xenial

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update

RUN apt-get install --no-install-recommends -y curl unzip bzip2 zip git tig openjdk-8-jdk build-essential && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s get.sdkman.io | bash
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install grails 2.5.0 && \
    sdk install groovy 2.4.3 && \
    npm install gulp && \
    npm install -g gulp-cli && \
    sh"
