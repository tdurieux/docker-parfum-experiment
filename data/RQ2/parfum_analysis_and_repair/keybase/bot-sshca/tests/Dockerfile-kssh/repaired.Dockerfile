# This dockerfile builds a container capable of running kssh. Note that a lot of this code is duplicated
# between this file and Dockerfile-ca.
FROM ubuntu:18.04

# Dependencies
RUN apt-get -qq update
RUN apt-get -qq --no-install-recommends install curl software-properties-common ca-certificates gnupg -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash keybase
USER keybase
WORKDIR /home/keybase

# Download and verify the deb
RUN curl -f --remote-name https://prerelease.keybase.io/keybase_amd64.deb
RUN curl -f --remote-name https://prerelease.keybase.io/keybase_amd64.deb.sig
# Import our gpg key from our website. Pulling from key servers caused a flakey build so
# we get the key from the Keybase website instead.
RUN curl -f -sSL https://keybase.io/docs/server_security/code_signing_key.asc | gpg --batch --import
# This line will error if the fingerprint of the key in the file does not match the
# known fingerprint of the our PGP key
RUN gpg --batch --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7
# And then verify the signature now that we have the key
RUN gpg --batch --verify keybase_amd64.deb.sig keybase_amd64.deb

# Silence the error from dpkg about failing to configure keybase since `apt-get install -f` fixes it
USER root
RUN dpkg -i keybase_amd64.deb || true
RUN apt-get install -fy
USER keybase

# Install go
USER root
RUN add-apt-repository ppa:gophers/archive -y
RUN apt-get update -y
RUN apt-get install --no-install-recommends golang-1.11-go git sudo python3 python3-pip sudo -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pytest requests

# Make it so the keybase user has passwordless sudo so it can move the keybase binary around
RUN echo "keybase ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/keybase && \
    chmod 0440 /etc/sudoers.d/keybase

# Install go dependencies (speeds up future builds)
COPY --chown=keybase go.mod .
COPY --chown=keybase go.sum .
RUN /usr/lib/go-1.11/bin/go mod download

COPY --chown=keybase ./ /home/keybase/
RUN /usr/lib/go-1.11/bin/go build -o bin/kssh src/cmd/kssh/kssh.go

USER root
