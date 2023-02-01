FROM ubuntu:16.04

WORKDIR /home/Creditcoin/Gateway

COPY . /home/Creditcoin/Gateway/

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install --no-install-recommends -y dotnet-runtime-3.1 && rm -rf /var/lib/apt/lists/*;