FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:cginternals/ppa
RUN apt update

RUN apt install --no-install-recommends -y libglbinding && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libglbinding-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libglbinding-all && rm -rf /var/lib/apt/lists/*;
