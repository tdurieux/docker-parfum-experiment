FROM ubuntu
MAINTAINER Keybase <admin@keybase.io>

RUN apt-get update

# Install dependencies for keybase
RUN apt-get install --no-install-recommends -y libappindicator1 fuse libgconf-2-4 psmisc procps lsof && rm -rf /var/lib/apt/lists/*;

# Nice to have
RUN apt-get install --no-install-recommends -y vim less curl sudo && rm -rf /var/lib/apt/lists/*;

run useradd -m kb -G sudo -s /bin/bash -p $(echo pw | openssl passwd -1 -stdin)
run echo -e "alias dlnightly='curl -O https://prerelease.keybase.io/nightly/keybase_amd64.deb'\nalias dlrelease='curl -O https://prerelease.keybase.io/keybase_amd64.deb'" >> /home/kb/.bashrc
