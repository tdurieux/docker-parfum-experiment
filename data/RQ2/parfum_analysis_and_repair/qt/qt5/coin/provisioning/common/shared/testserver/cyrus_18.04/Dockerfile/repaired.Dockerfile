FROM qt_ubuntu_18.04
ARG packages="avahi-daemon cyrus-imapd"
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y $packages && dpkg -l $packages && rm -rf /var/lib/apt/lists/*;
EXPOSE 143 993
