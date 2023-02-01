FROM ubuntu:trusty

MAINTAINER foostan ks@fstn.jp

RUN apt-get update
RUN apt-get install --no-install-recommends -y unzip wget curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apache2 ntp && rm -rf /var/lib/apt/lists/*; # install sample packages

RUN mkdir /consul

RUN cd /consul && \
    wget https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip && \
    unzip 0.4.0_linux_amd64.zip && \
    mv consul /usr/local/bin

RUN cd /consul && \
    wget https://dl.bintray.com/mitchellh/consul/0.4.0_web_ui.zip && \
    unzip 0.4.0_web_ui.zip && \
    mv dist ui

RUN cd /consul && \
    wget https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip && \
    wget https://dl.bintray.com/foostan/fileconsul/0.1.1_linux_amd64.zip && \
    unzip 0.1.1_linux_amd64.zip && \
    mv fileconsul /usr/local/bin

ADD share /consul/share

CMD ["/bin/bash"]
