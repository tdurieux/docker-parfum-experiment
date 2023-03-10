# You can generate binaries for other platforms with gox

FROM ubuntu
MAINTAINER Henrique Vicente <henriquevicente@gmail.com>

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8 locale
RUN echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    imagemagick \
    webp && rm -rf /var/lib/apt/lists/*;

ADD picel_linux_amd64 /bin/picel
EXPOSE 8123
ENTRYPOINT picel
