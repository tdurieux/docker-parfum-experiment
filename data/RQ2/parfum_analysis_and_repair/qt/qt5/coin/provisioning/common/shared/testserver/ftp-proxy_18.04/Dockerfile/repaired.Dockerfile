FROM qt_ubuntu_18.04
ARG packages="avahi-daemon ftp-proxy"
RUN apt-get update && apt-get install --no-install-recommends -y $packages && dpkg -l $packages && rm -rf /var/lib/apt/lists/*;
EXPOSE 2121
