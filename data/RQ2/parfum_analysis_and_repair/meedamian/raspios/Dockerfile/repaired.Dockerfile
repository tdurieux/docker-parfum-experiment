FROM debian:buster-slim

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        curl \
        file \
        gnupg \
        unzip \
        wget \
        zip && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /mnt/raspios/ /data/
ADD ./firstboot*.service   /data/

VOLUME  /images/
WORKDIR /

ADD modify-image.sh /usr/local/bin/modify-image
RUN chmod +x        /usr/local/bin/modify-image

ENTRYPOINT ["/usr/local/bin/modify-image"]
CMD ["create"]
