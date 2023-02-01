#FROM debian:stretch
FROM ubuntu:18.04
LABEL maintainer="The Luxcore Developers <giaki3003@luxcore.io>"
LABEL description="Dockerised Luxcore, built from Travis"

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/LUX-Core/lux/releases/download/v5.2.3/lux-qt-linux-18.zip
RUN unzip lux-qt-linux-18.zip
RUN cp luxd /usr/local/bin

VOLUME ["/opt/lux"]

EXPOSE 9888
EXPOSE 9888
EXPOSE 9777
EXPOSE 9777

CMD ["luxd", "--conf=/opt/lux/lux.conf", "--printtoconsole"]