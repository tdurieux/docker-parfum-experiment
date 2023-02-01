FROM qt_ubuntu_16.04
ARG packages="avahi-daemon apache2 libcgi-session-perl"
RUN apt-get update && apt-get install --no-install-recommends -y $packages && dpkg -l $packages && rm -rf /var/lib/apt/lists/*;
EXPOSE 80 443

# install configurations and test data

COPY rfc3252.txt .
