FROM ubuntu:latest

COPY pkg.lst /tmp/pkg.lst

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install --no-install-recommends -y $(cat /tmp/pkg.lst) && rm -rf /var/lib/apt/lists/*;
