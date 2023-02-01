FROM openjdk:8u181-jdk
# FROM openjdk:11
COPY . /home
WORKDIR /home

#install and source ansible
RUN apt-get update && apt-get install --no-install-recommends -y \
    iptables && apt-get install --no-install-recommends -y ant && \
    apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;

RUN ant clean
RUN ant

RUN chmod +x ./runscripts/*

