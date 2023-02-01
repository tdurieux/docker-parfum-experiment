FROM ubuntu:16.04

MAINTAINER Luiz Guilherme Silva <do.guilherme@hotmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux \
    NODE_VERSION=latest \
    NPM_VERSION=5.6.0 \
    IONIC_VERSION=latest \
    CORDOVA_VERSION=latest

#BASIC STUFF
RUN apt-get update \
    && apt-get install --no-install-recommends -y python-software-properties software-properties-common build-essential git wget curl unzip ruby autogen autoconf libtool \
    && git config --global user.email "email@email.com" \
    && git config --global user.name "Insert Your Name" \
    && curl -f -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt-get install --no-install-recommends -y nodejs \
    && npm install -g npm@"$NPM_VERSION" \
    && npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" \
    && npm install -g karma \
    #&& gem install sass \
    #&& ionic start myApp sidemenu \

   
A TUFF \
    && add-apt-reposi \
    && echo oracle-java8-installer shared/accept \
        && apt-get u
    && apt-get install -y oracle-java8-installer \
   
RO D STUFF \
    && echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment \
    && dpkg --add-ar \
    && apt-get update \
    && apt-get install -y --force-yes expect ant wge \
    && apt-get clean \
    && apt-get \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf /var/cache/oracl \
    && cd /opt \
    && wget --output-docum && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/tools

#UPDATE SDK
# COPY tools /opt/tools

# RUN chmod -R +x /opt/tools/android-accept-licenses.sh

# RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter platform-tools,tools,build-tools-23.0.2,android-23,extra-android-support,extra-android-m2repository,extra-google-m2repository"]
# RUN unzip ${ANDROID_HOME}/temp/*.zip -d ${ANDROID_HOME}

WORKDIR myApp
EXPOSE 8100 35729
CMD ["ionic", "lab"]