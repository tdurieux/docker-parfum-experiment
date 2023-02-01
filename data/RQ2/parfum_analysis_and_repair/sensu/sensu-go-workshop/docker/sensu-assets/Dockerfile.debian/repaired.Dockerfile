FROM debian:stretch
ARG WORKSHOP_PASSWORD=${WORKSHOP_PASSWORD:-workshop}

# Install
RUN \
  apt-get update && apt-get install --no-install-recommends -y curl ca-certificates samba && \
  whereis samba && rm -rf /var/lib/apt/lists/*;

# Configure
RUN \
  useradd -mr -s /bin/bash -d /home/sensu sensu && \
  mkdir /home/sensu/assets && \
  chown -R sensu:sensu /home/sensu/assets && \
  printf "${WORKSHOP_PASSWORD}\n${WORKSHOP_PASSWORD}\n" | smbpasswd -a sensu

# Run
CMD smbd --foreground --log-stdout --configfile /etc/samba/smb.conf
