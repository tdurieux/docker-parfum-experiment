# ------------------------- Dexcalibur Docker image
FROM ubuntu:20.04

MAINTAINER Axelle Apvrille
ENV REFRESHED_AT 2021-05-10

ARG DEBIAN_FRONTEND=noninteractive
ARG JDK_VERSION=8
ENV FRIDA_VERSION 14.2.18
ENV FRIDA_SERVER frida-server-${FRIDA_VERSION}-android-x86_64.xz

# --------------------- Various requirements -------------------------
RUN apt-get update && \
       apt-get install --no-install-recommends -yqq curl dirmngr apt-transport-https lsb-release ca-certificates adb \
        python3-pip python openjdk-${JDK_VERSION}-jdk build-essential wget && rm -rf /var/lib/apt/lists/*;

# ----------------------- Install Dexcalibur -----------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -yqq nodejs && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir frida-tools
RUN npm install -g npm && npm install -g dexcalibur && npm cache clean --force;
RUN mkdir -p /workshop && wget -q -O /workshop/${FRIDA_SERVER} https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/${FRIDA_SERVER} && cd /workshop && unxz ${FRIDA_SERVER}

# ------------------------- Clean up
RUN apt-get clean && apt-get autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /usr/share/doc/* > /dev/null 2>&1

# ------------------------- Final matter
WORKDIR /workshop
VOLUME ["/data"]
CMD [ "/bin/bash" ]


EXPOSE 8000

