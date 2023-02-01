FROM ubuntu:14.04
MAINTAINER tony.bussieres@ticksmith.com
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install --no-install-recommends -y oracle-java7-installer && rm -rf /var/lib/apt/lists/*;

