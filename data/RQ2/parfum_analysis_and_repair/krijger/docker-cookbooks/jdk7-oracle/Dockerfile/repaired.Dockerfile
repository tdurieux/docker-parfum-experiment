FROM quintenk/supervisor

MAINTAINER Quinten Krijger "https://github.com/Krijger"

RUN apt-get -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get -y upgrade

# automatically accept oracle license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# and install java 7 oracle jdk
RUN apt-get -y --no-install-recommends install oracle-java7-installer && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --display java
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
