FROM ubuntu:14.04
MAINTAINER ss <sarjeetsingh@maprtech.com>
RUN echo "deb http://apt.qa.lab/myriad mapr optional" >> /etc/apt/sources.list
RUN echo "deb http://apt.qa.lab/opensource binary/" >> /etc/apt/sources.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://package.mapr.com/releases/pub/maprgpg.key
RUN apt-key add maprgpg.key
RUN sudo apt-get -y update
RUN apt-get install --no-install-recommends openjdk-7-jdk -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends mapr-cldb mapr-fileserver mapr-zookeeper -y && rm -rf /var/lib/apt/lists/*;
