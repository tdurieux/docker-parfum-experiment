# Houston extract deb docker file
# Extracts a debian package to editable files
#
# Version: 1.0.2

FROM elementary/docker:loki-stable

# Install liftoff
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

COPY extract-deb.sh /usr/local/bin/extract-deb
RUN chmod +x /usr/local/bin/extract-deb

# Execution