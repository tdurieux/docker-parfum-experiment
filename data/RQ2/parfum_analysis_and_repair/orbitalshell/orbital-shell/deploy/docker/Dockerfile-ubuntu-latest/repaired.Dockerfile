FROM ubuntu:latest
MAINTAINER Yobatman38 < yobatman [ at ] gmail.com >

COPY OrbitalShell-CLI/bin/Debug/net5.0/ /home/orbsh/
RUN apt-get update \
    && apt-get install --no-install-recommends -y apt-transport-https wget \
    && apt autoclean \
    && apt clean \
    && apt autoremove --purge \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /root/packages-microsoft-prod.deb \
    && dpkg -i /root/packages-microsoft-prod.deb \
    && rm /root/packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install --no-install-recommends -y dotnet-runtime-5.0 \
    && chmod +x /home/orbsh/orbsh \
    && apt autoclean \
    && apt clean \
    && apt autoremove --purge \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/home/orbsh:${PATH}"

ENTRYPOINT ["/home/orbsh/orbsh"]
