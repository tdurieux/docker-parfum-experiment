FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 curl openssh-server && rm -rf /var/lib/apt/lists/*;

# Install BOSH v2 CLI
RUN curl -f -sSL -o /usr/local/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.45-linux-amd64
RUN chmod +x /usr/local/bin/bosh
