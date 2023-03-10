FROM docker.io/phusion/baseimage:0.9.21
MAINTAINER fred.liu <461382141@qq.com>

RUN apt-get update && apt-get install --no-install-recommends -y unzip tar openjdk-8-jdk wget git && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/gradle
RUN wget https://services.gradle.org/distributions/gradle-4.0-bin.zip \
    && unzip gradle-4.0-bin.zip \
    && rm -rf gradle-4.0-bin.zip
RUN wget https://services.gradle.org/distributions/gradle-3.5-bin.zip \
    && unzip gradle-3.5-bin.zip \
    && rm -rf gradle-3.5-bin.zip

ENV gradle3 /opt/gradle/gradle-3.5/bin
ENV gradle4 /opt/gradle/gradle-4.0/bin
ENV PATH /opt/gradle/gradle-4.0/bin:/opt/gradle/gradle-3.5/bin:$PATH

WORKDIR /root
COPY ./compile.sh /root/compile.sh
RUN chmod 777 /root/compile.sh

CMD /root/compile.sh