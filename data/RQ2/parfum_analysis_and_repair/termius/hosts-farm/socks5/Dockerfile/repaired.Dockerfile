FROM ubuntu:20.04

RUN apt-get update -y && apt-get install --no-install-recommends -y locales && \
  locale-gen en_US.UTF-8 && update-locale LC_ALL="en_US.UTF-8" && rm -rf /var/lib/apt/lists/*;
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install --no-install-recommends -y dante-server && rm -rf /var/lib/apt/lists/*;
ENV SOCKS_USER=termius SOCKS_PASSWORD=test
RUN useradd --shell /usr/sbin/nologin -m $SOCKS_USER && \
  echo "$SOCKS_USER:$SOCKS_PASSWORD" | chpasswd
COPY danted.conf /etc/danted.conf
EXPOSE 1080
CMD ["danted"]
