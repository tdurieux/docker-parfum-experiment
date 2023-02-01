## This base image is for running the latest lbrynet-daemon release.
FROM ubuntu:18.04 as prep
LABEL MAINTAINER="leopere [at] nixc [dot] us"
RUN apt-get update && apt-get -y --no-install-recommends install unzip curl && rm -rf /var/lib/apt/lists/*;

## Add lbrynet
ARG VERSION=latest
RUN URL=$( curl -f -Ls https://api.github.com/repos/lbryio/lbry-sdk/releases/$(if [ "${VERSION}" = 'latest' ]; then echo "latest"; else echo "tags/${VERSION}"; fi) | grep browser_download_url | grep lbrynet-linux.zip | cut -d'"' -f4) && echo $URL && curl -f -L -o /lbrynet.linux.zip $URL


COPY ./core/checkmount.sh /usr/bin/checkmount
RUN unzip /lbrynet.linux.zip -d /lbrynet/ && \
    mv /lbrynet/lbrynet /usr/bin && \
    chmod a+x /usr/bin/checkmount /usr/bin/lbrynet

FROM ubuntu:18.04 as app
COPY --from=prep /usr/bin/checkmount /usr/bin/lbrynet /usr/bin/
RUN adduser lbrynet --gecos GECOS --shell /bin/bash --disabled-password --home /home/lbrynet

RUN apt-get update
RUN apt-get install --no-install-recommends --yes software-properties-common && \
    add-apt-repository universe && \
    apt-get --fix-broken -y install && \
    apt-get update && \
    apt-get install --no-install-recommends -y wget apt-transport-https && \
    apt-get install --no-install-recommends -y build-essential cron && \
    apt-get install --no-install-recommends --yes libboost-all-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential \
      zlib1g-dev \
      libncurses5-dev \
      libgdbm-dev \
      libnss3-dev \
      libssl-dev \
      libreadline-dev \
      libffi-dev \
      libbz2-dev \
      liblzma-dev \
      nfs-common && rm -rf /var/lib/apt/lists/*;

# Pull down Python 3.7, build, and install
RUN add-apt-repository ppa:deadsnakes/ppa && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.7-dev \
      python3-pip \
      python3.7-venv \
      git \
      man && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/lbrynet

COPY ./core/lbrynet_home/lbry-seedit.py /seedit/lbry-seedit.py
COPY ./core/lbrynet_home/seedit_config.yaml /seedit/seedit_config.yaml
COPY ./core/requirements.txt ./requirements.txt
COPY ./core/daemon_settings.yml /etc/lbry/daemon_settings.yml
COPY ./core/lbrycron /etc/cron.d/lbrycron
RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install -r requirements.txt
RUN chmod 0644 /etc/cron.d/lbrycron
RUN crontab /etc/cron.d/lbrycron
RUN touch /var/log/cron.log
CMD cron && tail -f /var/log/cron.log

## Daemon port [Intended for internal use]
## LBRYNET talks to peers on port 3333 [Intended for external use] this port is used to discover other lbrynet daemons with blobs.
## Expose 5566 Reflector port to listen on
## Expose 5279 Port the daemon API will listen on
## the lbryumx aka Wallet port [Intended for internal use]
# EXPOSE 4444 3333 5566 5179 50001 5280 5279
EXPOSE 4444/udp 4444 3333 5279

# Run the lbry command
ENTRYPOINT ["/usr/bin/checkmount"]
CMD ["lbrynet", "start", "--config", "/etc/lbry/daemon_settings.yml"]
#ENTRYPOINT ["tail", "-F", "/dev/null"]

# Where the lbrydata and seedit script are stored
VOLUME ["/home/lbrynet"]
