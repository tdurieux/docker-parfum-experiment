FROM ubuntu:18.04

EXPOSE 8080

RUN mkdir -p /clientdir
RUN apt update && apt install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

ENV PATH "${PATH:+:${PATH}}"
ENV LD_LIBRARY_PATH "/usr/lib/python2.7${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
ENV MANPATH "${MANPATH}"
ENV XDG_DATA_DIRS "${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
ENV PKG_CONFIG_PATH "${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"

WORKDIR /clientdir
