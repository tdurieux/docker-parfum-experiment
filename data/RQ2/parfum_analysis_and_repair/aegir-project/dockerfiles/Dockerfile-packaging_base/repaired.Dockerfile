FROM debian:jessie

RUN apt-get update
RUN apt-get install --no-install-recommends --yes devscripts build-essential debian-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes git-core git-buildpackage dh-systemd && rm -rf /var/lib/apt/lists/*;


