# docker pull jesseosiecki/httpscreenshot

FROM ubuntu:20.04

MAINTAINER Jesse Osiecki <jesse@jjo.ninja>

RUN mkdir -p /etc/httpscreenshot
WORKDIR /etc/httpscreenshot

COPY . /etc/httpscreenshot/

RUN apt-get update && apt-get install --no-install-recommends -y wget libfontconfig && rm -rf /var/lib/apt/lists/*;

RUN ./install-dependencies.sh

RUN chmod +x httpscreenshot.py
RUN ln -s /etc/httpscreenshot/httpscreenshot.py /usr/bin/httpscreenshot

RUN mkdir -p /etc/httpscreenshot/images
WORKDIR /etc/httpscreenshot/images

ENTRYPOINT ["httpscreenshot"]
