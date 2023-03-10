FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y unzip ca-certificates && rm -rf /var/lib/apt/lists/*

COPY cmd/check/check /opt/resource/check
COPY cmd/in/in /opt/resource/in
COPY cmd/out/out /opt/resource/out