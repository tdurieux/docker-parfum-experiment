FROM ubuntu

RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends -y arp-scan net-tools iputils-ping && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

ADD ranchervm /
ENTRYPOINT ["/ranchervm"]
CMD ["-v", "3"]
