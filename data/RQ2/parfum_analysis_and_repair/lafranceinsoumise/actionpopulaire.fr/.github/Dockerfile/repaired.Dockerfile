FROM ubuntu:20.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends git language-pack-fr libgdal-dev libsystemd-dev jq -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

