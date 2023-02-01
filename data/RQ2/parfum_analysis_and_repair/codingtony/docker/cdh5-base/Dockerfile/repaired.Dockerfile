FROM ubuntu:12.04
MAINTAINER tony.bussieres@ticksmith.com
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb
RUN dpkg -i /cdh5-repository_1.0_all.deb
RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install --no-install-recommends -y oracle-java7-installer vim && rm -rf /var/lib/apt/lists/*;
