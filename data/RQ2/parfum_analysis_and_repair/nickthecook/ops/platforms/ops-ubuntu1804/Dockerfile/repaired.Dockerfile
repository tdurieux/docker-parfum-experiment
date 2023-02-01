FROM ubuntu:bionic

RUN apt-get update
# dependencies for installing ops
RUN apt-get install --no-install-recommends -y ruby ruby-dev build-essential git && rm -rf /var/lib/apt/lists/*;
# dependencies for running ops
RUN apt-get install --no-install-recommends -y keychain && rm -rf /var/lib/apt/lists/*;

WORKDIR /ops
RUN gem install --no-ri --no-rdoc ops_team

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
