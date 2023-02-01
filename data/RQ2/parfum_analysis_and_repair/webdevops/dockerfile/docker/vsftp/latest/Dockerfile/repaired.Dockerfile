#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/vsftp:latest
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:latest

ENV FTP_USER=application \
    FTP_PASSWORD=application \
    FTP_UID=1000 \
    FTP_GID=1000 \
    FTP_PATH=/data/ftp/

COPY conf/ /opt/docker/

RUN set -x \
    # Install vsftp