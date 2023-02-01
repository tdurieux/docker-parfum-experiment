FROM golang:latest

# Grab deps (jq, hexdump, xxd, killall)
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  jq bsdmainutils vim-common psmisc netcat && rm -rf /var/lib/apt/lists/*;

# Add testing deps for curl
RUN echo 'deb http://httpredir.debian.org/debian testing main non-free contrib' >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;

VOLUME /go

EXPOSE 26656
EXPOSE 26657
