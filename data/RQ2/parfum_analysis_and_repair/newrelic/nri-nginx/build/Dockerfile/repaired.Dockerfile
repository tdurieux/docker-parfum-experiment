FROM golang:1.18

ARG GH_VERSION='1.9.2'

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        rpm \
        gnupg2 \
        gpg-agent \
        debsigs \
        unzip \
        zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.deb -o gh_${GH_VERSION}_linux_amd64.deb
RUN dpkg -i gh_${GH_VERSION}_linux_amd64.deb
