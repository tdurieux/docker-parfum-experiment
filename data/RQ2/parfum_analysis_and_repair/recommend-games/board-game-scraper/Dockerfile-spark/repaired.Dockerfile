FROM bg-scraper:latest

RUN mkdir --parents /app /opt
WORKDIR /opt

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Java 8 installation instructions: https://linuxize.com/post/install-java-on-debian-10/#installing-openjdk-8
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        software-properties-common=0.96.20.2-2 && \
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    apt-get -y update && \
    apt-get -y install --no-install-recommends \
	    adoptopenjdk-8-hotspot=8u252-b09-2 && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget -qO - https://downloads.apache.org/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz | tar -xvz

ENV JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64
ENV SPARK_HOME=/opt/spark-2.4.5-bin-hadoop2.7

WORKDIR /app

ENTRYPOINT ["pipenv", "run"]
CMD ["scrapy", "list"]