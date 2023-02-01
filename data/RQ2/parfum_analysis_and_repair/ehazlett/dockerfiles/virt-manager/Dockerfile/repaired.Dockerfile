FROM debian:jessie
MAINTAINER ejhazlett@gmail.com
RUN apt-get update && apt-get install -y --no-install-recommends \
    virt-manager \
    ssh \
    ssh-askpass-gnome && rm -rf /var/lib/apt/lists/*; ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY unix$DISPLAY




COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
