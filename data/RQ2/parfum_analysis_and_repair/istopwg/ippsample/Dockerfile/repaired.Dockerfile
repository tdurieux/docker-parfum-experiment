FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get install --no-install-recommends -y build-essential autoconf avahi-daemon avahi-utils cura-engine libavahi-client-dev libjpeg-dev libnss-mdns libpam-dev libpng-dev libssl-dev libusb-1.0-0-dev zlib1g-dev net-tools iputils-ping vim avahi-daemon tcpdump man curl && rm -rf /var/lib/apt/lists/*;
RUN /bin/echo 'colorscheme blue' > ~/.vimrc
RUN /bin/echo "LS_COLORS=\$LS_COLORS:'di=0;31:' ; export LS_COLORS" >> /root/.bashrc
# Make changes necessary to run bonjour
RUN sed -ie 's/rlimit-nproc=3/rlimit-nproc=8/' /etc/avahi/avahi-daemon.conf
RUN update-rc.d dbus defaults
RUN update-rc.d avahi-daemon defaults

# Create entrypoint.sh script to start dbus and avahi-daemon
RUN echo '#!/bin/bash\n\
service dbus start\n\
service avahi-daemon start\n\
$*\n\
' > /usr/bin/entrypoint.sh && chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Copy source files to image
COPY . /root/ippsample/
RUN cd /root/ippsample; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr; make; make install
