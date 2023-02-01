FROM debian:jessie

RUN apt-get update
RUN apt-get install --no-install-recommends -yq xpra && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq xterm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq dbus && rm -rf /var/lib/apt/lists/*;

ADD run.sh /
