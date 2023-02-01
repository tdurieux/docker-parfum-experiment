FROM ubuntu:20.04

RUN apt update -y
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends binutils software-properties-common libcap2-bin -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386

RUN apt-get install --no-install-recommends lib32gcc-s1 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y && apt-get install --no-install-recommends apt-utils wget curl htop -y && rm -rf /var/lib/apt/lists/*;


RUN useradd -m -s /bin/bash ssm

RUN mkdir /opt/SSM
RUN chown -R ssm:ssm /opt/SSM

RUN mkdir -p /home/ssm/.SatisfactoryServerManager
RUN mkdir -p /home/ssm/.config/Epic/FactoryGame

RUN chown -R ssm:ssm /home/ssm

VOLUME /opt/SSM

COPY entry.sh /
COPY release-builds/linux/* /opt/SSM

RUN chown -R ssm:ssm /opt/SSM

EXPOSE 3000/tcp

ENTRYPOINT [ "/entry.sh" ]