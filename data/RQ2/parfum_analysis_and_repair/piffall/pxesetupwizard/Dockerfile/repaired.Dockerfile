FROM ubuntu:16.04
MAINTAINER Cristòfol Torrens "piffall@gmail.com"

RUN apt-get update && apt-get -y --no-install-recommends install git tftpd-hpa unzip wget curl p7zip-full xzip xz-utils cpio && rm -rf /var/lib/apt/lists/*;

WORKDIR /srv/tftp
ADD . /srv/tftp

ENTRYPOINT ["/srv/tftp/entrypoint.sh"]
CMD ["start"]

EXPOSE 69/udp
