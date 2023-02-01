FROM solita/ubuntu-systemd
MAINTAINER Keybase <admin@keybase.io>

RUN apt-get update

# Install dependencies for keybase
RUN apt-get install --no-install-recommends -y libappindicator1 fuse libgconf-2-4 psmisc procps lsof && rm -rf /var/lib/apt/lists/*;

# Nice to have
RUN apt-get install --no-install-recommends -y vim less curl && rm -rf /var/lib/apt/lists/*;

