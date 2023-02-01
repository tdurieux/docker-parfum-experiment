FROM kreable/php70

USER root

RUN cat /etc/*-release
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java8-installer && \
  rm -rf /var/cache/oracle-jdk8-installer && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y oracle-java8-set-default && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y firefox xvfb && rm -rf /var/lib/apt/lists/*;

RUN wget -O /root/selenium.jar https://selenium-release.storage.googleapis.com/3.4/selenium-server-standalone-3.4.0.jar
