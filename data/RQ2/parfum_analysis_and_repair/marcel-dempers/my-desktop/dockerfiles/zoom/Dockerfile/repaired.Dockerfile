FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update
RUN apt-get -qy dist-upgrade

# Dependencies for the client .deb
RUN apt-get install --no-install-recommends -qy curl sudo desktop-file-utils lib32z1 \
  libx11-6 libasound2-dev libegl1-mesa libxcb-shm0 \
  libglib2.0-0 libgl1-mesa-glx libxrender1 libxcomposite1 libxslt1.1 \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxi6 libsm6 \
  libfontconfig1 libpulse0 libsqlite3-0 \
  libxcb-shape0 libxcb-xfixes0 libxcb-randr0 libxcb-image0 \
  libxcb-keysyms1 libxcb-xtest0 ibus ibus-gtk libibus-qt1 ibus-qt4 \
  libnss3 libxss1 && rm -rf /var/lib/apt/lists/*;

# install some GL gfx deps
RUN apt-get install --no-install-recommends -y mesa-utils && rm -rf /var/lib/apt/lists/*;

ARG ZOOM_URL=https://zoom.us/client/latest/zoom_amd64.deb

# Grab the client .deb
# Install the client .deb
# Cleanup
RUN curl -f -sSL $ZOOM_URL -o /tmp/zoom_setup.deb
RUN dpkg -i /tmp/zoom_setup.deb
RUN apt-get -f -y install
RUN rm /tmp/zoom_setup.deb \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]