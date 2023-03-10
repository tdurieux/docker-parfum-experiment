FROM debian:buster

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install --no-install-recommends -y make imagemagick curl jq wget procps intltool && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Volume pointing to spksrc sources
VOLUME /spksrc

WORKDIR /spksrc

COPY syn-pkg-entrypoint.sh /syn-pkg-entrypoint.sh
ENTRYPOINT ["/syn-pkg-entrypoint.sh"]
