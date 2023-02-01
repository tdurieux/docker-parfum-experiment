FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y init gpg ca-certificates sudo curl \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*;

# Adding fake systemctl
RUN curl -f https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -o /usr/local/bin/systemctl
