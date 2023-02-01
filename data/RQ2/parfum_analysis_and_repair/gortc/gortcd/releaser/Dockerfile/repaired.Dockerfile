FROM golang:latest

RUN apt-get update && \
  apt-get dist-upgrade --yes && \
  apt-get install --no-install-recommends --yes \
  curl sudo jq squashfs-tools ca-certificates snapd rsync gpg software-properties-common \
  python3 \
  apt-transport-https wget && \
  curl -f -L $( curl -f -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap && \
  mkdir -p /snap/core && unsquashfs -d /snap/core/current core.snap && rm core.snap && \
  curl -f -L $( curl -f -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap && \
  mkdir -p /snap/snapcraft && unsquashfs -d /snap/snapcraft/current snapcraft.snap && rm snapcraft.snap && \
  apt-get autoclean --yes && \
  apt-get clean --yes && rm -rf /var/lib/apt/lists/*;

COPY bin/snapcraft-wrapper /snap/bin/snapcraft


ENV SNAP=/snap/snapcraft/current
ENV SNAP_NAME=snapcraft
ENV PATH=/snap/bin:$PATH

# Installing docker.
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
 apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

# Installing goreleaser.
RUN wget -q https://github.com/goreleaser/goreleaser/releases/download/v0.133.0/goreleaser_amd64.deb && dpkg -i goreleaser_amd64.deb
