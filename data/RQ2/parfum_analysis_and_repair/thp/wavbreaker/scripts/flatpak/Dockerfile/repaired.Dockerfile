FROM ubuntu:rolling

RUN mkdir /build

WORKDIR /build

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y flatpak-builder && rm -rf /var/lib/apt/lists/*;

RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

RUN flatpak install -y org.freedesktop.Sdk//20.08
RUN flatpak install -y org.freedesktop.Platform//20.08
