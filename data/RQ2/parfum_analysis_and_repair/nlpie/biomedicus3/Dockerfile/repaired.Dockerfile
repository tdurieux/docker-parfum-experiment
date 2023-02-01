FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get -qy --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy --no-install-recommends install openjdk-11-jre-headless && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy --no-install-recommends install python3 python3-pip && rm -rf /var/lib/apt/lists/*;

COPY . /home/biomedicus3/biomedicus3

WORKDIR /home/biomedicus3

RUN pip3 install --no-cache-dir ./biomedicus3
RUN biomedicus download-data

CMD /bin/sh
