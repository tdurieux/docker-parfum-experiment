FROM ubuntu:16.04
MAINTAINER Julian Seeger <seeger@qabel.de>

RUN dpkg --add-architecture i386 && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections  && \
    apt-get update -y && \
    apt-get install --no-install-recommends -yqf \
        wine \
        unzip \
        unp \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y && apt-get install --no-install-recommends -yqf \
    xvfb && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y && \
    apt-get install --no-install-recommends -yqf \
        python-software-properties \
        software-properties-common && \
    apt-add-repository -y ppa:webupd8team/java && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    apt-get update -y && \
    apt-get install --no-install-recommends -yqf oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y && \
    apt-get install --no-install-recommends -yqf \
        git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash vagrant
USER vagrant
