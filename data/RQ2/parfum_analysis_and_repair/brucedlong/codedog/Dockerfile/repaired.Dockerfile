#Getting base image
#FROM gitpod/workspace-full-vnc
FROM ubuntu

# Install custom tools, runtime, etc.
USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential geany geany-plugins synaptic \
    meld libgtk-3-dev libcurl4-gnutls-dev libsdl2-dev libsdl2-mixer-dev \
    libicu-dev libgmp-dev libncurses5-dev xclip libwebsockets-dev wget \
    libasound2-dev libnss3-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pyparsing

USER gitpod
ENV PATH="$PATH:$HOME/workspace/CodeDog/"

# Give back control
USER root
