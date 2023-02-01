FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install git sed curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN GITHUB_CLI_VERSION=0.6.1 && \
    curl -f -sL -o /root/gh.deb https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.deb && \
    dpkg -i /root/gh.deb && \
    rm /root/gh.deb

