FROM ubuntu
MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

EXPOSE 8080

# Required for apt-add-repository
RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9
RUN apt-add-repository "deb http://repos.azulsystems.com/ubuntu stable main"
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get -qq update
RUN apt-get -qq upgrade

RUN apt-get -qq -y --no-install-recommends install curl bash unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install zulu-8 && rm -rf /var/lib/apt/lists/*;

ADD start-jetty.sh /opt/start-jetty.sh
RUN chmod +x /opt/start-jetty.sh

# Install Jetty
ADD http://download.eclipse.org/jetty/8.1.17.v20150415/dist/jetty-distribution-8.1.17.v20150415.tar.gz /opt/jetty.tar.gz
RUN tar -xvf /opt/jetty.tar.gz -C /opt/ && rm /opt/jetty.tar.gz
RUN rm /opt/jetty.tar.gz
RUN mv /opt/jetty-distribution-* /opt/jetty
RUN rm -rf /opt/jetty/webapps.demo
RUN useradd jetty -U -s /bin/false
RUN chown -R jetty:jetty /opt/jetty

# Setup UTF * based terminal
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JAVA_HOME /usr/lib/jvm/zulu-8-amd64/

# Run Jetty
CMD ["/opt/start-jetty.sh"]
