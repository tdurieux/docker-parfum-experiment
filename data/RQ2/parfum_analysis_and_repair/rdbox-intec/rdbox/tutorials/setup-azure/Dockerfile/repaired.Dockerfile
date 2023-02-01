FROM ubuntu:18.04

MAINTAINER rdbox <info-rdbox@intec.co.jp>

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get -y --no-install-recommends install sudo curl python ssh git dnsutils vim ipcalc && \
    cd /tmp && \
    curl -f -L -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install --no-cache-dir awscli && \
    echo "Please install some packages as you like" && \
    echo "e.g. 'apt-get -y install less locate'" && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get -y --no-install-recommends install jq ca-certificates curl apt-transport-https lsb-release gnupg && \
    curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --batch --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends azure-cli && rm -rf /var/lib/apt/lists/*;
#
