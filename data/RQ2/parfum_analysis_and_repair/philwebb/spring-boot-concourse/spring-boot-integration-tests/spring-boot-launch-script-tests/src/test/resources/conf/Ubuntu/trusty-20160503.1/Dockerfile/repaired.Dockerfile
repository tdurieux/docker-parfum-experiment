FROM ubuntu:trusty-20160503.1
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install --no-install-recommends -y oracle-java8-installer && \
    apt-get install --no-install-recommends -y curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
