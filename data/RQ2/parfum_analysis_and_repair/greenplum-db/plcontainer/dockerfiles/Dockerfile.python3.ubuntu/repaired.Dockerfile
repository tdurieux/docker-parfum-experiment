FROM ubuntu:18.04

RUN mkdir -p /clientdir
RUN apt update && apt install --no-install-recommends -y python3.7 python3.7-dev python3-pip && rm -rf /var/lib/apt/lists/*;

ENV PATH "${PATH:+:${PATH}}"
ENV LD_LIBRARY_PATH "/usr/lib/python3.7${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
ENV MANPATH "${MANPATH}"
ENV XDG_DATA_DIRS "${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
ENV PKG_CONFIG_PATH "${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
RUN python3.7 -m pip install nltk
RUN python3.7 -m nltk.downloader all
WORKDIR /clientdir
