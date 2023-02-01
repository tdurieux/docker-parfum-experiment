# specify the base image for builder
FROM arm64v8/ubuntu:18.04 as builder

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install -y git curl jq

# Create app directory
WORKDIR /usr/src/app

# checkout git source 
RUN git clone https://github.com/Jasonhcwong/RPi-Monitor-Monerobox.git
RUN mkdir source && cd RPi-Monitor-Monerobox && git checkout container

# Copy executable file
RUN mv /usr/src/app/RPi-Monitor-Monerobox/src/usr/bin/* /usr/src/app/source/

# Copy web files
RUN mv /usr/src/app/RPi-Monitor-Monerobox/src/usr/share/rpimonitor/web /usr/src/app/source/

# Copy config files
RUN mv /usr/src/app/RPi-Monitor-Monerobox/src/etc /usr/src/app/source/

# Create folder for datastore and log
RUN mkdir -p /usr/src/app/source/data
RUN mkdir -p /usr/src/app/source/log


# specify the base image for web
FROM arm64v8/ubuntu:18.04

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install -y perl librrds-perl libhttp-daemon-perl libjson-perl libipc-sharelite-perl libfile-which-perl libsnmp-extension-passpersist-perl systemd jq curl libltdl7 python-pip libffi-dev

# Create app directory
WORKDIR /usr/src/app

# install docker-compose
RUN pip install docker-compose

# Copy files from builder
COPY --from=builder /usr/src/app/source .

# Expose port
EXPOSE 80

ENTRYPOINT ["/usr/src/app/rpimonitord", "-c", "/usr/src/app/etc/rpimonitor/daemon.conf",  "-c", "/usr/src/app/etc/rpimonitor/template/monerobox.conf"]

