# specify the base image for builder
FROM arm64v8/ubuntu:18.04 as builder

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install --no-install-recommends -y git curl jq && rm -rf /var/lib/apt/lists/*;

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
RUN mkdir -p /usr/src/app/source/data && rm -rf /usr/src/app/source/data
RUN mkdir -p /usr/src/app/source/log && rm -rf /usr/src/app/source/log


# specify the base image for web
FROM moneroboxdev/docker-compose:1.24.0

# Create app directory
WORKDIR /usr/src/app

# Copy files from builder
COPY --from=builder /usr/src/app/source .

ENTRYPOINT ["/usr/src/app/rpimonitord", "-c", "/usr/src/app/etc/rpimonitor/daemon.conf",  "-c", "/usr/src/app/etc/rpimonitor/template/monerobox.conf"]

