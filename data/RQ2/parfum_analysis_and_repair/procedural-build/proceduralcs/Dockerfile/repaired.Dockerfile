FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install --no-install-recommends -y git build-essential wget && \
  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get update && \
  apt-get install --no-install-recommends -y apt-transport-https && \
  apt-get update && \
  apt-get install --no-install-recommends -y dotnet-sdk-3.1 && rm -rf /var/lib/apt/lists/*;