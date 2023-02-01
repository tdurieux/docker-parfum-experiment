FROM docker.io/ubuntu:focal AS build-stage
WORKDIR /CPU-X
ENV DEBIAN_FRONTEND=noninteractive
ENV APPIMAGE_EXTRACT_AND_RUN=1
ARG TZ=UTC
COPY . .
RUN apt-get update -y && apt-get install --no-install-recommends -y sudo curl wget gnupg2 patchelf librsvg2-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -snf "/usr/share/zoneinfo/$TZ" "/etc/localtime" && echo "$TZ" > /etc/timezone
RUN ./scripts/build_ubuntu.sh "Debug" "/CPU-X" "/AppDir"
RUN ./scripts/build_appimage.sh "/CPU-X" "/AppDir"
