FROM balenalib/raspberrypi3-debian:buster

RUN apt-get update && \
    apt-get -qy --no-install-recommends install ca-certificates apt-transport-https wget systemd && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://raw.githubusercontent.com/lomoware/lomoware.github.io/master/debian/gpg.key | sudo apt-key add -

RUN echo "deb https://lomoware.lomorage.com/debian/buster buster main" | sudo tee /etc/apt/sources.list.d/lomoware.list

RUN apt-get update && apt-get -qy --no-install-recommends install lomo-vips && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -qy --no-install-recommends install nfs-common ffmpeg util-linux rsync jq libimage-exiftool-perl avahi-utils avahi-daemon && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -qy --no-install-recommends install psmisc net-tools iproute2 && rm -rf /var/lib/apt/lists/*;

ARG DUMMY=unknown

RUN DUMMY=${DUMMY} apt-get update && apt-get -qy --no-install-recommends install lomo-backend-docker && rm -rf /var/lib/apt/lists/*;

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
