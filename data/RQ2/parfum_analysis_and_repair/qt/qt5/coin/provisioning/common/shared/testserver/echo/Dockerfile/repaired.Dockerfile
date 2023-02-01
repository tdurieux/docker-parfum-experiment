FROM qt_ubuntu_16.04
ARG packages="avahi-daemon xinetd"
RUN apt-get update && apt-get install --no-install-recommends -y $packages && dpkg -l $packages && rm -rf /var/lib/apt/lists/*;
EXPOSE 7 7/UDP 13
