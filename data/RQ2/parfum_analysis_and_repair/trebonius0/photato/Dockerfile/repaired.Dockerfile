FROM openjdk:11
MAINTAINER trebonius0

WORKDIR /app
VOLUME /pictures /cache /config
EXPOSE 8186

# User creation
RUN useradd abc
RUN chown -R abc:abc /app /pictures /cache /config

# Dependencies install
RUN apt update -y && apt install --no-install-recommends -y exiftool unzip ffmpeg curl wget && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y


USER abc

ENV LANG C.UTF-8

# Software install
RUN \
    wget $( curl -f -s https://api.github.com/repos/trebonius0/photato/releases/latest | grep browser_download_url | cut -d '"' -f 4) \
    && unzip *.zip \
    && rm *.zip

# start
ENTRYPOINT ["java", "-jar", "Photato-Release.jar", "/pictures", "/cache", "/config"]