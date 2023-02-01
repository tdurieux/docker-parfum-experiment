# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# install samba and s6; create supporting directories
RUN apk add --no-cache attr avahi avahi-compat-libdns_sd avahi-tools dbus samba-common-tools s6 samba-server &&\
  touch /etc/samba/lmhosts &&\
  rm /etc/samba/smb.conf &&\
  rm /etc/avahi/services/*.service

# copy in necessary supporting config files