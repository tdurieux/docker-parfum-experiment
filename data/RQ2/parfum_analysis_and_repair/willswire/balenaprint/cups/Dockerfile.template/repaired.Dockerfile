FROM balenalib/%%BALENA_MACHINE_NAME%%:build

# Install the packages we need. Avahi will be included
RUN install_packages \
    cups \
    iptables \
    avahi-daemon \
    dbus \
    libnss-mdns \
    foomatic-db-compressed-ppds \
    printer-driver-gutenprint \
    printer-driver-brlaser \
    hplip \
    hplip-data \
    libcups2-dev \
    build-essential 

# Add support for Samsung printers via Splix
WORKDIR /usr/src/app

RUN git clone https://gitlab.com/ScumCoder/splix.git

WORKDIR /usr/src/app/splix/splix

RUN sudo make DISABLE_JBIG=1 && \
    sudo make install && \
    cp ./ppd/m2020.ppd /usr/share/ppd/custom

WORKDIR /

# Add script
COPY run.sh /

# Enable USB devices
ENV UDEV 1

# Add cupsd.conf file
COPY cupsd.conf /etc/cups/cupsd.conf

# Link DBUS file where hp-setup expects it
RUN ln -s /host/run/dbus /var/run/dbus

#Run Script
CMD ["bash", "run.sh"]