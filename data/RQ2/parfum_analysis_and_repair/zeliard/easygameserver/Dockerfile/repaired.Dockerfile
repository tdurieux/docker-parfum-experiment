FROM ubuntu:14.04
MAINTAINER zeliard <cyberjam@gmail.com>

RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp

RUN wget https://github.com/zeliard/EasyGameServer/archive/linux.zip
RUN unzip linux.zip
WORKDIR EasyGameServer-linux/EasyGameServer/EasyGameServerLinux/

RUN make
RUN cp -r database/ ./Debug/

WORKDIR Debug

CMD ["./EasyGameServerLinux"]

EXPOSE 9001

