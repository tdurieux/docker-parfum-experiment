FROM ubuntu:22.04
LABEL maintainer="Tim Chaubet"
VOLUME ["/mnt/vrising/server", "/mnt/vrising/persistentdata"]

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get install --no-install-recommends -y software-properties-common \
                        tzdata && \
    add-apt-repository multiverse && \
    dpkg --add-architecture i386 && \
    apt update -y && \
    apt-get upgrade -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m steam && cd /home/steam && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    apt purge steam steamcmd && \
    apt install --no-install-recommends -y gdebi-core \
                   libgl1-mesa-glx:i386 \
                   wget && \
    apt install --no-install-recommends -y steam \
                   steamcmd && \
    ln -s /usr/games/steamcmd /usr/bin/steamcmd && rm -rf /var/lib/apt/lists/*;
#RUN apt install -y mono-complete
RUN apt install --no-install-recommends -y wine && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y xserver-xorg \
                   xvfb && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoremove -y

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
