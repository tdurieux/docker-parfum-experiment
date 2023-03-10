FROM debian:latest
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install --no-install-recommends \
    tmux screen nano vim procps less netcat-openbsd xinetd && \
  apt clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -s /bin/bash -m -u 1337 user && \
useradd -s /bin/bash -m -u 1338 admin

COPY flag /home/admin/
COPY xinetd.conf /etc/
COPY dist/* /usr/local/bin/

RUN chown admin:admin /home/admin/flag && \
chmod 440 /home/admin/flag && \
chmod 711 /usr/local/bin/nchandler && \
chmod 700 /usr/local/bin/init

RUN ln -snf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

ENV HOME /home/user
USER root:1337
ENTRYPOINT ["/usr/local/bin/init"]
WORKDIR "/home/user/"
