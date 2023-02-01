FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install --no-install-recommends software-properties-common ca-certificates -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ambrop7/badvpn -y
RUN apt-get update
RUN apt-get install --no-install-recommends -y badvpn curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libappindicator3-1 && rm -rf /var/lib/apt/lists/*;

ENV LANTERN_BINARY https://github.com/getlantern/lantern/releases/download/2.0.16/update_linux_amd64.bz2

RUN curl -f -L $LANTERN_BINARY | bzip2 -d - > /usr/bin/lantern
RUN chmod +x /usr/bin/lantern

COPY start.sh /usr/bin/start.sh

ENTRYPOINT ["/usr/bin/start.sh"]
